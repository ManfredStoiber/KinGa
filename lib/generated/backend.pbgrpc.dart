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
  static final _$updateStudent = $grpc.ClientMethod<$0.Student, $0.Empty>(
      '/backend.Backend/UpdateStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$retrieveStudent = $grpc.ClientMethod<$0.Student, $0.Student>(
      '/backend.Backend/RetrieveStudent',
      ($0.Student value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Student.fromBuffer(value));
  static final _$updateInstitution =
      $grpc.ClientMethod<$0.Institution, $0.Empty>(
          '/backend.Backend/UpdateInstitution',
          ($0.Institution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$retrieveInstitution =
      $grpc.ClientMethod<$0.Institution, $0.Institution>(
          '/backend.Backend/RetrieveInstitution',
          ($0.Institution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Institution.fromBuffer(value));
  static final _$updateProfileImage =
      $grpc.ClientMethod<$0.ProfileImage, $0.Empty>(
          '/backend.Backend/UpdateProfileImage',
          ($0.ProfileImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$retrieveProfileImage =
      $grpc.ClientMethod<$0.Student, $0.ProfileImage>(
          '/backend.Backend/RetrieveProfileImage',
          ($0.Student value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value));

  BackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> updateStudent($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateStudent, request, options: options);
  }

  $grpc.ResponseFuture<$0.Student> retrieveStudent($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveStudent, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> updateInstitution($0.Institution request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$0.Institution> retrieveInstitution(
      $0.Institution request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> updateProfileImage($0.ProfileImage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfileImage> retrieveProfileImage($0.Student request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveProfileImage, request, options: options);
  }
}

abstract class BackendServiceBase extends $grpc.Service {
  $core.String get $name => 'backend.Backend';

  BackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Student, $0.Empty>(
        'UpdateStudent',
        updateStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Student, $0.Student>(
        'RetrieveStudent',
        retrieveStudent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($0.Student value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Institution, $0.Empty>(
        'UpdateInstitution',
        updateInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Institution.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Institution, $0.Institution>(
        'RetrieveInstitution',
        retrieveInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Institution.fromBuffer(value),
        ($0.Institution value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfileImage, $0.Empty>(
        'UpdateProfileImage',
        updateProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileImage.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Student, $0.ProfileImage>(
        'RetrieveProfileImage',
        retrieveProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Student.fromBuffer(value),
        ($0.ProfileImage value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> updateStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return updateStudent(call, await request);
  }

  $async.Future<$0.Student> retrieveStudent_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return retrieveStudent(call, await request);
  }

  $async.Future<$0.Empty> updateInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Institution> request) async {
    return updateInstitution(call, await request);
  }

  $async.Future<$0.Institution> retrieveInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Institution> request) async {
    return retrieveInstitution(call, await request);
  }

  $async.Future<$0.Empty> updateProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileImage> request) async {
    return updateProfileImage(call, await request);
  }

  $async.Future<$0.ProfileImage> retrieveProfileImage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Student> request) async {
    return retrieveProfileImage(call, await request);
  }

  $async.Future<$0.Empty> updateStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$0.Student> retrieveStudent(
      $grpc.ServiceCall call, $0.Student request);
  $async.Future<$0.Empty> updateInstitution(
      $grpc.ServiceCall call, $0.Institution request);
  $async.Future<$0.Institution> retrieveInstitution(
      $grpc.ServiceCall call, $0.Institution request);
  $async.Future<$0.Empty> updateProfileImage(
      $grpc.ServiceCall call, $0.ProfileImage request);
  $async.Future<$0.ProfileImage> retrieveProfileImage(
      $grpc.ServiceCall call, $0.Student request);
}