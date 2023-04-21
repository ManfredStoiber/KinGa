///
//  Generated code. Do not modify.
//  source: institution.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'institution.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'institution.pb.dart';

class InstitutionBackendClient extends $grpc.Client {
  static final _$createInstitution =
      $grpc.ClientMethod<$0.Institution, $1.Empty>(
          '/institution.v1.InstitutionBackend/CreateInstitution',
          ($0.Institution value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveInstitution =
      $grpc.ClientMethod<$0.Id, $0.Institution>(
          '/institution.v1.InstitutionBackend/RetrieveInstitution',
          ($0.Id value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Institution.fromBuffer(value));

  InstitutionBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> createInstitution($0.Institution request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createInstitution, request, options: options);
  }

  $grpc.ResponseFuture<$0.Institution> retrieveInstitution($0.Id request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveInstitution, request, options: options);
  }
}

abstract class InstitutionBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'institution.v1.InstitutionBackend';

  InstitutionBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Institution, $1.Empty>(
        'CreateInstitution',
        createInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Institution.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Id, $0.Institution>(
        'RetrieveInstitution',
        retrieveInstitution_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Id.fromBuffer(value),
        ($0.Institution value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> createInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Institution> request) async {
    return createInstitution(call, await request);
  }

  $async.Future<$0.Institution> retrieveInstitution_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Id> request) async {
    return retrieveInstitution(call, await request);
  }

  $async.Future<$1.Empty> createInstitution(
      $grpc.ServiceCall call, $0.Institution request);
  $async.Future<$0.Institution> retrieveInstitution(
      $grpc.ServiceCall call, $0.Id request);
}
