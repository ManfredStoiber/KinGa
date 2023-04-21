///
//  Generated code. Do not modify.
//  source: observation.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use observationDescriptor instead')
const Observation$json = const {
  '1': 'Observation',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'studentId', '3': 2, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'answer', '3': 3, '4': 1, '5': 5, '10': 'answer'},
    const {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    const {'1': 'period', '3': 5, '4': 1, '5': 9, '10': 'period'},
    const {'1': 'observationFormId', '3': 6, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observationFormPartId', '3': 7, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'observationFormPartSectionId', '3': 8, '4': 1, '5': 9, '10': 'observationFormPartSectionId'},
    const {'1': 'questionId', '3': 9, '4': 1, '5': 9, '10': 'questionId'},
  ],
};

/// Descriptor for `Observation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationDescriptor = $convert.base64Decode('CgtPYnNlcnZhdGlvbhIOCgJpZBgBIAEoCVICaWQSHAoJc3R1ZGVudElkGAIgASgJUglzdHVkZW50SWQSFgoGYW5zd2VyGAMgASgFUgZhbnN3ZXISEgoEbm90ZRgEIAEoCVIEbm90ZRIWCgZwZXJpb2QYBSABKAlSBnBlcmlvZBIsChFvYnNlcnZhdGlvbkZvcm1JZBgGIAEoCVIRb2JzZXJ2YXRpb25Gb3JtSWQSNAoVb2JzZXJ2YXRpb25Gb3JtUGFydElkGAcgASgJUhVvYnNlcnZhdGlvbkZvcm1QYXJ0SWQSQgocb2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25JZBgIIAEoCVIcb2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25JZBIeCgpxdWVzdGlvbklkGAkgASgJUgpxdWVzdGlvbklk');
@$core.Deprecated('Use createObservationsRequestDescriptor instead')
const CreateObservationsRequest$json = const {
  '1': 'CreateObservationsRequest',
  '2': const [
    const {'1': 'studentId', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'observationFormId', '3': 2, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'period', '3': 3, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `CreateObservationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createObservationsRequestDescriptor = $convert.base64Decode('ChlDcmVhdGVPYnNlcnZhdGlvbnNSZXF1ZXN0EhwKCXN0dWRlbnRJZBgBIAEoCVIJc3R1ZGVudElkEiwKEW9ic2VydmF0aW9uRm9ybUlkGAIgASgJUhFvYnNlcnZhdGlvbkZvcm1JZBIWCgZwZXJpb2QYAyABKAlSBnBlcmlvZA==');
@$core.Deprecated('Use observationFormPartSectionDescriptor instead')
const ObservationFormPartSection$json = const {
  '1': 'ObservationFormPartSection',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'subtitle', '3': 3, '4': 1, '5': 9, '10': 'subtitle'},
    const {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'observationFormId', '3': 5, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observationFormPartId', '3': 6, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'questions', '3': 7, '4': 3, '5': 11, '6': '.observation.v1.Question', '10': 'questions'},
  ],
};

/// Descriptor for `ObservationFormPartSection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormPartSectionDescriptor = $convert.base64Decode('ChpPYnNlcnZhdGlvbkZvcm1QYXJ0U2VjdGlvbhIOCgJpZBgBIAEoCVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhoKCHN1YnRpdGxlGAMgASgJUghzdWJ0aXRsZRISCgRjb2RlGAQgASgJUgRjb2RlEiwKEW9ic2VydmF0aW9uRm9ybUlkGAUgASgJUhFvYnNlcnZhdGlvbkZvcm1JZBI0ChVvYnNlcnZhdGlvbkZvcm1QYXJ0SWQYBiABKAlSFW9ic2VydmF0aW9uRm9ybVBhcnRJZBI2CglxdWVzdGlvbnMYByADKAsyGC5vYnNlcnZhdGlvbi52MS5RdWVzdGlvblIJcXVlc3Rpb25z');
@$core.Deprecated('Use observationFormPartDescriptor instead')
const ObservationFormPart$json = const {
  '1': 'ObservationFormPart',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'number', '3': 3, '4': 1, '5': 5, '10': 'number'},
    const {'1': 'observationFormId', '3': 4, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observationFormPartSections', '3': 5, '4': 3, '5': 11, '6': '.observation.v1.ObservationFormPartSection', '10': 'observationFormPartSections'},
  ],
};

/// Descriptor for `ObservationFormPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormPartDescriptor = $convert.base64Decode('ChNPYnNlcnZhdGlvbkZvcm1QYXJ0Eg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSFgoGbnVtYmVyGAMgASgFUgZudW1iZXISLAoRb2JzZXJ2YXRpb25Gb3JtSWQYBCABKAlSEW9ic2VydmF0aW9uRm9ybUlkEmwKG29ic2VydmF0aW9uRm9ybVBhcnRTZWN0aW9ucxgFIAMoCzIqLm9ic2VydmF0aW9uLnYxLk9ic2VydmF0aW9uRm9ybVBhcnRTZWN0aW9uUhtvYnNlcnZhdGlvbkZvcm1QYXJ0U2VjdGlvbnM=');
@$core.Deprecated('Use observationFormDescriptor instead')
const ObservationForm$json = const {
  '1': 'ObservationForm',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'observationFormParts', '3': 4, '4': 3, '5': 11, '6': '.observation.v1.ObservationFormPart', '10': 'observationFormParts'},
  ],
};

