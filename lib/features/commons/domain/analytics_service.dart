import 'package:get_it/get_it.dart';
import 'package:kinga/features/commons/domain/analytics_repository.dart';

class AnalyticsService {

  final AnalyticsRepository _analyticsRepository = GetIt.I<AnalyticsRepository>();

  AnalyticsService() {
  }

  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    _analyticsRepository.logEvent(name: name, parameters: parameters);
  }

  Future<void> createCsv() {
    return _analyticsRepository.createCsv();
  }

}
