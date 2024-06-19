///
//  Generated code. Do not modify.
//  source: institution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Institution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Institution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'institution.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptedInstitutionKey')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionKeyIv')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'passwordKeyNonce')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verificationKey')
    ..hasRequiredFields = false
  ;

  Institution._() : super();
  factory Institution({
    $core.String? institutionId,
    $core.String? encryptedInstitutionKey,
    $core.String? institutionKeyIv,
    $core.String? institutionName,
    $core.String? passwordKeyNonce,
    $core.String? verificationKey,
  }) {
    final _result = create();
    if (institutionId != null) {
      _result.institutionId = institutionId;
    }
    if (encryptedInstitutionKey != null) {
      _result.encryptedInstitutionKey = encryptedInstitutionKey;
    }
    if (institutionKeyIv != null) {
      _result.institutionKeyIv = institutionKeyIv;
    }
    if (institutionName != null) {
      _result.institutionName = institutionName;
    }
    if (passwordKeyNonce != null) {
      _result.passwordKeyNonce = passwordKeyNonce;
    }
    if (verificationKey != null) {
      _result.verificationKey = verificationKey;
    }
    return _result;
  }
  factory Institution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Institution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Institution clone() => Institution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Institution copyWith(void Function(Institution) updates) => super.copyWith((message) => updates(message as Institution)) as Institution; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Institution create() => Institution._();
  Institution createEmptyInstance() => create();
  static $pb.PbList<Institution> createRepeated() => $pb.PbList<Institution>();
  @$core.pragma('dart2js:noInline')
  static Institution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Institution>(create);
  static Institution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get encryptedInstitutionKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set encryptedInstitutionKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEncryptedInstitutionKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptedInstitutionKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get institutionKeyIv => $_getSZ(2);
  @$pb.TagNumber(3)
  set institutionKeyIv($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInstitutionKeyIv() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstitutionKeyIv() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get institutionName => $_getSZ(3);
  @$pb.TagNumber(4)
  set institutionName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInstitutionName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstitutionName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get passwordKeyNonce => $_getSZ(4);
  @$pb.TagNumber(5)
  set passwordKeyNonce($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPasswordKeyNonce() => $_has(4);
  @$pb.TagNumber(5)
  void clearPasswordKeyNonce() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get verificationKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set verificationKey($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVerificationKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearVerificationKey() => clearField(6);
}

class InstitutionId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InstitutionId', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'institution.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionId')
    ..hasRequiredFields = false
  ;

  InstitutionId._() : super();
  factory InstitutionId({
    $core.String? institutionId,
  }) {
    final _result = create();
    if (institutionId != null) {
      _result.institutionId = institutionId;
    }
    return _result;
  }
  factory InstitutionId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InstitutionId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InstitutionId clone() => InstitutionId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InstitutionId copyWith(void Function(InstitutionId) updates) => super.copyWith((message) => updates(message as InstitutionId)) as InstitutionId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InstitutionId create() => InstitutionId._();
  InstitutionId createEmptyInstance() => create();
  static $pb.PbList<InstitutionId> createRepeated() => $pb.PbList<InstitutionId>();
  @$core.pragma('dart2js:noInline')
  static InstitutionId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InstitutionId>(create);
  static InstitutionId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => clearField(1);
}

