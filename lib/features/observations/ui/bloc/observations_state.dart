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
  late final ObservationForm selectedObservationForm;
  late final ObservationFormPart selectedPart;
  final List<ObservationForm> observationForms;

  ObservationsLoaded(this.student, this.observations, ObservationForm? selectedObservationForm, this.observationForms, {ObservationFormPart? selectedPart}) {
    if (selectedObservationForm == null) {
      this.selectedObservationForm = observationForms.first;
    } else {
      this.selectedObservationForm = selectedObservationForm;
    }

    if (selectedPart == null) {
      this.selectedPart = this.selectedObservationForm.parts.first;
    } else {
      this.selectedPart = selectedPart;
    }
  }

}
class ObservationsError extends ObservationsState {}
