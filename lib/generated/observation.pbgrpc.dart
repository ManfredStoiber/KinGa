///
//  Generated code. Do not modify.
//  source: observation.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'observation.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'observation.pb.dart';

class ObservationBackendClient extends $grpc.Client {
  static final _$createObservationForm =
      $grpc.ClientMethod<$0.ObservationForm, $1.Empty>(
          '/observation.v1.ObservationBackend/CreateObservationForm',
          ($0.ObservationForm value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$createObservations =
      $grpc.ClientMethod<$0.CreateObservationsRequest, $1.Empty>(
          '/observation.v1.ObservationBackend/CreateObservations',
          ($0.CreateObservationsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$retrieveObservations =
      $grpc.ClientMethod<$0.StudentId, $0.Observation>(
          '/observation.v1.ObservationBackend/RetrieveObservations',
          ($0.StudentId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Observation.fromBuffer(value));
  static final _$retrieveObservationForm =
      $grpc.ClientMethod<$0.ObservationFormId, $0.ObservationForm>(
          '/observation.v1.ObservationBackend/RetrieveObservationForm',
          ($0.ObservationFormId value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ObservationForm.fromBuffer(value));
  static final _$retrieveObservationForms =
      $grpc.ClientMethod<$1.Empty, $0.ObservationForm>(
          '/observation.v1.ObservationBackend/RetrieveObservationForms',
          ($1.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ObservationForm.fromBuffer(value));
  static final _$retrieveQuestions =
      $grpc.ClientMethod<$0.RetrieveQuestionsRequest, $0.Question>(
          '/observation.v1.ObservationBackend/RetrieveQuestions',
          ($0.RetrieveQuestionsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Question.fromBuffer(value));
  static final _$updateObservation =
      $grpc.ClientMethod<$0.Observation, $1.Empty>(
          '/observation.v1.ObservationBackend/UpdateObservation',
          ($0.Observation value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  ObservationBackendClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> createObservationForm(
      $0.ObservationForm request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createObservationForm, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> createObservations(
      $0.CreateObservationsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createObservations, request, options: options);
  }

  $grpc.ResponseStream<$0.Observation> retrieveObservations(
      $0.StudentId request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveObservations, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.ObservationForm> retrieveObservationForm(
      $0.ObservationFormId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retrieveObservationForm, request,
        options: options);
  }

  $grpc.ResponseStream<$0.ObservationForm> retrieveObservationForms(
      $1.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveObservationForms, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.Question> retrieveQuestions(
      $0.RetrieveQuestionsRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$retrieveQuestions, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateObservation($0.Observation request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateObservation, request, options: options);
  }
}

abstract class ObservationBackendServiceBase extends $grpc.Service {
  $core.String get $name => 'observation.v1.ObservationBackend';

  ObservationBackendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ObservationForm, $1.Empty>(
        'CreateObservationForm',
        createObservationForm_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ObservationForm.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateObservationsRequest, $1.Empty>(
        'CreateObservations',
        createObservations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateObservationsRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $0.Observation>(
        'RetrieveObservations',
        retrieveObservations_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($0.Observation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ObservationFormId, $0.ObservationForm>(
        'RetrieveObservationForm',
        retrieveObservationForm_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ObservationFormId.fromBuffer(value),
        ($0.ObservationForm value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.ObservationForm>(
        'RetrieveObservationForms',
        retrieveObservationForms_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.ObservationForm value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RetrieveQuestionsRequest, $0.Question>(
        'RetrieveQuestions',
        retrieveQuestions_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.RetrieveQuestionsRequest.fromBuffer(value),
        ($0.Question value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Observation, $1.Empty>(
        'UpdateObservation',
        updateObservation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Observation.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> createObservationForm_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ObservationForm> request) async {
    return createObservationForm(call, await request);
  }

  $async.Future<$1.Empty> createObservations_Pre($grpc.ServiceCall call,
      $async.Future<$0.CreateObservationsRequest> request) async {
    return createObservations(call, await request);
  }

  $async.Stream<$0.Observation> retrieveObservations_Pre(
      $grpc.ServiceCall call, $async.Future<$0.StudentId> request) async* {
    yield* retrieveObservations(call, await request);
  }

  $async.Future<$0.ObservationForm> retrieveObservationForm_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ObservationFormId> request) async {
    return retrieveObservationForm(call, await request);
  }

  $async.Stream<$0.ObservationForm> retrieveObservationForms_Pre(
      $grpc.ServiceCall call, $async.Future<$1.Empty> request) async* {
    yield* retrieveObservationForms(call, await request);
  }

  $async.Stream<$0.Question> retrieveQuestions_Pre($grpc.ServiceCall call,
      $async.Future<$0.RetrieveQuestionsRequest> request) async* {
    yield* retrieveQuestions(call, await request);
  }

  $async.Future<$1.Empty> updateObservation_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Observation> request) async {
    return updateObservation(call, await request);
  }

  $async.Future<$1.Empty> createObservationForm(
      $grpc.ServiceCall call, $0.ObservationForm request);
  $async.Future<$1.Empty> createObservations(
      $grpc.ServiceCall call, $0.CreateObservationsRequest request);
  $async.Stream<$0.Observation> retrieveObservations(
      $grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$0.ObservationForm> retrieveObservationForm(
      $grpc.ServiceCall call, $0.ObservationFormId request);
  $async.Stream<$0.ObservationForm> retrieveObservationForms(
      $grpc.ServiceCall call, $1.Empty request);
  $async.Stream<$0.Question> retrieveQuestions(
      $grpc.ServiceCall call, $0.RetrieveQuestionsRequest request);
  $async.Future<$1.Empty> updateObservation(
      $grpc.ServiceCall call, $0.Observation request);
}
