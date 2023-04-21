///
//  Generated code. Do not modify.
//  source: observation.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Observation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Observation', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'studentId', protoName: 'studentId')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'answer', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'note')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'period')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormId', protoName: 'observationFormId')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartId', protoName: 'observationFormPartId')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartSectionId', protoName: 'observationFormPartSectionId')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'questionId', protoName: 'questionId')
    ..hasRequiredFields = false
  ;

  Observation._() : super();
  factory Observation({
    $core.String? id,
    $core.String? studentId,
    $core.int? answer,
    $core.String? note,
    $core.String? period,
    $core.String? observationFormId,
    $core.String? observationFormPartId,
    $core.String? observationFormPartSectionId,
    $core.String? questionId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (studentId != null) {
      _result.studentId = studentId;
    }
    if (answer != null) {
      _result.answer = answer;
    }
    if (note != null) {
      _result.note = note;
    }
    if (period != null) {
      _result.period = period;
    }
    if (observationFormId != null) {
      _result.observationFormId = observationFormId;
    }
    if (observationFormPartId != null) {
      _result.observationFormPartId = observationFormPartId;
    }
    if (observationFormPartSectionId != null) {
      _result.observationFormPartSectionId = observationFormPartSectionId;
    }
    if (questionId != null) {
      _result.questionId = questionId;
    }
    return _result;
  }
  factory Observation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Observation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Observation clone() => Observation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Observation copyWith(void Function(Observation) updates) => super.copyWith((message) => updates(message as Observation)) as Observation; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Observation create() => Observation._();
  Observation createEmptyInstance() => create();
  static $pb.PbList<Observation> createRepeated() => $pb.PbList<Observation>();
  @$core.pragma('dart2js:noInline')
  static Observation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Observation>(create);
  static Observation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get studentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set studentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStudentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStudentId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get answer => $_getIZ(2);
  @$pb.TagNumber(3)
  set answer($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAnswer() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnswer() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get period => $_getSZ(4);
  @$pb.TagNumber(5)
  set period($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPeriod() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriod() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get observationFormId => $_getSZ(5);
  @$pb.TagNumber(6)
  set observationFormId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObservationFormId() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservationFormId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get observationFormPartId => $_getSZ(6);
  @$pb.TagNumber(7)
  set observationFormPartId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasObservationFormPartId() => $_has(6);
  @$pb.TagNumber(7)
  void clearObservationFormPartId() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get observationFormPartSectionId => $_getSZ(7);
  @$pb.TagNumber(8)
  set observationFormPartSectionId($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasObservationFormPartSectionId() => $_has(7);
  @$pb.TagNumber(8)
  void clearObservationFormPartSectionId() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get questionId => $_getSZ(8);
  @$pb.TagNumber(9)
  set questionId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasQuestionId() => $_has(8);
  @$pb.TagNumber(9)
  void clearQuestionId() => clearField(9);
}

class CreateObservationsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateObservationsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'studentId', protoName: 'studentId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormId', protoName: 'observationFormId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'period')
    ..hasRequiredFields = false
  ;

  CreateObservationsRequest._() : super();
  factory CreateObservationsRequest({
    $core.String? studentId,
    $core.String? observationFormId,
    $core.String? period,
  }) {
    final _result = create();
    if (studentId != null) {
      _result.studentId = studentId;
    }
    if (observationFormId != null) {
      _result.observationFormId = observationFormId;
    }
    if (period != null) {
      _result.period = period;
    }
    return _result;
  }
  factory CreateObservationsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateObservationsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateObservationsRequest clone() => CreateObservationsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateObservationsRequest copyWith(void Function(CreateObservationsRequest) updates) => super.copyWith((message) => updates(message as CreateObservationsRequest)) as CreateObservationsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateObservationsRequest create() => CreateObservationsRequest._();
  CreateObservationsRequest createEmptyInstance() => create();
  static $pb.PbList<CreateObservationsRequest> createRepeated() => $pb.PbList<CreateObservationsRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateObservationsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateObservationsRequest>(create);
  static CreateObservationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudentId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get observationFormId => $_getSZ(1);
  @$pb.TagNumber(2)
  set observationFormId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasObservationFormId() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservationFormId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get period => $_getSZ(2);
  @$pb.TagNumber(3)
  set period($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriod() => clearField(3);
}

class ObservationFormPartSection extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObservationFormPartSection', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subtitle')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormId', protoName: 'observationFormId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartId', protoName: 'observationFormPartId')
    ..pc<Question>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'questions', $pb.PbFieldType.PM, subBuilder: Question.create)
    ..hasRequiredFields = false
  ;

  ObservationFormPartSection._() : super();
  factory ObservationFormPartSection({
    $core.String? id,
    $core.String? title,
    $core.String? subtitle,
    $core.String? code,
    $core.String? observationFormId,
    $core.String? observationFormPartId,
    $core.Iterable<Question>? questions,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (subtitle != null) {
      _result.subtitle = subtitle;
    }
    if (code != null) {
      _result.code = code;
    }
    if (observationFormId != null) {
      _result.observationFormId = observationFormId;
    }
    if (observationFormPartId != null) {
      _result.observationFormPartId = observationFormPartId;
    }
    if (questions != null) {
      _result.questions.addAll(questions);
    }
    return _result;
  }
  factory ObservationFormPartSection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObservationFormPartSection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObservationFormPartSection clone() => ObservationFormPartSection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObservationFormPartSection copyWith(void Function(ObservationFormPartSection) updates) => super.copyWith((message) => updates(message as ObservationFormPartSection)) as ObservationFormPartSection; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObservationFormPartSection create() => ObservationFormPartSection._();
  ObservationFormPartSection createEmptyInstance() => create();
  static $pb.PbList<ObservationFormPartSection> createRepeated() => $pb.PbList<ObservationFormPartSection>();
  @$core.pragma('dart2js:noInline')
  static ObservationFormPartSection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObservationFormPartSection>(create);
  static ObservationFormPartSection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get observationFormId => $_getSZ(4);
  @$pb.TagNumber(5)
  set observationFormId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasObservationFormId() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservationFormId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get observationFormPartId => $_getSZ(5);
  @$pb.TagNumber(6)
  set observationFormPartId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObservationFormPartId() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservationFormPartId() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Question> get questions => $_getList(6);
}

class ObservationFormPart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObservationFormPart', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'number', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormId', protoName: 'observationFormId')
    ..pc<ObservationFormPartSection>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartSections', $pb.PbFieldType.PM, protoName: 'observationFormPartSections', subBuilder: ObservationFormPartSection.create)
    ..hasRequiredFields = false
  ;

  ObservationFormPart._() : super();
  factory ObservationFormPart({
    $core.String? id,
    $core.String? title,
    $core.int? number,
    $core.String? observationFormId,
    $core.Iterable<ObservationFormPartSection>? observationFormPartSections,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (number != null) {
      _result.number = number;
    }
    if (observationFormId != null) {
      _result.observationFormId = observationFormId;
    }
    if (observationFormPartSections != null) {
      _result.observationFormPartSections.addAll(observationFormPartSections);
    }
    return _result;
  }
  factory ObservationFormPart.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObservationFormPart.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObservationFormPart clone() => ObservationFormPart()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObservationFormPart copyWith(void Function(ObservationFormPart) updates) => super.copyWith((message) => updates(message as ObservationFormPart)) as ObservationFormPart; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObservationFormPart create() => ObservationFormPart._();
  ObservationFormPart createEmptyInstance() => create();
  static $pb.PbList<ObservationFormPart> createRepeated() => $pb.PbList<ObservationFormPart>();
  @$core.pragma('dart2js:noInline')
  static ObservationFormPart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObservationFormPart>(create);
  static ObservationFormPart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get number => $_getIZ(2);
  @$pb.TagNumber(3)
  set number($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get observationFormId => $_getSZ(3);
  @$pb.TagNumber(4)
  set observationFormId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasObservationFormId() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservationFormId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<ObservationFormPartSection> get observationFormPartSections => $_getList(4);
}

class ObservationForm extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObservationForm', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..pc<ObservationFormPart>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormParts', $pb.PbFieldType.PM, protoName: 'observationFormParts', subBuilder: ObservationFormPart.create)
    ..hasRequiredFields = false
  ;

  ObservationForm._() : super();
  factory ObservationForm({
    $core.String? id,
    $core.String? title,
    $core.String? version,
    $core.Iterable<ObservationFormPart>? observationFormParts,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (title != null) {
      _result.title = title;
    }
    if (version != null) {
      _result.version = version;
    }
    if (observationFormParts != null) {
      _result.observationFormParts.addAll(observationFormParts);
    }
    return _result;
  }
  factory ObservationForm.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObservationForm.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObservationForm clone() => ObservationForm()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObservationForm copyWith(void Function(ObservationForm) updates) => super.copyWith((message) => updates(message as ObservationForm)) as ObservationForm; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObservationForm create() => ObservationForm._();
  ObservationForm createEmptyInstance() => create();
  static $pb.PbList<ObservationForm> createRepeated() => $pb.PbList<ObservationForm>();
  @$core.pragma('dart2js:noInline')
  static ObservationForm getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObservationForm>(create);
  static ObservationForm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<ObservationFormPart> get observationFormParts => $_getList(3);
}

