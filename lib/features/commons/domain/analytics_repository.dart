abstract class AnalyticsRepository {
  Future<void> logEvent({required String name, Map<String, Object?>? parameters});
  Future<void> createCsv();
}