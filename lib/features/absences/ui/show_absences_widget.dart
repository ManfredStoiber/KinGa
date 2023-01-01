import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/features/absences/ui/bloc/absences_cubit.dart';
import 'package:kinga/features/absences/ui/create_absence_dialog.dart';
import 'package:kinga/features/absences/ui/edit_absence_dialog.dart';
import 'package:kinga/ui/widgets/loading_indicator.dart';
import 'package:kinga/ui/widgets/slide_menu.dart';
import 'package:kinga/util/date_utils.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowAbsencesWidget extends StatefulWidget {
  const ShowAbsencesWidget(this.studentId, this.selectedDayFrom, {Key? key, this.selectedDayUntil}) : super(key: key);

  final String studentId;
  final DateTime selectedDayFrom;
  final DateTime? selectedDayUntil;

  @override
  State<ShowAbsencesWidget> createState() => ShowAbsencesWidgetState();

}

class ShowAbsencesWidgetState extends State<ShowAbsencesWidget> {

  AbsencesState state = AbsencesInitial();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AbsencesCubit(widget.studentId, DateTime.now(), DateTime.now()),
  child: BlocBuilder<AbsencesCubit, AbsencesState>(
      builder: (context, state) {
        this.state = state;
        if (state is AbsencesLoaded) {
          AbsencesCubit cubit = BlocProvider.of<AbsencesCubit>(context);
          onDelete(index) {
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
                cubit.removeAbsence(widget.studentId, state.selectedAbsences.elementAt(index));
              }
            });
          }
          onEdit(index) {
            showDialog(context: context, builder: (context) => EditAbsenceDialog(widget.studentId, state.selectedAbsences.elementAt(index)),);
          }
          return Column(children: [
            TableCalendar(
            availableGestures: AvailableGestures.none,
            locale: Keys.locale,
            focusedDay: state.focusedDay,
            firstDay: state.firstDay,
            lastDay: state.lastDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {CalendarFormat.month: ''},
            selectedDayPredicate: (day) => isSameDay(state.focusedDay, day),
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
                  bool selected = (cubit.state is AbsencesLoaded && normalizeDate((cubit.state as AbsencesLoaded).focusedDay).isAtSameMomentAs(day));
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
            const Divider(),
            if (state.selectedAbsences.isEmpty) Column(
              children: [
                Container(margin: const EdgeInsets.all(30), width: 100, child: SimpleShadow(child: Opacity(opacity: 0.4, child: Image.asset('assets/images/no_absences.png')))),
                Text(Strings.noAbsences, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
                Container(margin: const EdgeInsets.all(20), child: Text(Strings.noAbsencesDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
              ],
            ) else ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemCount: state.selectedAbsences.length,
                itemBuilder: (context, index) => SlideMenu(
                  key: UniqueKey(),
                  menuItems: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      margin: Theme
                          .of(context)
                          .cardTheme
                          .margin,
                      child: ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorSchemes.kingacolor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              )
                          ),
                          onLongPress: () => onEdit(index),
                          onPressed: () => onEdit(index),
                          child: const Icon(Icons.edit)
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      margin: Theme
                          .of(context)
                          .cardTheme
                          .margin,
                      child: ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorSchemes.errorColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              )
                          ),
                          onLongPress: () => onDelete(index),
                          onPressed: () => onDelete(index),
                          child: const Icon(Icons.delete)
                      ),
                    ),
                  ],
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(state.selectedAbsences.elementAt(index).from)),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabled: false,
                                  labelText: Strings.start
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(text: IsoDateUtils.getGermanDateFromIsoDate(state.selectedAbsences.elementAt(index).until)),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabled: false,
                                  labelText: Strings.end
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(text: state.selectedAbsences.elementAt(index).reason),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabled: false,
                                labelText: Strings.reason,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],);
        } else if (state is AbsencesError) {
          return Text("TODO"); // TODO
        } else {
          return const LoadingIndicator();
        }
      },
  ),
    );

  }

  void onFloatingActionButtonPressed() {
    if (state is AbsencesLoaded) {
      var state = (this.state as AbsencesLoaded);
      showDialog(context: context, builder: (context) => CreateAbsenceDialog(state.student.studentId, state.focusedDay), );
    }
  }

  bool existsAbsenceBefore(DateTime day, List<Absence> absences) {
    return absences.any((absence) => DateTime.parse(absence.from).isBefore(day.toLocal().subtract(day.toLocal().timeZoneOffset))); // convert UTC Time to local time without timeZoneOffset

  }

  bool existsAbsenceAfter(DateTime day, List<Absence> absences) {
    return absences.any((absence) => DateTime.parse(absence.until).isAfter(day.toLocal().subtract(day.toLocal().timeZoneOffset))); // convert UTC Time to local time without timeZoneOffset
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
        color: ColorSchemes.kingaGrey.withAlpha(150),
        shape: BoxShape.circle,
      ),
    );
  }

}

