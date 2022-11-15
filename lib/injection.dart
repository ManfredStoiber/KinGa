import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_authentication_repository.dart';
import 'package:kinga/data/firebase_institution_repository.dart';
import 'package:kinga/data/firebase_rest_authentication_repository.dart';
import 'package:kinga/data/firebase_rest_institution_repository.dart';
import 'package:kinga/data/firebase_rest_student_repository.dart';
import 'package:kinga/data/firebase_student_repository.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/firebase_options.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

@InjectableInit()
Future<void> configureDependencies() async {
  GetIt.I.registerSingleton<String>('identitytoolkit.googleapis.com', instanceName: Keys.firebaseAuthUrl);
  GetIt.I.registerSingleton<String>('firestore.googleapis.com', instanceName: Keys.firebaseFirestoreUrl);
  GetIt.I.registerSingleton<String>('AIzaSyD1bsq7scBz7iyyTLJm-qnS1qap9N9JrUk', instanceName: Keys.firebaseApiKey);
  GetIt.I.registerSingleton<StreamingSharedPreferences>(await StreamingSharedPreferences.instance);
  if (Platform.isWindows || Platform.isLinux) {
    GetIt.I.registerSingleton<AuthenticationRepository>(FirebaseRestAuthenticationRepository());
    GetIt.I.registerSingleton<StudentRepository>(FirebaseRestStudentRepository());
    GetIt.I.registerSingleton<InstitutionRepository>(FirebaseRestInstitutionRepository());
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    GetIt.I.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    GetIt.I.registerSingleton<AuthenticationRepository>(FirebaseAuthenticationRepository());
    GetIt.I.registerSingleton<StudentRepository>(FirebaseStudentRepository());
    GetIt.I.registerSingleton<InstitutionRepository>(FirebaseInstitutionRepository());
  }
  GetIt.I.registerSingleton<AuthenticationService>(AuthenticationService());
  GetIt.I.registerSingleton<StudentService>(StudentService());
}
