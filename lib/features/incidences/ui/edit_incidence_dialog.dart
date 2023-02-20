import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/util/date_utils.dart';

class EditIncidenceDialog extends StatefulWidget {
  const EditIncidenceDialog(this.studentId, this.incidence, {Key? key}) : super(key: key);

  final String studentId;
  final Incidence incidence;

  @override
  State<EditIncidenceDialog> createState() => _EditIncidenceDialogState();
}

class _EditIncidenceDialogState extends State<EditIncidenceDialog> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> descriptionKey = GlobalKey<FormState>();
  String _selectedCategory = Strings.achievement;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.incidence.category;
    _timeController.text = IsoDateUtils.getIsoTimeFromIsoDateTime(widget.incidence.dateTime);
    _descriptionController.text = widget.incidence.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.incidence),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            if (descriptionKey.currentState?.validate() ?? false) {
              LoadingIndicatorDialog.show(context);
              String dateTime = "${IsoDateUtils.getIsoDateFromIsoDateTime(widget.incidence.dateTime)}T${_timeController.text}";
              Incidence incidence = Incidence(dateTime, _descriptionController.text.trim(), _selectedCategory);
              GetIt.I<StudentService>().updateIncidence(widget.studentId, widget.incidence, incidence).then((value) {
                GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsEditIncidence);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }
          },
          child: const Text(Strings.enter),
        )
      ],
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IntrinsicWidth(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: const [DropdownMenuItem(value: Strings.achievement, child: Text(Strings.achievement)), DropdownMenuItem(value: Strings.accident, child: Text(Strings.accident)), DropdownMenuItem(value: Strings.other, child: Text(Strings.other))],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: Strings.category,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(Icons.category_outlined)
                    ),
                ),
              ),
              const Spacer(),
              IntrinsicWidth(
                  child: TextFormField(
                    readOnly: true,
                    controller: _timeController,
                    onTap: () => showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now())).then((value) {
                      if (value != null) {
                        _timeController.text = IsoDateUtils.getTimeFromTimeOfDay(value);
                      }
                    }),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: Strings.time,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.access_time_outlined)
                  ),
                  ),
              ),
            ],
          ),
          Container(height: 20,),
          Scrollbar(
            child: Form(
              key: descriptionKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _descriptionController,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                scrollPadding: const EdgeInsets.all(100),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: Strings.description,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return Strings.requiredDescription;
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
