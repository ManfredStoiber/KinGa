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
  ],
};

/// Descriptor for `Student`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentDescriptor = $convert.base64Decode('CgdTdHVkZW50EhwKCXN0dWRlbnRJZBgBIAEoCVIJc3R1ZGVudElkEhQKBXZhbHVlGAIgASgJUgV2YWx1ZQ==');
@$core.Deprecated('Use institutionDescriptor instead')
const Institution$json = const {
  '1': 'Institution',
  '2': const [
    const {'1': 'institutionId', '3': 1, '4': 1, '5': 9, '10': 'institutionId'},
    const {'1': 'students', '3': 2, '4': 3, '5': 11, '6': '.backend.Student', '10': 'students'},
    const {'1': 'encryptedInstitutionKey', '3': 3, '4': 1, '5': 9, '10': 'encryptedInstitutionKey'},
    const {'1': 'institutionKeyIv', '3': 4, '4': 1, '5': 9, '10': 'institutionKeyIv'},
    const {'1': 'institutionName', '3': 5, '4': 1, '5': 9, '10': 'institutionName'},
    const {'1': 'passwordKeyNonce', '3': 6, '4': 1, '5': 9, '10': 'passwordKeyNonce'},
    const {'1': 'verificationKey', '3': 7, '4': 1, '5': 9, '10': 'verificationKey'},
  ],
};

/// Descriptor for `Institution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List institutionDescriptor = $convert.base64Decode('CgtJbnN0aXR1dGlvbhIkCg1pbnN0aXR1dGlvbklkGAEgASgJUg1pbnN0aXR1dGlvbklkEiwKCHN0dWRlbnRzGAIgAygLMhAuYmFja2VuZC5TdHVkZW50UghzdHVkZW50cxI4ChdlbmNyeXB0ZWRJbnN0aXR1dGlvbktleRgDIAEoCVIXZW5jcnlwdGVkSW5zdGl0dXRpb25LZXkSKgoQaW5zdGl0dXRpb25LZXlJdhgEIAEoCVIQaW5zdGl0dXRpb25LZXlJdhIoCg9pbnN0aXR1dGlvbk5hbWUYBSABKAlSD2luc3RpdHV0aW9uTmFtZRIqChBwYXNzd29yZEtleU5vbmNlGAYgASgJUhBwYXNzd29yZEtleU5vbmNlEigKD3ZlcmlmaWNhdGlvbktleRgHIAEoCVIPdmVyaWZpY2F0aW9uS2V5');
@$core.Deprecated('Use profileImageDescriptor instead')
const ProfileImage$json = const {
  '1': 'ProfileImage',
  '2': const [
    const {'1': 'studentId', '3': 1, '4': 1, '5': 9, '10': 'studentId'},
  ],
};

/// Descriptor for `ProfileImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileImageDescriptor = $convert.base64Decode('CgxQcm9maWxlSW1hZ2USHAoJc3R1ZGVudElkGAEgASgJUglzdHVkZW50SWQ=');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
