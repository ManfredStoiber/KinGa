///
//  Generated code. Do not modify.
//  source: backend.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'backend.pb.dart' as $0;
export 'backend.pb.dart';

class BackendClient extends $grpc.Client {
  static final _$createStudent = $grpc.ClientMethod<$0.Student, $0.Student>(
      '/backend.Backend/CreateStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$deleteStudent = $grpc.ClientMethod<$0.Id, $0.Empty>(
      '/backend.Backend/DeleteStudent',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$updateStudent = $grpc.ClientMethod<$0.Student, $0.Empty>(
      '/backend.Backend/UpdateStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$retrieveStudent = $grpc.ClientMethod<$0.Id, $0.Student>(
      '/backend.Backend/RetrieveStudent',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$retrieveInstitutionStudents =
      $grpc.ClientMethod<$0.Id, $0.Student>(
          '/backend.Backend/RetrieveInstitutionStudents',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$createInstitution =
      $grpc.ClientMethod<$0.Institution, $0.Institution>(
          '/backend.Backend/CreateInstitution',
          ($0.Institution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Institution.fromBuffer(value));
  static final _$retrieveInstitution =
      $grpc.ClientMethod<$0.Id, $0.Institution>(
          '/backend.Backend/RetrieveInstitution',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Institution.fromBuffer(value));
  static final _$createProfileImage =
      $grpc.ClientMethod<$0.ProfileImage, $0.Empty>(
          '/backend.Backend/CreateProfileImage',
          ($0.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$deleteProfileImage = $grpc.ClientMethod<$0.Id, $0.Empty>(
      '/backend.Backend/DeleteProfileImage',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$updateProfileImage =
      $grpc.ClientMethod<$0.ProfileImage, $0.Empty>(
          '/backend.Backend/UpdateProfileImage',
          ($0.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$retrieveProfileImage =
      $grpc.ClientMethod<$0.Id, $0.ProfileImage>(
          '/backend.Backend/RetrieveProfileImage',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value));

  BackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Student> createStudent($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createStudent, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteStudent($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteStudent, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> updateStudent($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateStudent, request, options: options);
  }

  $grpc.ResponseFuture<$0.Student> retrieveStudent($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveStudent, request, options: options);
  }

  $grpc.ResponseStream<$0.Student> retrieveInstitutionStudents($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveInstitutionStudents, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Institution> createInstitution($0.Institution request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$0.Institution> retrieveInstitution($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> createProfileImage($0.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteProfileImage($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> updateProfileImage($0.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfileImage> retrieveProfileImage($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveProfileImage, request, options: options);
  }
}

abstract class BackendServiceBase extends $grpc.Service {
  $core.String get $name => 'backend.Backend';

  BackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Student, $0.Student>(
        'CreateStudent',
        createStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($0.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Empty>(
        'DeleteStudent',
        deleteStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Student, $0.Empty>(
        'UpdateStudent',
        updateStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Student>(
        'RetrieveStudent',
        retrieveStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Student>(
        'RetrieveInstitutionStudents',
        retrieveInstitutionStudents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Institution, $0.Institution>(
        'CreateInstitution',
        createInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Institution.fromBuffer(value),
        ($0.Institution value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Institution>(
        'RetrieveInstitution',
        retrieveInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Institution value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfileImage, $0.Empty>(
        'CreateProfileImage',
        createProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Empty>(
        'DeleteProfileImage',
        deleteProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfileImage, $0.Empty>(
        'UpdateProfileImage',
        updateProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.ProfileImage>(
        'RetrieveProfileImage',
        retrieveProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.ProfileImage value) => value.writeToBuffer()));
  }

  $async.Future<$0.Student> createStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return createStudent(call, await request);
  }

  $async.Future<$0.Empty> deleteStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return deleteStudent(call, await request);
  }

  $async.Future<$0.Empty> updateStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return updateStudent(call, await request);
  }

  $async.Future<$0.Student> retrieveStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return retrieveStudent(call, await request);
  }

  $async.Stream<$0.Student> retrieveInstitutionStudents_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async* {
    yield* retrieveInstitutionStudents(call, await request);
  }

  $async.Future<$0.Institution> createInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Institution> request) async {
    return createInstitution(call, await request);
  }

  $async.Future<$0.Institution> retrieveInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return retrieveInstitution(call, await request);
  }

  $async.Future<$0.Empty> createProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileImage> request) async {
    return createProfileImage(call, await request);
  }

  $async.Future<$0.Empty> deleteProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return deleteProfileImage(call, await request);
  }

  $async.Future<$0.Empty> updateProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileImage> request) async {
    return updateProfileImage(call, await request);
  }

  $async.Future<$0.ProfileImage> retrieveProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return retrieveProfileImage(call, await request);
  }

  $async.Future<$0.Student> createStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$0.Empty> deleteStudent($grpc.ServiceCall call, $0.Id request);
  $async.Future<$0.Empty> updateStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$0.Student> retrieveStudent(
      $grpc.ServiceCall call, $0.Id request);
  $async.Stream<$0.Student> retrieveInstitutionStudents(
      $grpc.ServiceCall call, $0.Id request);
  $async.Future<$0.Institution> createInstitution(
      $grpc.ServiceCall call, $0.Institution request);
  $async.Future<$0.Institution> retrieveInstitution(
      $grpc.ServiceCall call, $0.Id request);
  $async.Future<$0.Empty> createProfileImage(
      $grpc.ServiceCall call, $0.ProfileImage request);
  $async.Future<$0.Empty> deleteProfileImage(
      $grpc.ServiceCall call, $0.Id request);
  $async.Future<$0.Empty> updateProfileImage(
      $grpc.ServiceCall call, $0.ProfileImage request);
  $async.Future<$0.ProfileImage> retrieveProfileImage(
      $grpc.ServiceCall call, $0.Id request);
}
