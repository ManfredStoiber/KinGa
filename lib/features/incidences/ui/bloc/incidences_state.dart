part of 'incidences_cubit.dart';


abstract class IncidencesState {
  const IncidencesState();
}

class IncidencesInitial extends IncidencesState {}
class IncidencesLoading extends IncidencesState {}
class IncidencesLoaded extends IncidencesState {
  final String selectedCategory;
  final String selectedTimeFrame;
  late final List<Incidence> incidences;

  IncidencesLoaded(this.selectedCategory, this.selectedTimeFrame, incidences) {
    this.incidences = filterIncidences(incidences, selectedCategory, selectedTimeFrame)..sort((a, b) => b.compareTo(a),); // sort reversed
  }

  List<Incidence> filterIncidences(List<Incidence> incidences, String selectedCategory, String selectedTimeFrame) {
    StudentService studentService = GetIt.I<StudentService>();

    List<Incidence> filteredIncidences;
    switch(selectedTimeFrame) {
      case Strings.today:
        filteredIncidences = studentService.getIncidencesOfToday(incidences);
        break;
      case Strings.lastMonth:
        filteredIncidences = studentService.getIncidencesOfDays(incidences, DateTime.now().subtract(const Duration(days: 30)), DateTime.now());
        break;
      case Strings.lastYear:
        filteredIncidences = studentService.getIncidencesOfDays(incidences, DateTime.now().subtract(const Duration(days: 365)), DateTime.now());
        break;
      case Strings.all:
      default:
        filteredIncidences = incidences;
        break;
    }
    if (selectedCategory == Strings.all) {
      return filteredIncidences;
    } else {
      return filteredIncidences.where((incidence) => incidence.category == selectedCategory).toList();
    }

  }

}
class IncidencesError extends IncidencesState {}
