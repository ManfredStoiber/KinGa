///
//  Generated code. Do not modify.
//  source: student.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'student.pb.dart' as $4;
import 'google/protobuf/empty.pb.dart' as $1;
export 'student.pb.dart';

class StudentBackendClient extends $grpc.Client {
  static final _$createStudent = $grpc.ClientMethod<$4.Student, $1.Empty>(
      '/student.v1.StudentBackend/CreateStudent',
      ($4.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$deleteStudent = $grpc.ClientMethod<$4.StudentId, $1.Empty>(
      '/student.v1.StudentBackend/DeleteStudent',
      ($4.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$updateStudent = $grpc.ClientMethod<$4.Student, $1.Empty>(
      '/student.v1.StudentBackend/UpdateStudent',
      ($4.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveStudent = $grpc.ClientMethod<$4.StudentId, $4.Student>(
      '/student.v1.StudentBackend/RetrieveStudent',
      ($4.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.Student.fromBuffer(value));
  static final _$retrieveInstitutionStudents =
      $grpc.ClientMethod<$4.InstitutionId, $4.Student>(
          '/student.v1.StudentBackend/RetrieveInstitutionStudents',
          ($4.InstitutionId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $4.Student.fromBuffer(value));
  static final _$createProfileImage =
      $grpc.ClientMethod<$4.ProfileImage, $1.Empty>(
          '/student.v1.StudentBackend/CreateProfileImage',
          ($4.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$deleteProfileImage =
      $grpc.ClientMethod<$4.StudentId, $1.Empty>(
          '/student.v1.StudentBackend/DeleteProfileImage',
          ($4.StudentId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$updateProfileImage =
      $grpc.ClientMethod<$4.ProfileImage, $1.Empty>(
          '/student.v1.StudentBackend/UpdateProfileImage',
          ($4.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveProfileImage =
      $grpc.ClientMethod<$4.StudentId, $4.ProfileImage>(
          '/student.v1.StudentBackend/RetrieveProfileImage',
          ($4.StudentId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $4.ProfileImage.fromBuffer(value));

  StudentBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> createStudent($4.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createStudent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteStudent($4.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteStudent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateStudent($4.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateStudent, request, options: options);
  }

  $grpc.ResponseFuture<$4.Student> retrieveStudent($4.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveStudent, request, options: options);
  }

  $grpc.ResponseStream<$4.Student> retrieveInstitutionStudents(
      $4.InstitutionId request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveInstitutionStudents, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.Empty> createProfileImage($4.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteProfileImage($4.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateProfileImage($4.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$4.ProfileImage> retrieveProfileImage(
      $4.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveProfileImage, request, options: options);
  }
}

abstract class StudentBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'student.v1.StudentBackend';

  StudentBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$4.Student, $1.Empty>(
        'CreateStudent',
        createStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.Student.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.StudentId, $1.Empty>(
        'DeleteStudent',
        deleteStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.StudentId.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.Student, $1.Empty>(
        'UpdateStudent',
        updateStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.Student.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.StudentId, $4.Student>(
        'RetrieveStudent',
        retrieveStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.StudentId.fromBuffer(value),
        ($4.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.InstitutionId, $4.Student>(
        'RetrieveInstitutionStudents',
        retrieveInstitutionStudents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $4.InstitutionId.fromBuffer(value),
        ($4.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ProfileImage, $1.Empty>(
        'CreateProfileImage',
        createProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ProfileImage.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.StudentId, $1.Empty>(
        'DeleteProfileImage',
        deleteProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.StudentId.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ProfileImage, $1.Empty>(
        'UpdateProfileImage',
        updateProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ProfileImage.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.StudentId, $4.ProfileImage>(
        'RetrieveProfileImage',
        retrieveProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.StudentId.fromBuffer(value),
        ($4.ProfileImage value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> createStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$4.Student> request) async {
    return createStudent(call, await request);
  }

  $async.Future<$1.Empty> deleteStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$4.StudentId> request) async {
    return deleteStudent(call, await request);
  }

  $async.Future<$1.Empty> updateStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$4.Student> request) async {
    return updateStudent(call, await request);
  }

  $async.Future<$4.Student> retrieveStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$4.StudentId> request) async {
    return retrieveStudent(call, await request);
  }

  $async.Stream<$4.Student> retrieveInstitutionStudents_Pre(
      $grpc.ServiceCall call, $async.Future<$4.InstitutionId> request) async* {
    yield* retrieveInstitutionStudents(call, await request);
  }

  $async.Future<$1.Empty> createProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$4.ProfileImage> request) async {
    return createProfileImage(call, await request);
  }

  $async.Future<$1.Empty> deleteProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$4.StudentId> request) async {
    return deleteProfileImage(call, await request);
  }

  $async.Future<$1.Empty> updateProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$4.ProfileImage> request) async {
    return updateProfileImage(call, await request);
  }

  $async.Future<$4.ProfileImage> retrieveProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$4.StudentId> request) async {
    return retrieveProfileImage(call, await request);
  }

  $async.Future<$1.Empty> createStudent(
      $grpc.ServiceCall call, $4.Student request);
  $async.Future<$1.Empty> deleteStudent(
      $grpc.ServiceCall call, $4.StudentId request);
  $async.Future<$1.Empty> updateStudent(
      $grpc.ServiceCall call, $4.Student request);
  $async.Future<$4.Student> retrieveStudent(
      $grpc.ServiceCall call, $4.StudentId request);
  $async.Stream<$4.Student> retrieveInstitutionStudents(
      $grpc.ServiceCall call, $4.InstitutionId request);
  $async.Future<$1.Empty> createProfileImage(
      $grpc.ServiceCall call, $4.ProfileImage request);
  $async.Future<$1.Empty> deleteProfileImage(
      $grpc.ServiceCall call, $4.StudentId request);
  $async.Future<$1.Empty> updateProfileImage(
      $grpc.ServiceCall call, $4.ProfileImage request);
  $async.Future<$4.ProfileImage> retrieveProfileImage(
      $grpc.ServiceCall call, $4.StudentId request);
}
