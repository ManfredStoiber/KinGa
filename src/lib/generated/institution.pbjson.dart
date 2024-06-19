///
//  Generated code. Do not modify.
//  source: institution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use institutionDescriptor instead')
const Institution$json = const {
  '1': 'Institution',
  '2': const [
    const {'1': 'institution_id', '3': 1, '4': 1, '5': 9, '10': 'institutionId'},
    const {'1': 'encrypted_institution_key', '3': 2, '4': 1, '5': 9, '10': 'encryptedInstitutionKey'},
    const {'1': 'institution_key_iv', '3': 3, '4': 1, '5': 9, '10': 'institutionKeyIv'},
    const {'1': 'institution_name', '3': 4, '4': 1, '5': 9, '10': 'institutionName'},
    const {'1': 'password_key_nonce', '3': 5, '4': 1, '5': 9, '10': 'passwordKeyNonce'},
    const {'1': 'verification_key', '3': 6, '4': 1, '5': 9, '10': 'verificationKey'},
  ],
};

/// Descriptor for `Institution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List institutionDescriptor = $convert.base64Decode('CgtJbnN0aXR1dGlvbhIlCg5pbnN0aXR1dGlvbl9pZBgBIAEoCVINaW5zdGl0dXRpb25JZBI6ChllbmNyeXB0ZWRfaW5zdGl0dXRpb25fa2V5GAIgASgJUhdlbmNyeXB0ZWRJbnN0aXR1dGlvbktleRIsChJpbnN0aXR1dGlvbl9rZXlfaXYYAyABKAlSEGluc3RpdHV0aW9uS2V5SXYSKQoQaW5zdGl0dXRpb25fbmFtZRgEIAEoCVIPaW5zdGl0dXRpb25OYW1lEiwKEnBhc3N3b3JkX2tleV9ub25jZRgFIAEoCVIQcGFzc3dvcmRLZXlOb25jZRIpChB2ZXJpZmljYXRpb25fa2V5GAYgASgJUg92ZXJpZmljYXRpb25LZXk=');
@$core.Deprecated('Use institutionIdDescriptor instead')
const InstitutionId$json = const {
  '1': 'InstitutionId',
  '2': const [
    const {'1': 'institution_id', '3': 1, '4': 1, '5': 9, '10': 'institutionId'},
  ],
};

/// Descriptor for `InstitutionId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List institutionIdDescriptor = $convert.base64Decode('Cg1JbnN0aXR1dGlvbklkEiUKDmluc3RpdHV0aW9uX2lkGAEgASgJUg1pbnN0aXR1dGlvbklk');
