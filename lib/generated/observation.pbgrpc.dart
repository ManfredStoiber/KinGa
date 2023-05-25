///
//  Generated code. Do not modify.
//  source: observation.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'observation.pb.dart' as $2;
import 'google/protobuf/empty.pb.dart' as $1;
export 'observation.pb.dart';

class ObservationBackendClient extends $grpc.Client {
  static final _$createObservationForm =
      $grpc.ClientMethod<$2.ObservationForm, $1.Empty>(
          '/observation.v1.ObservationBackend/CreateObservationForm',
          ($2.ObservationForm value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$createObservations =
      $grpc.ClientMethod<$2.CreateObservationsRequest, $1.Empty>(
          '/observation.v1.ObservationBackend/CreateObservations',
          ($2.CreateObservationsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveObservations =
      $grpc.ClientMethod<$2.StudentId, $2.Observation>(
          '/observation.v1.ObservationBackend/RetrieveObservations',
          ($2.StudentId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $2.Observation.fromBuffer(value));
  static final _$retrieveObservationForm =
      $grpc.ClientMethod<$2.ObservationFormId, $2.ObservationForm>(
          '/observation.v1.ObservationBackend/RetrieveObservationForm',
          ($2.ObservationFormId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $2.ObservationForm.fromBuffer(value));
  static final _$retrieveObservationForms =
      $grpc.ClientMethod<$1.Empty, $2.ObservationForm>(
          '/observation.v1.ObservationBackend/RetrieveObservationForms',
          ($1.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $2.ObservationForm.fromBuffer(value));
  static final _$retrieveQuestions =
      $grpc.ClientMethod<$2.RetrieveQuestionsRequest, $2.Question>(
          '/observation.v1.ObservationBackend/RetrieveQuestions',
          ($2.RetrieveQuestionsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $2.Question.fromBuffer(value));
  static final _$updateObservation =
      $grpc.ClientMethod<$2.Observation, $1.Empty>(
          '/observation.v1.ObservationBackend/UpdateObservation',
          ($2.Observation value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  ObservationBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> createObservationForm(
      $2.ObservationForm request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createObservationForm, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> createObservations(
      $2.CreateObservationsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createObservations, request, options: options);
  }

  $grpc.ResponseStream<$2.Observation> retrieveObservations(
      $2.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveObservations, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$2.ObservationForm> retrieveObservationForm(
      $2.ObservationFormId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveObservationForm, request,
        options: options);
  }

  $grpc.ResponseStream<$2.ObservationForm> retrieveObservationForms(
      $1.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveObservationForms, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$2.Question> retrieveQuestions(
      $2.RetrieveQuestionsRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveQuestions, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateObservation($2.Observation request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateObservation, request, options: options);
  }
}

abstract class ObservationBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'observation.v1.ObservationBackend';

  ObservationBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.ObservationForm, $1.Empty>(
        'CreateObservationForm',
        createObservationForm_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ObservationForm.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.CreateObservationsRequest, $1.Empty>(
        'CreateObservations',
        createObservations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.CreateObservationsRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.StudentId, $2.Observation>(
        'RetrieveObservations',
        retrieveObservations_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $2.StudentId.fromBuffer(value),
        ($2.Observation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ObservationFormId, $2.ObservationForm>(
        'RetrieveObservationForm',
        retrieveObservationForm_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ObservationFormId.fromBuffer(value),
        ($2.ObservationForm value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $2.ObservationForm>(
        'RetrieveObservationForms',
        retrieveObservationForms_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($2.ObservationForm value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RetrieveQuestionsRequest, $2.Question>(
        'RetrieveQuestions',
        retrieveQuestions_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $2.RetrieveQuestionsRequest.fromBuffer(value),
        ($2.Question value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.Observation, $1.Empty>(
        'UpdateObservation',
        updateObservation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.Observation.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> createObservationForm_Pre(
      $grpc.ServiceCall call, $async.Future<$2.ObservationForm> request) async {
    return createObservationForm(call, await request);
  }

  $async.Future<$1.Empty> createObservations_Pre($grpc.ServiceCall call,
      $async.Future<$2.CreateObservationsRequest> request) async {
    return createObservations(call, await request);
  }

  $async.Stream<$2.Observation> retrieveObservations_Pre(
      $grpc.ServiceCall call, $async.Future<$2.StudentId> request) async* {
    yield* retrieveObservations(call, await request);
  }

  $async.Future<$2.ObservationForm> retrieveObservationForm_Pre(
      $grpc.ServiceCall call,
      $async.Future<$2.ObservationFormId> request) async {
    return retrieveObservationForm(call, await request);
  }

  $async.Stream<$2.ObservationForm> retrieveObservationForms_Pre(
      $grpc.ServiceCall call, $async.Future<$1.Empty> request) async* {
    yield* retrieveObservationForms(call, await request);
  }

  $async.Stream<$2.Question> retrieveQuestions_Pre($grpc.ServiceCall call,
      $async.Future<$2.RetrieveQuestionsRequest> request) async* {
    yield* retrieveQuestions(call, await request);
  }

  $async.Future<$1.Empty> updateObservation_Pre(
      $grpc.ServiceCall call, $async.Future<$2.Observation> request) async {
    return updateObservation(call, await request);
  }

  $async.Future<$1.Empty> createObservationForm(
      $grpc.ServiceCall call, $2.ObservationForm request);
  $async.Future<$1.Empty> createObservations(
      $grpc.ServiceCall call, $2.CreateObservationsRequest request);
  $async.Stream<$2.Observation> retrieveObservations(
      $grpc.ServiceCall call, $2.StudentId request);
  $async.Future<$2.ObservationForm> retrieveObservationForm(
      $grpc.ServiceCall call, $2.ObservationFormId request);
  $async.Stream<$2.ObservationForm> retrieveObservationForms(
      $grpc.ServiceCall call, $1.Empty request);
  $async.Stream<$2.Question> retrieveQuestions(
      $grpc.ServiceCall call, $2.RetrieveQuestionsRequest request);
  $async.Future<$1.Empty> updateObservation(
      $grpc.ServiceCall call, $2.Observation request);
}
