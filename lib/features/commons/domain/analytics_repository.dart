import 'package:kinga/domain/entity/user.dart';

abstract class AnalyticsRepository {
  Future<void> logEvent({required String name, Map<String, Object?>? parameters});
  Future<void> createCsv();
}