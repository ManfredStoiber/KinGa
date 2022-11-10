import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kinga/data/firebase_institution_repository.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/service/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseService> get firebaseService => FirebaseService.init();

  @preResolve
  Future<StreamingSharedPreferences> get sharedPreferences => StreamingSharedPreferences.instance;

  @injectable
  FirebaseAuth get auth => FirebaseAuth.instance;

  @injectable
  InstitutionRepository get institutionRepository => FirebaseInstitutionRepository();
}