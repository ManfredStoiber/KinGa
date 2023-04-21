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
    const {'1': 'student_id', '3': 2, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'answer', '3': 3, '4': 1, '5': 5, '10': 'answer'},
    const {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    const {'1': 'period', '3': 5, '4': 1, '5': 9, '10': 'period'},
    const {'1': 'observation_form_id', '3': 6, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observation_form_part_id', '3': 7, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'observation_form_part_section_id', '3': 8, '4': 1, '5': 9, '10': 'observationFormPartSectionId'},
    const {'1': 'question_id', '3': 9, '4': 1, '5': 9, '10': 'questionId'},
  ],
};

/// Descriptor for `Observation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationDescriptor = $convert.base64Decode('CgtPYnNlcnZhdGlvbhIOCgJpZBgBIAEoCVICaWQSHQoKc3R1ZGVudF9pZBgCIAEoCVIJc3R1ZGVudElkEhYKBmFuc3dlchgDIAEoBVIGYW5zd2VyEhIKBG5vdGUYBCABKAlSBG5vdGUSFgoGcGVyaW9kGAUgASgJUgZwZXJpb2QSLgoTb2JzZXJ2YXRpb25fZm9ybV9pZBgGIAEoCVIRb2JzZXJ2YXRpb25Gb3JtSWQSNwoYb2JzZXJ2YXRpb25fZm9ybV9wYXJ0X2lkGAcgASgJUhVvYnNlcnZhdGlvbkZvcm1QYXJ0SWQSRgogb2JzZXJ2YXRpb25fZm9ybV9wYXJ0X3NlY3Rpb25faWQYCCABKAlSHG9ic2VydmF0aW9uRm9ybVBhcnRTZWN0aW9uSWQSHwoLcXVlc3Rpb25faWQYCSABKAlSCnF1ZXN0aW9uSWQ=');
@$core.Deprecated('Use createObservationsRequestDescriptor instead')
const CreateObservationsRequest$json = const {
  '1': 'CreateObservationsRequest',
  '2': const [
    const {'1': 'student_id', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'observation_form_id', '3': 2, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'period', '3': 3, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `CreateObservationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createObservationsRequestDescriptor = $convert.base64Decode('ChlDcmVhdGVPYnNlcnZhdGlvbnNSZXF1ZXN0Eh0KCnN0dWRlbnRfaWQYASABKAlSCXN0dWRlbnRJZBIuChNvYnNlcnZhdGlvbl9mb3JtX2lkGAIgASgJUhFvYnNlcnZhdGlvbkZvcm1JZBIWCgZwZXJpb2QYAyABKAlSBnBlcmlvZA==');
@$core.Deprecated('Use observationFormPartSectionDescriptor instead')
const ObservationFormPartSection$json = const {
  '1': 'ObservationFormPartSection',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'subtitle', '3': 3, '4': 1, '5': 9, '10': 'subtitle'},
    const {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'observation_form_id', '3': 5, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observation_form_part_id', '3': 6, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'questions', '3': 7, '4': 3, '5': 11, '6': '.observation.v1.Question', '10': 'questions'},
  ],
};

/// Descriptor for `ObservationFormPartSection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormPartSectionDescriptor = $convert.base64Decode('ChpPYnNlcnZhdGlvbkZvcm1QYXJ0U2VjdGlvbhIOCgJpZBgBIAEoCVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhoKCHN1YnRpdGxlGAMgASgJUghzdWJ0aXRsZRISCgRjb2RlGAQgASgJUgRjb2RlEi4KE29ic2VydmF0aW9uX2Zvcm1faWQYBSABKAlSEW9ic2VydmF0aW9uRm9ybUlkEjcKGG9ic2VydmF0aW9uX2Zvcm1fcGFydF9pZBgGIAEoCVIVb2JzZXJ2YXRpb25Gb3JtUGFydElkEjYKCXF1ZXN0aW9ucxgHIAMoCzIYLm9ic2VydmF0aW9uLnYxLlF1ZXN0aW9uUglxdWVzdGlvbnM=');
@$core.Deprecated('Use observationFormPartDescriptor instead')
const ObservationFormPart$json = const {
  '1': 'ObservationFormPart',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'number', '3': 3, '4': 1, '5': 5, '10': 'number'},
    const {'1': 'observation_form_id', '3': 4, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observation_form_part_sections', '3': 5, '4': 3, '5': 11, '6': '.observation.v1.ObservationFormPartSection', '10': 'observationFormPartSections'},
  ],
};

/// Descriptor for `ObservationFormPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormPartDescriptor = $convert.base64Decode('ChNPYnNlcnZhdGlvbkZvcm1QYXJ0Eg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSFgoGbnVtYmVyGAMgASgFUgZudW1iZXISLgoTb2JzZXJ2YXRpb25fZm9ybV9pZBgEIAEoCVIRb2JzZXJ2YXRpb25Gb3JtSWQSbwoeb2JzZXJ2YXRpb25fZm9ybV9wYXJ0X3NlY3Rpb25zGAUgAygLMioub2JzZXJ2YXRpb24udjEuT2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25SG29ic2VydmF0aW9uRm9ybVBhcnRTZWN0aW9ucw==');
@$core.Deprecated('Use observationFormDescriptor instead')
const ObservationForm$json = const {
  '1': 'ObservationForm',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'observation_form_parts', '3': 4, '4': 3, '5': 11, '6': '.observation.v1.ObservationFormPart', '10': 'observationFormParts'},
  ],
};

