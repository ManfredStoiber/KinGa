import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';

part 'observations_state.dart';

class ObservationsCubit extends Cubit<ObservationsState> {

  final StudentService _studentService = GetIt.I<StudentService>();
  final ObservationService _observationService = GetIt.I<ObservationService>();
  StreamSubscription<Set<Student>>? _streamSubscription;
  late final List<ObservationForm> observationForms;

  String studentId;

  ObservationsCubit(this.studentId) : super(ObservationsInitial()) {
    emit(ObservationsLoading());

    _observationService.getObservationForms().then((observationForms) {
      this.observationForms = observationForms;
      _observationService.getObservations(studentId).then((value) => emit(ObservationsLoaded(
          _studentService.students.firstWhere((student) => student.studentId == studentId), value, null, observationForms
      ))).onError((error, stackTrace) => emit(ObservationsError()));
    });

  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  void updateUi({String? selectedObservationForm}) {
    selectedObservationForm ??= (state as ObservationsLoaded).selectedObservationForm?.title;
    _observationService.getObservations(studentId).then((value) => emit(ObservationsLoaded(
        _studentService.students.firstWhere((student) => student.studentId == studentId), value, selectedObservationForm, observationForms
    ))).onError((error, stackTrace) => emit(ObservationsError()));
  }

  Future<void> createObservationForm(String studentId, String observationFormTitle, String observationFormVersion, String timespan) async {
    return _observationService.createObservationForm(studentId, observationFormTitle, observationFormVersion, timespan).then((_) {
      updateUi(selectedObservationForm: observationFormTitle);
    });
  }

  Future<void> updateObservation(String studentId, Observation observation) async {
    return _observationService.updateObservation(studentId, observation).then((value) => updateUi());
  }

}
