import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/observation_repository.dart';

class ObservationService {

  final ObservationRepository _observationRepository = GetIt.I<ObservationRepository>();

  Future<List<Observation>> getObservations(String studentId) async {
    return _observationRepository.getObservations(studentId);
  }

  Future<void> createObservationForm(String studentId, String observationFormTitle, String observationFormVersion, String timespan) async {
    ObservationForm? observationForm = (await getObservationForms()).firstWhereOrNull((form) => form.title == observationFormTitle && form.version == observationFormVersion);
    if (observationForm == null) {
      return; // TODO: error handling
    }

    List<Observation> observations = [];
    for (Question q in observationForm.getQuestions()) {
      observations.add(Observation(q, timespan));
    }

    return _observationRepository.createObservations(studentId, observations);
  }

  Future<List<ObservationForm>> getObservationForms() async {
    return _observationRepository.getObservationForms();
  }

  Future<void> updateObservation(String studentId, Observation observation) async {
    return _observationRepository.updateObservation(studentId, observation);
  }

}