/// Descriptor for `ObservationForm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormDescriptor = $convert.base64Decode('Cg9PYnNlcnZhdGlvbkZvcm0SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9uElcKFG9ic2VydmF0aW9uRm9ybVBhcnRzGAQgAygLMiMub2JzZXJ2YXRpb24udjEuT2JzZXJ2YXRpb25Gb3JtUGFydFIUb2JzZXJ2YXRpb25Gb3JtUGFydHM=');
@$core.Deprecated('Use questionDescriptor instead')
const Question$json = const {
  '1': 'Question',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'number', '3': 3, '4': 1, '5': 5, '10': 'number'},
    const {'1': 'observationFormId', '3': 4, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observationFormPartId', '3': 5, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'observationFormPartSectionId', '3': 6, '4': 1, '5': 9, '10': 'observationFormPartSectionId'},
    const {'1': 'possibleAnswers', '3': 7, '4': 3, '5': 11, '6': '.observation.v1.Answer', '10': 'possibleAnswers'},
  ],
};

/// Descriptor for `Question`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List questionDescriptor = $convert.base64Decode('CghRdWVzdGlvbhIOCgJpZBgBIAEoCVICaWQSEgoEdGV4dBgCIAEoCVIEdGV4dBIWCgZudW1iZXIYAyABKAVSBm51bWJlchIsChFvYnNlcnZhdGlvbkZvcm1JZBgEIAEoCVIRb2JzZXJ2YXRpb25Gb3JtSWQSNAoVb2JzZXJ2YXRpb25Gb3JtUGFydElkGAUgASgJUhVvYnNlcnZhdGlvbkZvcm1QYXJ0SWQSQgocb2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25JZBgGIAEoCVIcb2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25JZBJACg9wb3NzaWJsZUFuc3dlcnMYByADKAsyFi5vYnNlcnZhdGlvbi52MS5BbnN3ZXJSD3Bvc3NpYmxlQW5zd2Vycw==');
@$core.Deprecated('Use answerDescriptor instead')
const Answer$json = const {
  '1': 'Answer',
  '2': const [
    const {'1': 'number', '3': 1, '4': 1, '5': 5, '10': 'number'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Answer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerDescriptor = $convert.base64Decode('CgZBbnN3ZXISFgoGbnVtYmVyGAEgASgFUgZudW1iZXISEgoEdGV4dBgCIAEoCVIEdGV4dA==');
@$core.Deprecated('Use observationFormIdDescriptor instead')
const ObservationFormId$json = const {
  '1': 'ObservationFormId',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ObservationFormId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormIdDescriptor = $convert.base64Decode('ChFPYnNlcnZhdGlvbkZvcm1JZBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use studentIdDescriptor instead')
const StudentId$json = const {
  '1': 'StudentId',
  '2': const [
    const {'1': 'studentId', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
  ],
};

/// Descriptor for `StudentId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentIdDescriptor = $convert.base64Decode('CglTdHVkZW50SWQSHAoJc3R1ZGVudElkGAEgASgJUglzdHVkZW50SWQ=');
@$core.Deprecated('Use retrieveQuestionsRequestDescriptor instead')
const RetrieveQuestionsRequest$json = const {
  '1': 'RetrieveQuestionsRequest',
  '2': const [
    const {'1': 'questionIds', '3': 1, '4': 3, '5': 9, '10': 'questionIds'},
  ],
};

/// Descriptor for `RetrieveQuestionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retrieveQuestionsRequestDescriptor = $convert.base64Decode('ChhSZXRyaWV2ZVF1ZXN0aW9uc1JlcXVlc3QSIAoLcXVlc3Rpb25JZHMYASADKAlSC3F1ZXN0aW9uSWRz');
