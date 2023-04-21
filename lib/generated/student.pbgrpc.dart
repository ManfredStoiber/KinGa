///
//  Generated code. Do not modify.
//  source: student.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'student.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'student.pb.dart';

class StudentBackendClient extends $grpc.Client {
  static final _$createStudent = $grpc.ClientMethod<$0.Student, $1.Empty>(
      '/student.v1.StudentBackend/CreateStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$deleteStudent = $grpc.ClientMethod<$0.Id, $1.Empty>(
      '/student.v1.StudentBackend/DeleteStudent',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$updateStudent = $grpc.ClientMethod<$0.Student, $1.Empty>(
      '/student.v1.StudentBackend/UpdateStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveStudent = $grpc.ClientMethod<$0.Id, $0.Student>(
      '/student.v1.StudentBackend/RetrieveStudent',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$retrieveInstitutionStudents =
      $grpc.ClientMethod<$0.Id, $0.Student>(
          '/student.v1.StudentBackend/RetrieveInstitutionStudents',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$createProfileImage =
      $grpc.ClientMethod<$0.ProfileImage, $1.Empty>(
          '/student.v1.StudentBackend/CreateProfileImage',
          ($0.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$deleteProfileImage = $grpc.ClientMethod<$0.Id, $1.Empty>(
      '/student.v1.StudentBackend/DeleteProfileImage',
      ($0.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$updateProfileImage =
      $grpc.ClientMethod<$0.ProfileImage, $1.Empty>(
          '/student.v1.StudentBackend/UpdateProfileImage',
          ($0.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveProfileImage =
      $grpc.ClientMethod<$0.Id, $0.ProfileImage>(
          '/student.v1.StudentBackend/RetrieveProfileImage',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value));

  StudentBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> createStudent($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createStudent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteStudent($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteStudent, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateStudent($0.Student request,
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

  $grpc.ResponseFuture<$1.Empty> createProfileImage($0.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteProfileImage($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateProfileImage($0.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfileImage> retrieveProfileImage($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveProfileImage, request, options: options);
  }
}

abstract class StudentBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'student.v1.StudentBackend';

  StudentBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Student, $1.Empty>(
        'CreateStudent',
        createStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $1.Empty>(
        'DeleteStudent',
        deleteStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Student, $1.Empty>(
        'UpdateStudent',
        updateStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.ProfileImage, $1.Empty>(
        'CreateProfileImage',
        createProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $1.Empty>(
        'DeleteProfileImage',
        deleteProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfileImage, $1.Empty>(
        'UpdateProfileImage',
        updateProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.ProfileImage>(
        'RetrieveProfileImage',
        retrieveProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.ProfileImage value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> createStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return createStudent(call, await request);
  }

  $async.Future<$1.Empty> deleteStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return deleteStudent(call, await request);
  }

  $async.Future<$1.Empty> updateStudent_Pre(
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

  $async.Future<$1.Empty> createProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileImage> request) async {
    return createProfileImage(call, await request);
  }

  $async.Future<$1.Empty> deleteProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return deleteProfileImage(call, await request);
  }

  $async.Future<$1.Empty> updateProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileImage> request) async {
    return updateProfileImage(call, await request);
  }

  $async.Future<$0.ProfileImage> retrieveProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return retrieveProfileImage(call, await request);
  }

  $async.Future<$1.Empty> createStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$1.Empty> deleteStudent($grpc.ServiceCall call, $0.Id request);
  $async.Future<$1.Empty> updateStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$0.Student> retrieveStudent(
      $grpc.ServiceCall call, $0.Id request);
  $async.Stream<$0.Student> retrieveInstitutionStudents(
      $grpc.ServiceCall call, $0.Id request);
  $async.Future<$1.Empty> createProfileImage(
      $grpc.ServiceCall call, $0.ProfileImage request);
  $async.Future<$1.Empty> deleteProfileImage(
      $grpc.ServiceCall call, $0.Id request);
  $async.Future<$1.Empty> updateProfileImage(
      $grpc.ServiceCall call, $0.ProfileImage request);
  $async.Future<$0.ProfileImage> retrieveProfileImage(
      $grpc.ServiceCall call, $0.Id request);
}
