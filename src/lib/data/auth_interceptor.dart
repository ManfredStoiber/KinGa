import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:kinga/data/oauth_authentication_repository.dart';
import 'package:kinga/domain/authentication_repository.dart';

class AuthInterceptor extends ClientInterceptor {

  late final OAuthAuthenticationRepository _authenticationRepository;

  FutureOr<void> _provider(Map<String, String> metadata, String uri) async {
    final token = await _authenticationRepository.getAccessToken();
    metadata['Authorization'] = "Bearer $token";
  }

  AuthInterceptor() {
    _authenticationRepository = GetIt.I<AuthenticationRepository>() as OAuthAuthenticationRepository;
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request, CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    final CallOptions newOptions = options.mergedWith(CallOptions(
      providers:  [_provider],
    ));
    return super.interceptUnary(method, request, newOptions, invoker);
  }

}