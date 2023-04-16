///
//  Generated code. Do not modify.
//  source: backend.proto
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
    const {'1': 'studentId', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    const {'1': 'institutionId', '3': 3, '4': 1, '5': 9, '10': 'institutionId'},
  ],
};

/// Descriptor for `Student`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentDescriptor = $convert.base64Decode('CgdTdHVkZW50EhwKCXN0dWRlbnRJZBgBIAEoCVIJc3R1ZGVudElkEhQKBXZhbHVlGAIgASgJUgV2YWx1ZRIkCg1pbnN0aXR1dGlvbklkGAMgASgJUg1pbnN0aXR1dGlvbklk');
@$core.Deprecated('Use institutionDescriptor instead')
const Institution$json = const {
  '1': 'Institution',
  '2': const [
    const {'1': 'institutionId', '3': 1, '4': 1, '5': 9, '10': 'institutionId'},
    const {'1': 'encryptedInstitutionKey', '3': 2, '4': 1, '5': 9, '10': 'encryptedInstitutionKey'},
    const {'1': 'institutionKeyIv', '3': 3, '4': 1, '5': 9, '10': 'institutionKeyIv'},
    const {'1': 'institutionName', '3': 4, '4': 1, '5': 9, '10': 'institutionName'},
    const {'1': 'passwordKeyNonce', '3': 5, '4': 1, '5': 9, '10': 'passwordKeyNonce'},
    const {'1': 'verificationKey', '3': 6, '4': 1, '5': 9, '10': 'verificationKey'},
  ],
};

/// Descriptor for `Institution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List institutionDescriptor = $convert.base64Decode('CgtJbnN0aXR1dGlvbhIkCg1pbnN0aXR1dGlvbklkGAEgASgJUg1pbnN0aXR1dGlvbklkEjgKF2VuY3J5cHRlZEluc3RpdHV0aW9uS2V5GAIgASgJUhdlbmNyeXB0ZWRJbnN0aXR1dGlvbktleRIqChBpbnN0aXR1dGlvbktleUl2GAMgASgJUhBpbnN0aXR1dGlvbktleUl2EigKD2luc3RpdHV0aW9uTmFtZRgEIAEoCVIPaW5zdGl0dXRpb25OYW1lEioKEHBhc3N3b3JkS2V5Tm9uY2UYBSABKAlSEHBhc3N3b3JkS2V5Tm9uY2USKAoPdmVyaWZpY2F0aW9uS2V5GAYgASgJUg92ZXJpZmljYXRpb25LZXk=');
@$core.Deprecated('Use profileImageDescriptor instead')
const ProfileImage$json = const {
  '1': 'ProfileImage',
  '2': const [
    const {'1': 'studentId', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
    const {'1': 'data', '3': 2, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `ProfileImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileImageDescriptor = $convert.base64Decode('CgxQcm9maWxlSW1hZ2USHAoJc3R1ZGVudElkGAEgASgJUglzdHVkZW50SWQSEgoEZGF0YRgCIAEoCVIEZGF0YQ==');
@$core.Deprecated('Use idDescriptor instead')
const Id$json = const {
  '1': 'Id',
  '2': const [
    const {'1': 'requestId', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `Id`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List idDescriptor = $convert.base64Decode('CgJJZBIcCglyZXF1ZXN0SWQYASABKAlSCXJlcXVlc3RJZA==');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