/// Descriptor for `ObservationForm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationFormDescriptor = $convert.base64Decode('Cg9PYnNlcnZhdGlvbkZvcm0SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9uElkKFm9ic2VydmF0aW9uX2Zvcm1fcGFydHMYBCADKAsyIy5vYnNlcnZhdGlvbi52MS5PYnNlcnZhdGlvbkZvcm1QYXJ0UhRvYnNlcnZhdGlvbkZvcm1QYXJ0cw==');
@$core.Deprecated('Use questionDescriptor instead')
const Question$json = const {
  '1': 'Question',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'number', '3': 3, '4': 1, '5': 5, '10': 'number'},
    const {'1': 'observation_form_id', '3': 4, '4': 1, '5': 9, '10': 'observationFormId'},
    const {'1': 'observation_form_part_id', '3': 5, '4': 1, '5': 9, '10': 'observationFormPartId'},
    const {'1': 'observation_form_part_section_id', '3': 6, '4': 1, '5': 9, '10': 'observationFormPartSectionId'},
    const {'1': 'possible_answers', '3': 7, '4': 3, '5': 11, '6': '.observation.v1.Answer', '10': 'possibleAnswers'},
  ],
};

/// Descriptor for `Question`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List questionDescriptor = $convert.base64Decode('CghRdWVzdGlvbhIOCgJpZBgBIAEoCVICaWQSEgoEdGV4dBgCIAEoCVIEdGV4dBIWCgZudW1iZXIYAyABKAVSBm51bWJlchIuChNvYnNlcnZhdGlvbl9mb3JtX2lkGAQgASgJUhFvYnNlcnZhdGlvbkZvcm1JZBI3ChhvYnNlcnZhdGlvbl9mb3JtX3BhcnRfaWQYBSABKAlSFW9ic2VydmF0aW9uRm9ybVBhcnRJZBJGCiBvYnNlcnZhdGlvbl9mb3JtX3BhcnRfc2VjdGlvbl9pZBgGIAEoCVIcb2JzZXJ2YXRpb25Gb3JtUGFydFNlY3Rpb25JZBJBChBwb3NzaWJsZV9hbnN3ZXJzGAcgAygLMhYub2JzZXJ2YXRpb24udjEuQW5zd2VyUg9wb3NzaWJsZUFuc3dlcnM=');
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
    const {'1': 'student_id', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
  ],
};

/// Descriptor for `StudentId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentIdDescriptor = $convert.base64Decode('CglTdHVkZW50SWQSHQoKc3R1ZGVudF9pZBgBIAEoCVIJc3R1ZGVudElk');
@$core.Deprecated('Use retrieveQuestionsRequestDescriptor instead')
const RetrieveQuestionsRequest$json = const {
  '1': 'RetrieveQuestionsRequest',
  '2': const [
    const {'1': 'question_ids', '3': 1, '4': 3, '5': 9, '10': 'questionIds'},
  ],
};

/// Descriptor for `RetrieveQuestionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retrieveQuestionsRequestDescriptor = $convert.base64Decode('ChhSZXRyaWV2ZVF1ZXN0aW9uc1JlcXVlc3QSIQoMcXVlc3Rpb25faWRzGAEgAygJUgtxdWVzdGlvbklkcw==');
