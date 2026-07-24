import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';

class DashboardRepository {
  DashboardRepository({DemoStore? store})
    : _store = store ?? DemoStore.instance;

  final DemoStore _store;

  Future<AppResult<List<StaticMetric>>> loadMetrics(PortalRole role) async {
    try {
      return AppResult.success(_store.dashboardMetrics(role));
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to load local demo dashboard metrics.',
          detail: error,
        ),
      );
    }
  }
}
