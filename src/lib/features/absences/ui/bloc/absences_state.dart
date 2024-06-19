part of 'absences_cubit.dart';


abstract class AbsencesState {
  const AbsencesState();
}

class AbsencesInitial extends AbsencesState {}
class AbsencesLoading extends AbsencesState {}
class AbsencesLoaded extends AbsencesState {

  final StudentService _studentService = GetIt.I<StudentService>();

  //late final ValueNotifier<List<Absence>> selectedAbsences;
  late final List<Absence> selectedAbsences;

  DateTime firstDay = DateTime.now().subtract(const Duration(days: 365)); // first day in range
  DateTime lastDay = DateTime.now().add(const Duration(days: 365)); // last day in range
  DateTime selectedDayFrom = DateTime.now();
  DateTime? selectedDayUntil;
  DateTime focusedDay = DateTime.now(); //
  CalendarFormat calendarFormat = CalendarFormat.month;

  final Student student;

  AbsencesLoaded(this.student, this.selectedDayFrom, [this.selectedDayUntil]) {
    focusedDay = selectedDayFrom;
    var filteredAbsences = _studentService.getAbsencesInRange(_studentService.getStudent(student.studentId).absences, selectedDayFrom, selectedDayUntil)..sort((a, b) {
      if (a.from.compareTo(b.from) != 0) {
        return a.from.compareTo(b.from);
      } else {
        return a.until.compareTo(b.until);
      }
    });
    selectedAbsences = filteredAbsences;
    //selectedAbsences = ValueNotifier(filteredAbsences);
    //selectedAbsences.value = filteredAbsences;
    // TODO: need to set value explicitly?
  }

}
class AbsencesError extends AbsencesState {}
