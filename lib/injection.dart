import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/oauth_authentication_repository.dart';
import 'package:kinga/data/postgresql_institution_repository.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/commons/data/postgresql_analytics_repository.dart';
import 'package:kinga/features/commons/domain/analytics_repository.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/connectivity_indicator/connection_status_singleton.dart';
import 'package:kinga/features/observations/domain/observation_repository.dart';
import 'package:kinga/features/observations/domain/observation_service.dart';
import 'package:kinga/features/permissions/data/postgresql_permission_repository.dart';
import 'package:kinga/features/permissions/domain/permission_repository.dart';
import 'package:kinga/features/permissions/domain/permission_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'data/postgresql_student_repository.dart';
import 'features/observations/data/postgresql_observation_repository.dart';

Future<Map<String, Uint8List>> loadProfileImages() async {
  Map<String, Uint8List> profileImages = {};
  var profileImagesDirectory = Directory('${GetIt.I<Directory>(instanceName: Keys.applicationDocumentsDirectory).path}${Platform.pathSeparator}profileImages');
  if (profileImagesDirectory.existsSync()) {
    for (var fileSystemEntity in profileImagesDirectory.listSync()) {
      if (fileSystemEntity is File) {
        profileImages[basename(fileSystemEntity.path)] = fileSystemEntity.readAsBytesSync();
      }
    }
  }
  return profileImages;
}

Future<void> configureDependencies() async {
  GetIt.I.registerSingleton<StreamingSharedPreferences>(await StreamingSharedPreferences.instance);
  GetIt.I.registerSingleton<Directory>(await getApplicationDocumentsDirectory(), instanceName: Keys.applicationDocumentsDirectory);
  GetIt.I.registerSingleton<Map<String, Uint8List>>(await loadProfileImages(), instanceName: Keys.profileImagesCache);
  if (Platform.isWindows || Platform.isLinux) {
  } else {
    GetIt.I.registerSingleton<AuthenticationRepository>(OAuthAuthenticationRepository());
    GetIt.I.registerSingleton<StudentRepository>(PostgreSQLStudentRepository());
    GetIt.I.registerSingleton<InstitutionRepository>(PostgreSQLInstitutionRepository());
  }
  GetIt.I.registerSingleton<AuthenticationService>(AuthenticationService());
  GetIt.I.registerSingleton<StudentService>(StudentService());

  // observations
  if (!(Platform.isWindows || Platform.isLinux)) {
    GetIt.I.registerSingleton<ObservationRepository>(PostgresqlObservationRepository());
    GetIt.I.registerSingleton<ObservationService>(ObservationService());
  }

  // permissions
  if (!(Platform.isWindows || Platform.isLinux)) {
    GetIt.I.registerSingleton<PermissionRepository>(PostgresqlPermissionRepository());
    GetIt.I.registerSingleton<PermissionService>(PermissionService());
  }

  // analytics
  if (!(Platform.isWindows || Platform.isLinux)) {
    GetIt.I.registerSingleton<AnalyticsRepository>(PostgresqlAnalyticsRepository());
    GetIt.I.registerSingleton<AnalyticsService>(AnalyticsService());
  }

  // connection status singleton
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

}
