///
//  Generated code. Do not modify.
//  source: student.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use studentDescriptor instead')
const Student$json = const {
  '1': 'Student',
  '2': const [
    const {'1': 'student_id', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    const {'1': 'institution_id', '3': 3, '4': 1, '5': 9, '10': 'institutionId'},
  ],
};

/// Descriptor for `Student`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentDescriptor = $convert.base64Decode('CgdTdHVkZW50Eh0KCnN0dWRlbnRfaWQYASABKAlSCXN0dWRlbnRJZBIUCgV2YWx1ZRgCIAEoCVIFdmFsdWUSJQoOaW5zdGl0dXRpb25faWQYAyABKAlSDWluc3RpdHV0aW9uSWQ=');
@$core.Deprecated('Use profileImageDescriptor instead')
const ProfileImage$json = const {
  '1': 'ProfileImage',
  '2': const [
    const {'1': 'student_id', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'data', '3': 2, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `ProfileImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileImageDescriptor = $convert.base64Decode('CgxQcm9maWxlSW1hZ2USHQoKc3R1ZGVudF9pZBgBIAEoCVIJc3R1ZGVudElkEhIKBGRhdGEYAiABKAlSBGRhdGE=');
@$core.Deprecated('Use studentIdDescriptor instead')
const StudentId$json = const {
  '1': 'StudentId',
  '2': const [
    const {'1': 'student_id', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
  ],
};

/// Descriptor for `StudentId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentIdDescriptor = $convert.base64Decode('CglTdHVkZW50SWQSHQoKc3R1ZGVudF9pZBgBIAEoCVIJc3R1ZGVudElk');
@$core.Deprecated('Use institutionIdDescriptor instead')
const InstitutionId$json = const {
  '1': 'InstitutionId',
  '2': const [
    const {'1': 'institution_id', '3': 1, '4': 1, '5': 9, '10': 'institutionId'},
  ],
};

/// Descriptor for `InstitutionId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List institutionIdDescriptor = $convert.base64Decode('Cg1JbnN0aXR1dGlvbklkEiUKDmluc3RpdHV0aW9uX2lkGAEgASgJUg1pbnN0aXR1dGlvbklk');
