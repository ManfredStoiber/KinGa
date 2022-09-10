import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/students_cubit.dart';
import 'package:kinga/util/date_utils.dart';

class AbsenceDialog extends StatefulWidget {
  AbsenceDialog(this.studentId, {Key? key}) : super(key: key);

  String studentId;

  @override
  State<AbsenceDialog> createState() => _AbsenceDialogState();
}

class _AbsenceDialogState extends State<AbsenceDialog> {
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateUntilController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.absence),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            String dateFromFormatted = IsoDateUtils.getIsoDateFromGermanDate(_dateFromController.text);
            String dateUntilFormatted = IsoDateUtils.getIsoDateFromGermanDate(_dateUntilController.text);
            BlocProvider.of<StudentsCubit>(context).createAbsence(widget.studentId, Absence(dateFromFormatted, dateUntilFormatted, true)).then((value) {
              Navigator.of(context).pop();
            }); // TODO: sickness switch
            // TODO: What if network connection is slow and you close dialog manually? Will the next element of Navigator be popped then?
          },
          child: Text(Strings.enter),
        )
      ],
      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Row(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: TextField(
                    controller: _dateFromController,
                    decoration: InputDecoration(
                        labelText: Strings.start,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: Strings.date_format,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => pickDateRange(context),
                          icon: Icon(Icons.edit_calendar),
                        )),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 5),
                child: TextField(
                  controller: _dateUntilController,
                  decoration: InputDecoration(
                      labelText: Strings.end,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: Strings.date_format,
                      suffixIcon: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => pickDateRange(context),
                        icon: Icon(Icons.edit_calendar),
                      )),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  pickDateRange(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1 * 356)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: Localizations.localeOf(context),
    ).then((value) {
      setState(() {
        if (value != null) {
          _dateFromController.text = DateFormat('dd.MM.yyyy').format(value.start);
          _dateUntilController.text = DateFormat('dd.MM.yyyy').format(value.end);
        } else {
          _dateFromController.text = Strings.date_format;
          _dateUntilController.text = Strings.date_format;
        }
      });
    });
  }
}
