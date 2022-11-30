import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';

import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/features/absences/ui/absence_dialog.dart';
import 'package:kinga/features/absences/ui/bloc/absences_cubit.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/util/date_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class AbsenceScreen extends StatelessWidget {
  const AbsenceScreen(this.studentId, {Key? key}) : super(key: key);

  final String studentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AbsencesCubit(studentId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.absences),
        ),
        floatingActionButton: BlocBuilder<AbsencesCubit, AbsencesState>(
          builder: (context, state) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                if (state is AbsencesLoaded) {
                  showDialog(context: context, builder: (context) => AbsenceDialog(state.student.studentId, state.selectedDay), );
                }
              },
            );
          },
        ),
        body: BlocBuilder<AbsencesCubit, AbsencesState>(
          builder: (context, state) {
            if (state is AbsencesLoaded) {
              AbsencesCubit cubit = BlocProvider.of<AbsencesCubit>(context);
              return Column(
                children: [
                  TableCalendar(
                    locale: Keys.locale,
                    focusedDay: state.focusedDay,
                    firstDay: state.firstDay,
                    lastDay: state.lastDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    availableCalendarFormats: const {CalendarFormat.month: ''},
                    selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      cubit.changeSelectedDay(selectedDay);
                    },
                    calendarFormat: state.calendarFormat,
                    onFormatChanged: (format) => state.calendarFormat = format,
                    onPageChanged: (focusedDay) {
                      state.focusedDay = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: <Absence>(context, day, absences) {
                        if (absences.length > 0) {
                          bool today = normalizeDate(DateTime.now()).isAtSameMomentAs(day);
                          bool selected = (cubit.state is AbsencesLoaded && normalizeDate((cubit.state as AbsencesLoaded).selectedDay).isAtSameMomentAs(day));
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    color: ColorSchemes.absentColor,
                                    shape: BoxShape.circle
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: existsAbsenceBefore(day, absences) ? Container(
                                      color: ColorSchemes.absentColor,
                                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                                    ) : Container(),
                                  ),
                                  Expanded(
                                    child: existsAbsenceAfter(day, absences) ? Container(
                                      color: ColorSchemes.absentColor,
                                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                                    ) : Container(),
                                  ),
                                ],
                              ),
                              today ? todayWidget() : Container(),
                              selected ? selectedDayWidget() : Container(),
                              Center(child: Text(day.day.toString())),
                            ],
                          );
                        } else {
                          return null;
                        }
                      },
                      selectedBuilder: (context, day, focusedDay) => Stack(
                        children: [
                          selectedDayWidget(),
                          Center(child: Text(day.day.toString())),
                        ],
                      ),
                      todayBuilder: (context, day, focusedDay) => Stack(
                        children: [
                          todayWidget(),
                          Center(child: Text(day.day.toString())),
                        ],
                      ),
                    ),
                    eventLoader: (day) {
                      return cubit.getAbsencesOfDay(state.student.absences, day).toList();
                    },
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<Absence>>(valueListenable: state.selectedAbsences, builder: (context, value, child) => Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: value.length,
                            itemBuilder: (context, index) => Card(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IntrinsicWidth(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(value.elementAt(index).from)),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              enabled: false,
                                              labelText: Strings.start
                                          ),
                                        ),
                                      ),
                                      IntrinsicWidth(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(value.elementAt(index).until)),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              enabled: false,
                                              labelText: Strings.end
                                          ),
                                        ),
                                      ),
                                      IntrinsicWidth(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(text: value.elementAt(index).sickness ? "Krankmeldung" : "Urlaub"), // TODO
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            enabled: false,
                                            labelText: Strings.reason,
                                          ),
                                        ),
                                      ),
                                      IconButton(onPressed: () {
                                        showDialog(context: context, builder: (context) => AlertDialog(
                                          title: const Text(Strings.removeAbsence),
                                          actions: [
                                            TextButton(onPressed: () {
                                              Navigator.of(context).pop(false);
                                            }, child: const Text(Strings.cancel)),
                                            TextButton(onPressed: () {
                                              Navigator.of(context).pop(true);
                                            }, child: const Text(Strings.confirm)),
                                          ],
                                        ),).then((confirmed) {
                                          if (confirmed ?? false) {
                                            cubit.removeAbsence(studentId, value.elementAt(index));
                                          }
                                        });
                                      },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: ColorSchemes.errorColor,
                                          ))
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),),
                  )
                ],
              );
            } else if (state is AbsencesError) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Navigator.of(context).pop()); // close screen on error
              return Container();
            } else {
              return const LoadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget selectedDayWidget() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: ColorSchemes.kingacolor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget todayWidget() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorSchemes.kingacolor.withAlpha(150),
        shape: BoxShape.circle,
      ),
    );
  }

  bool existsAbsenceBefore(DateTime day, List<Absence> absences) {
    return absences.any((absence) => DateTime.parse(absence.from).isBefore(day.toLocal().subtract(day.toLocal().timeZoneOffset))); // convert UTC Time to local time without timeZoneOffset

  }

  bool existsAbsenceAfter(DateTime day, List<Absence> absences) {
    return absences.any((absence) => DateTime.parse(absence.until).isAfter(day.toLocal().subtract(day.toLocal().timeZoneOffset))); // convert UTC Time to local time without timeZoneOffset
  }

}