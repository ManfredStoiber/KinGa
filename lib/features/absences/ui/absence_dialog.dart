import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/ui/bloc/students_cubit.dart';
import 'package:kinga/util/date_utils.dart';

class AbsenceDialog extends StatelessWidget {

  final String studentId;
  final DateTime selectedDay;

  const AbsenceDialog(this.studentId, this.selectedDay, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateFrom = selectedDay;
    DateTime dateUntil = selectedDay;
    TextEditingController dateFromController = TextEditingController(text: IsoDateUtils.getGermanDateFromDateTime(dateFrom));
    TextEditingController dateUntilController = TextEditingController(text: IsoDateUtils.getGermanDateFromDateTime(dateUntil));

    DateTime firstDay = selectedDay.subtract(const Duration(days: 365));
    DateTime lastDay = selectedDay.add(const Duration(days: 365));

    return AlertDialog(
      title: const Text(Strings.absence),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            String dateFromFormatted = IsoDateUtils.getIsoDateFromGermanDate(dateFromController.text);
            String dateUntilFormatted = IsoDateUtils.getIsoDateFromGermanDate(dateUntilController.text);
            BlocProvider.of<StudentsCubit>(context).createAbsence(studentId, Absence(dateFromFormatted, dateUntilFormatted, true)).then((value) {
              Navigator.of(context).pop();
            }); // TODO: sickness switch
            // TODO: What if network connection is slow and you close dialog manually? Will the next element of Navigator be popped then?
          },
          child: const Text(Strings.enter),
        )
      ],
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Row(),
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
        ],
      ),
    );
  }
}
