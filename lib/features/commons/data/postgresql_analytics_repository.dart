import 'package:kinga/features/commons/domain/analytics_repository.dart';

class PostgresqlAnalyticsRepository implements AnalyticsRepository {

  @override
  Future<void> createCsv() {
    // TODO: implement createCsv
    throw UnimplementedError();
  }

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    // TODO: implement logEvent
    //throw UnimplementedError();
    return;
  }

}