import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/features/commons/data/analytics_item.dart';
import 'package:kinga/features/commons/domain/analytics_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseAnalyticsRepository implements AnalyticsRepository {


  late String currentInstitutionId;
  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAnalyticsRepository() {
    currentInstitutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
  }

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return Future.microtask(() {

      String analyticsString = GetIt.I<StreamingSharedPreferences>().getString("analytics", defaultValue: "[]").getValue();
      List<dynamic> analytics = json.decode(analyticsString);
      analytics.add(AnalyticsItem(DateTime.now(), name).toMap());
      analyticsString = json.encode(analytics);
      GetIt.I<StreamingSharedPreferences>().setString("analytics", analyticsString);

      String? userId = GetIt.I<AuthenticationService>().getCurrentUser()?.userId;
      if (userId != null && analytics.length >= 1) {
        // persist analytics to firestore
        var batch = db.batch();
        for (var analyticsItem in analytics) {
          var ref = db.collection('Analytics').doc(userId).collection('Event').doc();
          batch.set(ref, analyticsItem);
        }
        batch.commit().then((value) {
          // delete local analytics
          GetIt.I<StreamingSharedPreferences>().setString("analytics", "[]");
        });

      }

    });
  }

}