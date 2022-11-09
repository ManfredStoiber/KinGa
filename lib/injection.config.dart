// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart'
    as _i6;

import 'domain/institution_repository.dart' as _i5;
import 'service/app_module.dart' as _i7;
import 'service/firebase_service.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i3.FirebaseAuth>(() => appModule.auth);
  await gh.factoryAsync<_i4.FirebaseService>(
    () => appModule.firebaseService,
    preResolve: true,
  );
  gh.factory<_i5.InstitutionRepository>(() => appModule.institutionRepository);
  await gh.factoryAsync<_i6.StreamingSharedPreferences>(
    () => appModule.sharedPreferences,
    preResolve: true,
  );
  return get;
}

class _$AppModule extends _i7.AppModule {}
