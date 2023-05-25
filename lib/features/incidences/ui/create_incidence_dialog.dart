import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/util/date_utils.dart';

class CreateIncidenceDialog extends StatefulWidget {
  const CreateIncidenceDialog(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  State<CreateIncidenceDialog> createState() => _CreateIncidenceDialogState();
}

class _CreateIncidenceDialogState extends State<CreateIncidenceDialog> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> descriptionKey = GlobalKey<FormState>();
  String _selectedCategory = Strings.achievement;

  @override
  Widget build(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());
    _timeController.text = IsoDateUtils.getTimeFromTimeOfDay(selectedTime);

    return AlertDialog(
      title: const Text(Strings.incidence),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            if (descriptionKey.currentState?.validate() ?? false) {
              String dateTime = "${IsoDateUtils.getIsoDateFromIsoDateTime(DateTime.now().toIso8601String())}T${_timeController.text}";
              Incidence incidence = Incidence(dateTime, _descriptionController.text.trim(), _selectedCategory);
              GetIt.I<StudentService>().createIncidence(widget.studentId, incidence).then((value) {
                GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsCreateIncidence);
                context.pop(incidence);
              }); // TODO: What if network connection is slow and you close dialog manually? Will the next element of Navigator be popped then?
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
