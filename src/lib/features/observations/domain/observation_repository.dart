import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form.dart';

import 'entity/observation_period.dart';

abstract class ObservationRepository {
  Future<Map<String, List<Observation>>> getAllObservations();
  Future<List<Observation>> getObservations(String studentId);
  Future<void> updateObservation(String studentId, Observation observation);
  Future<void> createObservations(String studentId, String observationFormId, ObservationPeriod period);
  Future<void> createObservationForm(ObservationForm observationForm);
  Future<List<ObservationForm>> getObservationForms();
}