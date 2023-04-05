import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/features/commons/data/analytics_item.dart';
import 'package:kinga/features/commons/domain/analytics_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseRestAnalyticsRepository implements AnalyticsRepository {

  FirebaseRestAnalyticsRepository() {
  }

  @override
  Future<void> createCsv() {
    // TODO: implement createCsv
    return Future.microtask(() {});
  }

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    // TODO: implement logEvent
    return Future.microtask(() {});
  }


}