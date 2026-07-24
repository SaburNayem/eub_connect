import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/backend/supabase_backend.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardRepository {
  SupabaseClient? get _client => SupabaseBackend.client;

  Future<AppResult<List<StaticMetric>>> loadMetrics(PortalRole role) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final row = await client.from('dashboard_counts').select().maybeSingle();

      if (row == null) {
        return const AppResult.success([]);
      }

      return AppResult.success(_metricsForRole(role, row));
    } on PostgrestException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: error.message,
          detail: error,
        ),
      );
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to load dashboard metrics.',
          detail: error,
        ),
      );
    }
  }

  List<StaticMetric> _metricsForRole(
    PortalRole role,
    Map<String, dynamic> row,
  ) {
    final activeStudents = _readCount(row, 'active_students');
    final activeTeachers = _readCount(row, 'active_teachers');
    final activeDepartments = _readCount(row, 'active_departments');
    final openSupport = _readCount(row, 'open_support_tickets');
    final pendingApprovals = _readCount(row, 'pending_approvals');
    final pendingReports = _readCount(row, 'pending_moderation_reports');
    final publishedEvents = _readCount(row, 'published_events');

    switch (role) {
      case PortalRole.student:
        return [
          StaticMetric(
            label: 'Departments',
            value: '$activeDepartments',
            note: 'Active academic units',
            icon: Icons.account_tree_outlined,
          ),
          StaticMetric(
            label: 'Events',
            value: '$publishedEvents',
            note: 'Published events',
            icon: Icons.event_outlined,
          ),
          StaticMetric(
            label: 'Support',
            value: '$openSupport',
            note: 'Open tickets',
            icon: Icons.support_agent_outlined,
          ),
        ];
      case PortalRole.teacher:
        return [
          StaticMetric(
            label: 'Teachers',
            value: '$activeTeachers',
            note: 'Active faculty roster',
            icon: Icons.co_present_outlined,
          ),
          StaticMetric(
            label: 'Students',
            value: '$activeStudents',
            note: 'Active student records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Support',
            value: '$openSupport',
            note: 'Open tickets',
            icon: Icons.support_agent_outlined,
          ),
        ];
      case PortalRole.faculty:
        return [
          StaticMetric(
            label: 'Departments',
            value: '$activeDepartments',
            note: 'Active departments',
            icon: Icons.account_tree_outlined,
          ),
          StaticMetric(
            label: 'Students',
            value: '$activeStudents',
            note: 'Active records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Teachers',
            value: '$activeTeachers',
            note: 'Active roster',
            icon: Icons.co_present_outlined,
          ),
        ];
      case PortalRole.admin:
        return [
          StaticMetric(
            label: 'Students',
            value: '$activeStudents',
            note: 'Active records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Approvals',
            value: '$pendingApprovals',
            note: 'Pending requests',
            icon: Icons.verified_outlined,
          ),
          StaticMetric(
            label: 'Moderation',
            value: '$pendingReports',
            note: 'Pending reports',
            icon: Icons.report_outlined,
          ),
          StaticMetric(
            label: 'Support',
            value: '$openSupport',
            note: 'Open tickets',
            icon: Icons.support_agent_outlined,
          ),
        ];
    }
  }

  int _readCount(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value') ?? 0;
  }
}
