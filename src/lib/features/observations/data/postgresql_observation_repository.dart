import 'package:grpc/grpc.dart';
import 'package:kinga/constants/backend_config.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:kinga/features/observations/domain/entity/observation_period.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/observation_repository.dart';
import 'package:kinga/generated/google/protobuf/empty.pb.dart';
import 'package:kinga/generated/observation.pbgrpc.dart' as proto;

import '../../../constants/config.dart';
import '../../../data/auth_interceptor.dart';

class PostgresqlObservationRepository implements ObservationRepository {

  late proto.ObservationBackendClient _observationBackendClient;

  PostgresqlObservationRepository() {
    final channel = ClientChannel(
      BackendConfig.backendServerHost,
      port: BackendConfig.port,
      options: Config.tls ? const ChannelOptions() : const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _observationBackendClient = proto.ObservationBackendClient(channel, interceptors: [AuthInterceptor()]);
  }

  @override
  Future<void> createObservations(String studentId, String observationFormId, ObservationPeriod period) {
    return _observationBackendClient.createObservations(proto.CreateObservationsRequest(studentId: studentId, observationFormId: observationFormId, period: period.toString()));
  }

  @override
  Future<Map<String, List<Observation>>> getAllObservations() {
    // TODO: implement getAllObservations
    throw UnimplementedError();
  }

  @override
  Future<List<ObservationForm>> getObservationForms() async {
    List<ObservationForm> observationForms = [];
    await for (var of in _observationBackendClient.retrieveObservationForms(Empty())) {
      var observationForm = ObservationForm(of.id, of.title, of.version, []);
      List<ObservationFormPart> observationFormParts = [];
      for (var ofp in of.observationFormParts) {
        var observationFormPart = ObservationFormPart(ofp.id, ofp.title, ofp.number, []);
        List<ObservationFormPartSection> observationFormPartSections = [];
        for (var ofps in ofp.observationFormPartSections) {
          var observationFormPartSection = ObservationFormPartSection(ofps.id, ofps.title, ofps.code, []);
          List<Question> questions = [];
            for (var q in ofps.questions) {
              var question = Question(q.id, q.text, q.number, {}, observationForm, observationFormPart, observationFormPartSection);
              Map<int, String> possibleAnswers = {};
              for (var pa in q.possibleAnswers) {
                possibleAnswers[pa.number] = pa.text;
              }
              question.possibleAnswers = possibleAnswers;
              questions.add(question);
            }
          observationFormPartSection.questions = questions;
          observationFormPartSections.add(observationFormPartSection);
        }
        observationFormPart.sections = observationFormPartSections;
        observationFormParts.add(observationFormPart);
      }
      observationForm.parts = observationFormParts;
      observationForms.add(observationForm);
    }

    return observationForms;
  }

  @override
  Future<List<Observation>> getObservations(String studentId) async {
    Map<String, Question> questionsCache = {};
    Map<String, ObservationForm> observationFormsCache = {};
    Map<String, ObservationFormPart> observationFormsPartsCache = {};
    Map<String, ObservationFormPartSection> observationFormsPartsSectionsCache = {};

    List<Observation> observations  = [];
    var stream = _observationBackendClient.retrieveObservations(proto.StudentId(studentId: studentId));
    await for (var observation in stream) {
      var observationForm = observationFormsCache[observation.observationFormId];
      if (observationForm == null) {
        var of = await _observationBackendClient.retrieveObservationForm(proto.ObservationFormId(id: observation.observationFormId));
        var observationForm = ObservationForm(of.id, of.title, of.version, []);
        List<ObservationFormPart> observationFormParts = [];
        for (var ofp in of.observationFormParts) {
          var observationFormPart = ObservationFormPart(ofp.id, ofp.title, ofp.number, []);
          List<ObservationFormPartSection> observationFormPartSections = [];
          for (var ofps in ofp.observationFormPartSections) {
            var observationFormPartSection = ObservationFormPartSection(ofps.id, ofps.title, ofps.code, []);
            List<Question> questions = [];
            for (var q in ofps.questions) {
              var question = Question(q.id, q.text, q.number, {}, observationForm, observationFormPart, observationFormPartSection);
              Map<int, String> possibleAnswers = {};
              for (var pa in q.possibleAnswers) {
                possibleAnswers[pa.number] = pa.text;
              }
              question.possibleAnswers = possibleAnswers;
              questions.add(question);
              questionsCache[q.id] = question;
            }
            observationFormPartSection.questions = questions;
            observationFormsPartsSectionsCache[ofps.id] = observationFormPartSection;
            observationFormPartSections.add(observationFormPartSection);
          }
          observationFormPart.sections = observationFormPartSections;
          observationFormsPartsCache[ofp.id] = observationFormPart;
          observationFormParts.add(observationFormPart);
        }
        observationForm.parts = observationFormParts;
        observationFormsCache[of.id] = observationForm;
      }
      observations.add(Observation(observation.id, questionsCache[observation.questionId]!, ObservationPeriod.fromString(observation.period), observation.hasAnswer() ? observation.answer : null, observation.hasNote() ? observation.note : null));
    }
    return observations;
  }

  @override
  Future<void> updateObservation(String studentId, Observation observation) {
    return _observationBackendClient.updateObservation(proto.Observation(
      id: observation.id,
      studentId: studentId,
      answer: observation.answer,
      note: observation.note,
      observationFormId: observation.question.observationForm.id,
      observationFormPartId: observation.question.part.id,
      observationFormPartSectionId: observation.question.section.id,
      questionId: observation.question.id
    ));
  }

  @override
  Future<void> createObservationForm(ObservationForm observationForm) {
    return _observationBackendClient.createObservationForm(proto.ObservationForm(
      id: observationForm.id,
      title: observationForm.title,
      version: observationForm.version,
      observationFormParts: observationForm.parts.map((part) => proto.ObservationFormPart(
        id: part.id,
        title: part.title,
        number: part.number,
        observationFormPartSections: part.sections.map((section) => proto.ObservationFormPartSection(
          id: section.id,
          title: section.title,
          subtitle: section.subtitle,
          code: section.code,
          questions: section.questions.map((question) => proto.Question(
            id: question.id,
            text: question.text,
            number: question.number,
            possibleAnswers: question.possibleAnswers.entries.map((possibleAnswer) => proto.Answer(
              number: possibleAnswer.key,
              text: possibleAnswer.value
            ))
          ))
        ))
      ))
    ));
  }

}