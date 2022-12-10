part of 'observations_cubit.dart';


abstract class ObservationsState {
  const ObservationsState();
}

class ObservationsInitial extends ObservationsState {}
class ObservationsLoading extends ObservationsState {}
class ObservationsLoaded extends ObservationsState {

  final StudentService _studentService = GetIt.I<StudentService>();

  final Student student;
  late final List<Observation> observations;
  late final ObservationForm? selectedObservationForm;
  final List<ObservationForm> observationForms;

  ObservationsLoaded(this.student, this.observations, String? selectedObservationForm, this.observationForms) {
    if (selectedObservationForm == null && observationForms.isNotEmpty) {
      this.selectedObservationForm = observationForms.first;
    } else {
      this.selectedObservationForm = observationForms.firstWhere((observationForm) => observationForm.title == selectedObservationForm);
    }
  }

}
class ObservationsError extends ObservationsState {}
