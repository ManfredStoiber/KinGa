///
//  Generated code. Do not modify.
//  source: backend.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Student extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Student', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'backend'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'studentId', protoName: 'studentId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  Student._() : super();
  factory Student({
    $core.String? studentId,
    $core.String? value,
  }) {
    final _result = create();
    if (studentId != null) {
      _result.studentId = studentId;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory Student.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Student.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Student clone() => Student()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Student copyWith(void Function(Student) updates) => super.copyWith((message) => updates(message as Student)) as Student; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Student create() => Student._();
  Student createEmptyInstance() => create();
  static $pb.PbList<Student> createRepeated() => $pb.PbList<Student>();
  @$core.pragma('dart2js:noInline')
  static Student getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Student>(create);
  static Student? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudentId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class Institution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Institution', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'backend'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionId', protoName: 'institutionId')
    ..pc<Student>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'students', $pb.PbFieldType.PM, subBuilder: Student.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptedInstitutionKey', protoName: 'encryptedInstitutionKey')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionKeyIv', protoName: 'institutionKeyIv')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'institutionName', protoName: 'institutionName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'passwordKeyNonce', protoName: 'passwordKeyNonce')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verificationKey', protoName: 'verificationKey')
    ..hasRequiredFields = false
  ;

  Institution._() : super();
  factory Institution({
    $core.String? institutionId,
    $core.Iterable<Student>? students,
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
    if (students != null) {
      _result.students.addAll(students);
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
  $core.List<Student> get students => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get encryptedInstitutionKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set encryptedInstitutionKey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEncryptedInstitutionKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncryptedInstitutionKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get institutionKeyIv => $_getSZ(3);
  @$pb.TagNumber(4)
  set institutionKeyIv($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInstitutionKeyIv() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstitutionKeyIv() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get institutionName => $_getSZ(4);
  @$pb.TagNumber(5)
  set institutionName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasInstitutionName() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstitutionName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get passwordKeyNonce => $_getSZ(5);
  @$pb.TagNumber(6)
  set passwordKeyNonce($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPasswordKeyNonce() => $_has(5);
  @$pb.TagNumber(6)
  void clearPasswordKeyNonce() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get verificationKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set verificationKey($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVerificationKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerificationKey() => clearField(7);
}

class ProfileImage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProfileImage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'backend'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'studentId', protoName: 'studentId')
    ..hasRequiredFields = false
  ;

  ProfileImage._() : super();
  factory ProfileImage({
    $core.String? studentId,
  }) {
    final _result = create();
    if (studentId != null) {
      _result.studentId = studentId;
    }
    return _result;
  }
  factory ProfileImage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProfileImage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProfileImage clone() => ProfileImage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProfileImage copyWith(void Function(ProfileImage) updates) => super.copyWith((message) => updates(message as ProfileImage)) as ProfileImage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProfileImage create() => ProfileImage._();
  ProfileImage createEmptyInstance() => create();
  static $pb.PbList<ProfileImage> createRepeated() => $pb.PbList<ProfileImage>();
  @$core.pragma('dart2js:noInline')
  static ProfileImage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileImage>(create);
  static ProfileImage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudentId() => clearField(1);
}

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'backend'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

