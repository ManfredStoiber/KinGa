part of 'absences_cubit.dart';


abstract class AbsencesState {
  const AbsencesState();
}

class AbsencesInitial extends AbsencesState {}
class AbsencesLoading extends AbsencesState {}
class AbsencesLoaded extends AbsencesState {

  final StudentService _studentService = GetIt.I<StudentService>();

  late final ValueNotifier<List<Absence>> selectedAbsences;

  DateTime firstDay = DateTime.now().subtract(const Duration(days: 365));
  DateTime lastDay = DateTime.now().add(const Duration(days: 365));
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  final Student student;

  AbsencesLoaded(this.student, this.selectedDay) {
    focusedDay = selectedDay;
    selectedAbsences = ValueNotifier(_studentService.getAbsencesOfDay(_studentService.getStudent(student.studentId).absences, selectedDay));
    selectedAbsences.value = _studentService.getAbsencesOfDay(student.absences..sort((a, b) {
      if (a.from.compareTo(b.from) != 0) {
        return a.from.compareTo(b.from);
      } else {
        return a.until.compareTo(b.until);
      }
    }), selectedDay);
  }

}
class AbsencesError extends AbsencesState {}