class Question extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Question', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'number', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormId', protoName: 'observationFormId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartId', protoName: 'observationFormPartId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'observationFormPartSectionId', protoName: 'observationFormPartSectionId')
    ..pc<Answer>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'possibleAnswers', $pb.PbFieldType.PM, protoName: 'possibleAnswers', subBuilder: Answer.create)
    ..hasRequiredFields = false
  ;

  Question._() : super();
  factory Question({
    $core.String? id,
    $core.String? text,
    $core.int? number,
    $core.String? observationFormId,
    $core.String? observationFormPartId,
    $core.String? observationFormPartSectionId,
    $core.Iterable<Answer>? possibleAnswers,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (text != null) {
      _result.text = text;
    }
    if (number != null) {
      _result.number = number;
    }
    if (observationFormId != null) {
      _result.observationFormId = observationFormId;
    }
    if (observationFormPartId != null) {
      _result.observationFormPartId = observationFormPartId;
    }
    if (observationFormPartSectionId != null) {
      _result.observationFormPartSectionId = observationFormPartSectionId;
    }
    if (possibleAnswers != null) {
      _result.possibleAnswers.addAll(possibleAnswers);
    }
    return _result;
  }
  factory Question.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Question.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Question clone() => Question()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Question copyWith(void Function(Question) updates) => super.copyWith((message) => updates(message as Question)) as Question; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Question create() => Question._();
  Question createEmptyInstance() => create();
  static $pb.PbList<Question> createRepeated() => $pb.PbList<Question>();
  @$core.pragma('dart2js:noInline')
  static Question getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Question>(create);
  static Question? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get number => $_getIZ(2);
  @$pb.TagNumber(3)
  set number($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get observationFormId => $_getSZ(3);
  @$pb.TagNumber(4)
  set observationFormId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasObservationFormId() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservationFormId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get observationFormPartId => $_getSZ(4);
  @$pb.TagNumber(5)
  set observationFormPartId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasObservationFormPartId() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservationFormPartId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get observationFormPartSectionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set observationFormPartSectionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObservationFormPartSectionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservationFormPartSectionId() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Answer> get possibleAnswers => $_getList(6);
}

class Answer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Answer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'number', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..hasRequiredFields = false
  ;

  Answer._() : super();
  factory Answer({
    $core.int? number,
    $core.String? text,
  }) {
    final _result = create();
    if (number != null) {
      _result.number = number;
    }
    if (text != null) {
      _result.text = text;
    }
    return _result;
  }
  factory Answer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Answer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Answer clone() => Answer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Answer copyWith(void Function(Answer) updates) => super.copyWith((message) => updates(message as Answer)) as Answer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Answer create() => Answer._();
  Answer createEmptyInstance() => create();
  static $pb.PbList<Answer> createRepeated() => $pb.PbList<Answer>();
  @$core.pragma('dart2js:noInline')
  static Answer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Answer>(create);
  static Answer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get number => $_getIZ(0);
  @$pb.TagNumber(1)
  set number($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

class ObservationFormId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObservationFormId', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  ObservationFormId._() : super();
  factory ObservationFormId({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory ObservationFormId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObservationFormId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObservationFormId clone() => ObservationFormId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObservationFormId copyWith(void Function(ObservationFormId) updates) => super.copyWith((message) => updates(message as ObservationFormId)) as ObservationFormId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObservationFormId create() => ObservationFormId._();
  ObservationFormId createEmptyInstance() => create();
  static $pb.PbList<ObservationFormId> createRepeated() => $pb.PbList<ObservationFormId>();
  @$core.pragma('dart2js:noInline')
  static ObservationFormId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObservationFormId>(create);
  static ObservationFormId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class StudentId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StudentId', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'studentId', protoName: 'studentId')
    ..hasRequiredFields = false
  ;

  StudentId._() : super();
  factory StudentId({
    $core.String? studentId,
  }) {
    final _result = create();
    if (studentId != null) {
      _result.studentId = studentId;
    }
    return _result;
  }
  factory StudentId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StudentId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StudentId clone() => StudentId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StudentId copyWith(void Function(StudentId) updates) => super.copyWith((message) => updates(message as StudentId)) as StudentId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StudentId create() => StudentId._();
  StudentId createEmptyInstance() => create();
  static $pb.PbList<StudentId> createRepeated() => $pb.PbList<StudentId>();
  @$core.pragma('dart2js:noInline')
  static StudentId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StudentId>(create);
  static StudentId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get studentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set studentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudentId() => clearField(1);
}

class RetrieveQuestionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RetrieveQuestionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'observation.v1'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'questionIds', protoName: 'questionIds')
    ..hasRequiredFields = false
  ;

  RetrieveQuestionsRequest._() : super();
  factory RetrieveQuestionsRequest({
    $core.Iterable<$core.String>? questionIds,
  }) {
    final _result = create();
    if (questionIds != null) {
      _result.questionIds.addAll(questionIds);
    }
    return _result;
  }
  factory RetrieveQuestionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RetrieveQuestionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RetrieveQuestionsRequest clone() => RetrieveQuestionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RetrieveQuestionsRequest copyWith(void Function(RetrieveQuestionsRequest) updates) => super.copyWith((message) => updates(message as RetrieveQuestionsRequest)) as RetrieveQuestionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RetrieveQuestionsRequest create() => RetrieveQuestionsRequest._();
  RetrieveQuestionsRequest createEmptyInstance() => create();
  static $pb.PbList<RetrieveQuestionsRequest> createRepeated() => $pb.PbList<RetrieveQuestionsRequest>();
  @$core.pragma('dart2js:noInline')
  static RetrieveQuestionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetrieveQuestionsRequest>(create);
  static RetrieveQuestionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get questionIds => $_getList(0);
}

