///
//  Generated code. Do not modify.
//  source: permission.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'permission.pb.dart' as $3;
export 'permission.pb.dart';

class PermissionBackendClient extends $grpc.Client {
  static final _$createStudent = $grpc.ClientMethod<$3.Student, $3.Student>(
      '/backend.permission.PermissionBackend/CreateStudent',
      ($3.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.Student.fromBuffer(value));
  static final _$deleteStudent = $grpc.ClientMethod<$3.Id, $3.Empty>(
      '/backend.permission.PermissionBackend/DeleteStudent',
      ($3.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.Empty.fromBuffer(value));
  static final _$createInstitution =
      $grpc.ClientMethod<$3.Institution, $3.Institution>(
          '/backend.permission.PermissionBackend/CreateInstitution',
          ($3.Institution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $3.Institution.fromBuffer(value));
  static final _$retrieveInstitution =
      $grpc.ClientMethod<$3.Id, $3.Institution>(
          '/backend.permission.PermissionBackend/RetrieveInstitution',
          ($3.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $3.Institution.fromBuffer(value));
  static final _$createProfileImage =
      $grpc.ClientMethod<$3.ProfileImage, $3.Empty>(
          '/backend.permission.PermissionBackend/CreateProfileImage',
          ($3.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $3.Empty.fromBuffer(value));
  static final _$deleteProfileImage = $grpc.ClientMethod<$3.Id, $3.Empty>(
      '/backend.permission.PermissionBackend/DeleteProfileImage',
      ($3.Id value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.Empty.fromBuffer(value));
  static final _$updateProfileImage =
      $grpc.ClientMethod<$3.ProfileImage, $3.Empty>(
          '/backend.permission.PermissionBackend/UpdateProfileImage',
          ($3.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $3.Empty.fromBuffer(value));
  static final _$retrieveProfileImage =
      $grpc.ClientMethod<$3.Id, $3.ProfileImage>(
          '/backend.permission.PermissionBackend/RetrieveProfileImage',
          ($3.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $3.ProfileImage.fromBuffer(value));

  PermissionBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$3.Student> createStudent($3.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createStudent, request, options: options);
  }

  $grpc.ResponseFuture<$3.Empty> deleteStudent($3.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteStudent, request, options: options);
  }

  $grpc.ResponseFuture<$3.Institution> createInstitution($3.Institution request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$3.Institution> retrieveInstitution($3.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$3.Empty> createProfileImage($3.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$3.Empty> deleteProfileImage($3.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$3.Empty> updateProfileImage($3.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$3.ProfileImage> retrieveProfileImage($3.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveProfileImage, request, options: options);
  }
}

abstract class PermissionBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'backend.permission.PermissionBackend';

  PermissionBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$3.Student, $3.Student>(
        'CreateStudent',
        createStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Student.fromBuffer(value),
        ($3.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.Id, $3.Empty>(
        'DeleteStudent',
        deleteStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Id.fromBuffer(value),
        ($3.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.Institution, $3.Institution>(
        'CreateInstitution',
        createInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Institution.fromBuffer(value),
        ($3.Institution value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.Id, $3.Institution>(
        'RetrieveInstitution',
        retrieveInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Id.fromBuffer(value),
        ($3.Institution value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.ProfileImage, $3.Empty>(
        'CreateProfileImage',
        createProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ProfileImage.fromBuffer(value),
        ($3.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.Id, $3.Empty>(
        'DeleteProfileImage',
        deleteProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Id.fromBuffer(value),
        ($3.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.ProfileImage, $3.Empty>(
        'UpdateProfileImage',
        updateProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ProfileImage.fromBuffer(value),
        ($3.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.Id, $3.ProfileImage>(
        'RetrieveProfileImage',
        retrieveProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.Id.fromBuffer(value),
        ($3.ProfileImage value) => value.writeToBuffer()));
  }

  $async.Future<$3.Student> createStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Student> request) async {
    return createStudent(call, await request);
  }

  $async.Future<$3.Empty> deleteStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Id> request) async {
    return deleteStudent(call, await request);
  }

  $async.Future<$3.Institution> createInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Institution> request) async {
    return createInstitution(call, await request);
  }

  $async.Future<$3.Institution> retrieveInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Id> request) async {
    return retrieveInstitution(call, await request);
  }

  $async.Future<$3.Empty> createProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$3.ProfileImage> request) async {
    return createProfileImage(call, await request);
  }

  $async.Future<$3.Empty> deleteProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Id> request) async {
    return deleteProfileImage(call, await request);
  }

  $async.Future<$3.Empty> updateProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$3.ProfileImage> request) async {
    return updateProfileImage(call, await request);
  }

  $async.Future<$3.ProfileImage> retrieveProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$3.Id> request) async {
    return retrieveProfileImage(call, await request);
  }

  $async.Future<$3.Student> createStudent(
      $grpc.ServiceCall call, $3.Student request);
  $async.Future<$3.Empty> deleteStudent($grpc.ServiceCall call, $3.Id request);
  $async.Future<$3.Institution> createInstitution(
      $grpc.ServiceCall call, $3.Institution request);
  $async.Future<$3.Institution> retrieveInstitution(
      $grpc.ServiceCall call, $3.Id request);
  $async.Future<$3.Empty> createProfileImage(
      $grpc.ServiceCall call, $3.ProfileImage request);
  $async.Future<$3.Empty> deleteProfileImage(
      $grpc.ServiceCall call, $3.Id request);
  $async.Future<$3.Empty> updateProfileImage(
      $grpc.ServiceCall call, $3.ProfileImage request);
  $async.Future<$3.ProfileImage> retrieveProfileImage(
      $grpc.ServiceCall call, $3.Id request);
}
