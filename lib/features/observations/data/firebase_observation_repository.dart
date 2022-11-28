import 'dart:io';
import 'dart:typed_data';

import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:flutter/services.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';
import 'package:kinga/features/observations/domain/entity/observation_form.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part.dart';
import 'package:kinga/features/observations/domain/entity/observation_form_part_section.dart';
import 'package:kinga/features/observations/domain/entity/question.dart';
import 'package:kinga/features/observations/domain/observation_repository.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseObservationRepository implements ObservationRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  late String currentInstitutionId;
  Set<Student>? currentStudents;

  final Directory _applicationDocumentsDirectory = GetIt.I<Directory>(
      instanceName: Keys.applicationDocumentsDirectory);

  FirebaseObservationRepository() {
    currentInstitutionId = GetIt.I<StreamingSharedPreferences>().getString(
        Keys.institutionId, defaultValue: "").getValue();
  }

  @override
  Future<List<Observation>> getObservations(String studentId) async {

    List<ObservationForm> observationForms = await getObservationForms();
    var doc = await db.collection('Institution').doc(currentInstitutionId).collection("Student").doc(studentId).collection('Observation').get();
    List<Observation> observations = [];
    for (var data in doc.docs) {
      observations.add(mapToObservation(data.data(), observationForms));
    }

    return observations;
  }

  @override
  Future<void> updateObservation(String studentId, Observation observation) async {
    List<ObservationForm> observationForms = await getObservationForms();
    var doc = await db.collection('Institution').doc(currentInstitutionId).collection("Student").doc(studentId).collection('Observation').get();
    for (var data in doc.docs) {
      Observation o = mapToObservation(data.data(), observationForms);
      if (o.question == observation.question && o.timespan == observation.timespan) {
        return db.collection('Institution').doc(currentInstitutionId).collection('Student')
            .doc(studentId).collection('Observation').doc(data.id).set(observationToMap(observation))
            .onError((error,
            stackTrace) {
          if (kDebugMode) {
            print(stackTrace);
          } // TODO
        });
      }
    }

  }

  Observation mapToObservation ( Map<String, dynamic> map, List<ObservationForm> observationForms ) {

    ObservationForm? observationForm = observationForms.firstWhereOrNull((observationForm) => observationForm.title == map['observationFormTitle'] && observationForm.version == map['observationFormVersion']);
    ObservationFormPart? part = observationForm?.parts.firstWhereOrNull((part) => part.number == map['partNumber']);
    ObservationFormPartSection? section = part?.sections.firstWhereOrNull((section) => section.code == map['sectionCode']);
    Question? question = section?.questions.firstWhereOrNull((question) => question.number == map['questionNumber']);

    if (question == null) {
      throw StateError("No question found for given observation");
    }

    Observation observation = Observation(question, map['timespan'], map['answer'], map['note']);

    return observation;
  }

  Map<String, dynamic> observationToMap(Observation observation) {
    // convert observation to map
    Map<String, dynamic> map = {
      'timespan' : observation.timespan,
      'note' : observation.note,
      'observationFormTitle': observation.question.observationForm.title,
      'observationFormVersion': observation.question.observationForm.version,
      'partNumber': observation.question.part.number,
      'sectionCode': observation.question.section.code,
      'questionNumber': observation.question.number,
    };

    if (observation.answer != null) {
      map['answer'] = observation.answer;
    }

    if (observation.note != null) {
      map['note'] = observation.note;
    }

    return map;
  }

  ObservationForm mapToObservationForm(Map<String, dynamic> map) {

    List<ObservationFormPart> parts = [];
    ObservationForm observationForm = ObservationForm(map['title'], map['version'], parts);

    for (Map<String, dynamic> partMap in map['parts']) {

      List<ObservationFormPartSection> sections = [];
      ObservationFormPart part = ObservationFormPart(partMap['title'], int.parse(partMap['number']), sections);

      for (Map<String, dynamic> sectionMap in partMap['sections']) {

        List<Question> questions = [];
        ObservationFormPartSection section = ObservationFormPartSection(sectionMap['title'], sectionMap['code'], questions, sectionMap['subtitle']);

        for (Map<String, dynamic> questionMap in sectionMap['questions']) {

          Map<int, String> possibleAnswers = Map.fromEntries((questionMap['possibleAnswers'] as Map<String, dynamic>).entries.map((e) => MapEntry<int, String>(int.parse(e.key), e.value)));
          questions.add(Question(questionMap['text'], int.parse(questionMap['number']), possibleAnswers, observationForm, part, section));

        }

        sections.add(section);

      }

      parts.add(part);

    }

    return observationForm;

  }

  Map<String, dynamic> observationFormToMap(ObservationForm observationForm) {
    Map<String, dynamic> map = {};
    List<Map<String, dynamic>> parts = [];

    for (var part in observationForm.parts) {
      Map<String, dynamic> partMap = {};

      List<Map<String, dynamic>> sections = [];

      for (var section in part.sections) {
        Map<String, dynamic> sectionMap = {};

        List<Map<String, dynamic>> questions = [];

        for (var question in section.questions) {
          Map<String, dynamic> questionMap = {};
          questionMap['number'] = question.number.toString();
          questionMap['text'] = question.text;
          questionMap['possibleAnswers'] = Map.fromEntries(question.possibleAnswers.entries.map((e) => MapEntry(e.key.toString(), e.value)));

          questions.add(questionMap);
        }

        sectionMap['code'] = section.code;
        sectionMap['title'] = section.title;
        if (section.subtitle != null) {
          sectionMap['subtitle'] = section.subtitle;
        }
        sectionMap['questions'] = questions;

        sections.add(sectionMap);
      }

      partMap['number'] = part.number.toString();
      partMap['title'] = part.title;
      partMap['sections'] = sections;

      parts.add(partMap);
    }

    map['title'] = observationForm.title;
    map['version'] = observationForm.version;
    map['parts'] = parts;

    return map;
  }

  @override
  Future<void> createObservations(String studentId, List<Observation> observations) {
    var batch = db.batch();

    for (var observation in observations) {
      var doc = db.collection('Institution').doc(currentInstitutionId).collection('Student')
          .doc(studentId)
          .collection('Observation').doc();
      batch.set(doc, observationToMap(observation));
    }

    return batch.commit();
  }

  @override
  Future<List<ObservationForm>> getObservationForms() async {

    List<ObservationForm> observationForms = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('ObservationForm').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        observationForms.add(mapToObservationForm(doc.data()));
      }
    }); // TODO: error handling

    return observationForms;

  }

}