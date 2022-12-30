import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator_dialog.dart';
import 'package:kinga/util/date_utils.dart';

class EditAbsenceDialog extends StatefulWidget {

  final String studentId;
  final Absence absence;

  const EditAbsenceDialog(this.studentId, this.absence, {Key? key}) : super(key: key);

  @override
  State<EditAbsenceDialog> createState() => _EditAbsenceDialogState();
}

class _EditAbsenceDialogState extends State<EditAbsenceDialog> {

  String _selectedReason = Strings.sicknote;

  @override
  Widget build(BuildContext context) {
    DateTime dateFrom = DateTime.parse(widget.absence.from);
    DateTime dateUntil = DateTime.parse(widget.absence.until);
    TextEditingController dateFromController = TextEditingController(text: IsoDateUtils.getGermanDateFromDateTime(dateFrom));
    TextEditingController dateUntilController = TextEditingController(text: IsoDateUtils.getGermanDateFromDateTime(dateUntil));

    DateTime firstDay = dateFrom.subtract(const Duration(days: 365));
    DateTime lastDay = dateFrom.add(const Duration(days: 365));

    return AlertDialog(
      title: const Text(Strings.absence),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            LoadingIndicatorDialog.show(context);
            String dateFromFormatted = IsoDateUtils.getIsoDateFromGermanDate(dateFromController.text);
            String dateUntilFormatted = IsoDateUtils.getIsoDateFromGermanDate(dateUntilController.text);
            BlocProvider.of<StudentsCubit>(context).updateAbsence(widget.studentId, widget.absence, Absence(dateFromFormatted, dateUntilFormatted, _selectedReason)).then((value) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: TextField(
                    readOnly: true,
                    controller: dateFromController,
                    onTap: () => showDatePicker(context: context, initialDate: dateFrom, firstDate: firstDay, lastDate: lastDay).then((value) {
                      if (value != null) {
                        dateFrom = value;
                        dateFromController.text = IsoDateUtils.getGermanDateFromDateTime(value);

                        if (dateFrom.isAfter(dateUntil)) {
                          dateUntil = dateFrom;
                          dateUntilController.text = IsoDateUtils.getGermanDateFromDateTime(dateUntil);
                        }
                      }
                    }),
                    decoration: const InputDecoration(
                        labelText: Strings.end,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: Strings.date_format,
                        suffixIcon: Icon(Icons.edit_calendar,)
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextField(
                      readOnly: true,
                      controller: dateUntilController,
                      focusNode: null,
                      onTap: () => showDatePicker(context: context, initialDate: dateUntil, firstDate: firstDay, lastDate: lastDay).then((value) {
                        if (value != null) {
                          dateUntil = value;
                          dateUntilController.text = IsoDateUtils.getGermanDateFromDateTime(value);

                          if (dateFrom.isAfter(dateUntil)) {
                            dateFrom = dateUntil;
                            dateFromController.text = IsoDateUtils.getGermanDateFromDateTime(dateFrom);
                          }
                        }
                      }),
                      decoration: const InputDecoration(
                          labelText: Strings.end,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: Strings.date_format,
                          suffixIcon: Icon(Icons.edit_calendar,)
                      ),
                    ),
                  )),
            ],
          ),
          DropdownButtonFormField<String>(
            value: _selectedReason,
            items: const [DropdownMenuItem(value: Strings.sicknote, child: Text(Strings.sicknote)), DropdownMenuItem(value: Strings.vacation, child: Text(Strings.vacation)), DropdownMenuItem(value: Strings.other, child: Text(Strings.other))],
            onChanged: (String? newValue) {
              setState(() {
                _selectedReason = newValue!;
              });
            },
            decoration: const InputDecoration(
                labelText: Strings.reason,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.category_outlined)
            ),
          ),
        ],
      ),
    );
  }
}
