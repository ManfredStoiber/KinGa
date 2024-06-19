import 'package:get_it/get_it.dart';

import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/observation_repository.dart';
import 'package:kinga/util/date_utils.dart';

import 'entity/observation_period.dart';

class ObservationService {

  final ObservationRepository _observationRepository = GetIt.I<ObservationRepository>();

  Future<Map<String, List<Observation>>> getAllObservations() async {
    return _observationRepository.getAllObservations();
  }

  Future<List<Observation>> getObservations(String studentId) async {
    return _observationRepository.getObservations(studentId);
  }

  /// creates observation form for given student
  Future<void> createObservationFormForStudent(String studentId, String observationFormId, ObservationPeriod period) async {
    return _observationRepository.createObservations(studentId, observationFormId, period);
  }

  Future<void> createObservationForm(ObservationForm observationForm) {
    return _observationRepository.createObservationForm(observationForm);
  }

  Future<List<ObservationForm>> getObservationForms() async {
    return _observationRepository.getObservationForms();
  }

  Future<Question?> getObservationOfTheWeekQuestion() async {
    var observationForms = await _observationRepository.getObservationForms();
    var questions = [];
    for (var form in observationForms) {
      questions += form.getQuestions();
    }

    if (questions.isEmpty) {
      return null;
    }

    // get observation of the week question for current week number
    var observationOfTheWeekQuestionIndex = IsoDateUtils.getWeekNumber(DateTime.now()).hashCode % questions.length;

    return questions[observationOfTheWeekQuestionIndex];

  }

  Future<void> updateObservation(String studentId, Observation observation) async {
    return _observationRepository.updateObservation(studentId, observation);
  }

}