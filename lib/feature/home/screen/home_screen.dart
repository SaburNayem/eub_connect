import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PortalRole _activeRole = PortalRole.student;
  int _selectedFeatureIndex = -1;
  String _navigationQuery = '';

  DashboardProfile get _dashboardProfile {
    return dashboardProfiles.firstWhere(
      (profile) => profile.role == _activeRole,
      orElse: () => dashboardProfiles.first,
    );
  }

  List<StaticFeature> get _accessibleFeatures {
    return staticFeatures
        .where((feature) => feature.access.contains(_activeRole))
        .toList();
  }

  StaticFeature? get _selectedFeature {
    if (_selectedFeatureIndex < 0) {
      return null;
    }

    return staticFeatures[_selectedFeatureIndex];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1040;

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isWide
              ? null
              : Drawer(
                  width: 318,
                  child: _NavigationPanel(
                    activeRole: _activeRole,
                    selectedFeatureIndex: _selectedFeatureIndex,
                    query: _navigationQuery,
                    onQueryChanged: _updateQuery,
                    onDashboardSelected: () =>
                        _selectDashboard(closeDrawer: true),
                    onFeatureSelected: (index) =>
                        _selectFeature(index, closeDrawer: true),
                  ),
                ),
          appBar: isWide
              ? null
              : AppBar(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  surfaceTintColor: AppColors.white,
                  titleSpacing: 0,
                  title: const Text(
                    'EUB Connect',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () =>
                          _showStaticMessage('Notifications opened'),
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                    IconButton(
                      tooltip: 'Profile',
                      onPressed: () => _jumpToFeature('Profile'),
                      icon: const Icon(Icons.account_circle_outlined),
                    ),
                  ],
                ),
          body: Row(
            children: [
              if (isWide)
                SizedBox(
                  width: 304,
                  child: _NavigationPanel(
                    activeRole: _activeRole,
                    selectedFeatureIndex: _selectedFeatureIndex,
                    query: _navigationQuery,
                    onQueryChanged: _updateQuery,
                    onDashboardSelected: _selectDashboard,
                    onFeatureSelected: _selectFeature,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isWide)
                      _DesktopTopBar(
                        activeRole: _activeRole,
                        onRoleChanged: _setRole,
                        onProfileTap: () => _jumpToFeature('Profile'),
                        onNotificationsTap: () =>
                            _jumpToFeature('Notifications'),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 28 : 16,
                          isWide ? 24 : 16,
                          isWide ? 28 : 16,
                          28,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!isWide)
                                _RoleSwitcher(
                                  activeRole: _activeRole,
                                  onRoleChanged: _setRole,
                                ),
                              if (!isWide) const SizedBox(height: 16),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: _selectedFeature == null
                                    ? _DashboardView(
                                        key: ValueKey(_activeRole),
                                        profile: _dashboardProfile,
                                        accessibleFeatures: _accessibleFeatures,
                                        onFeatureTap: _jumpToFeature,
                                        onAction: _showStaticMessage,
                                      )
                                    : _FeatureDetailView(
                                        key: ValueKey(_selectedFeature!.title),
                                        feature: _selectedFeature!,
                                        onAction: _showStaticMessage,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateQuery(String value) {
    setState(() {
      _navigationQuery = value;
    });
  }

  void _setRole(PortalRole role) {
    setState(() {
      _activeRole = role;
    });
  }

  void _selectDashboard({bool closeDrawer = false}) {
    setState(() {
      _selectedFeatureIndex = -1;
    });
    if (closeDrawer) {
      Get.back();
    }
  }

  void _selectFeature(int index, {bool closeDrawer = false}) {
    setState(() {
      _selectedFeatureIndex = index;
    });
    if (closeDrawer) {
      Get.back();
    }
  }

  void _jumpToFeature(String title) {
    final index = staticFeatures.indexWhere(
      (feature) => feature.title == title,
    );
    if (index == -1) {
      _showStaticMessage('$title is not available');
      return;
    }

    _selectFeature(index);
  }

  void _showStaticMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label is ready in the static demo'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({
    required this.activeRole,
    required this.onRoleChanged,
    required this.onProfileTap,
    required this.onNotificationsTap,
  });

  final PortalRole activeRole;
  final ValueChanged<PortalRole> onRoleChanged;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE3E6EA))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'University Management System',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Static operations workspace',
                  style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                ),
              ],
            ),
          ),
          _RoleSwitcher(activeRole: activeRole, onRoleChanged: onRoleChanged),
          const SizedBox(width: 14),
          _IconAction(
            tooltip: 'Notifications',
            icon: Icons.notifications_outlined,
            onPressed: onNotificationsTap,
          ),
          const SizedBox(width: 8),
          _IconAction(
            tooltip: 'Profile',
            icon: Icons.account_circle_outlined,
            onPressed: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  const _NavigationPanel({
    required this.activeRole,
    required this.selectedFeatureIndex,
    required this.query,
    required this.onQueryChanged,
    required this.onDashboardSelected,
    required this.onFeatureSelected,
  });

  final PortalRole activeRole;
  final int selectedFeatureIndex;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onDashboardSelected;
  final ValueChanged<int> onFeatureSelected;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final indexedFeatures = staticFeatures.asMap().entries.where((entry) {
      final feature = entry.value;
      return normalizedQuery.isEmpty ||
          feature.title.toLowerCase().contains(normalizedQuery) ||
          feature.category.toLowerCase().contains(normalizedQuery);
    }).toList();
    final categories = <String>{
      for (final entry in indexedFeatures) entry.value.category,
    }.toList();

    return Container(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school, color: AppColors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EUB Connect',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Management console',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                onChanged: onQueryChanged,
                decoration: const InputDecoration(
                  hintText: 'Search modules',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              child: _RoleSummary(role: activeRole),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 18),
                children: [
                  _NavigationTile(
                    title: 'Dashboard',
                    subtitle: 'Role overview',
                    icon: Icons.dashboard_outlined,
                    selected: selectedFeatureIndex == -1,
                    onTap: onDashboardSelected,
                    enabled: true,
                  ),
                  for (final category in categories) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 18, 12, 8),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    for (final entry in indexedFeatures.where(
                      (entry) => entry.value.category == category,
                    ))
                      _NavigationTile(
                        title: entry.value.title,
                        subtitle: entry.value.access.contains(activeRole)
                            ? 'Available for ${activeRole.label}'
                            : 'Preview only',
                        icon: entry.value.icon,
                        selected: selectedFeatureIndex == entry.key,
                        enabled: entry.value.access.contains(activeRole),
                        onTap: () => onFeatureSelected(entry.key),
                      ),
                  ],
                  if (indexedFeatures.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No modules found',
                        style: TextStyle(color: Color(0xFF667085)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({
    required this.profile,
    required this.accessibleFeatures,
    required this.onFeatureTap,
    required this.onAction,
    super.key,
  });

  final DashboardProfile profile;
  final List<StaticFeature> accessibleFeatures;
  final ValueChanged<String> onFeatureTap;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderBand(
          icon: profile.role.icon,
          accent: profile.role.color,
          title: profile.headline,
          subtitle: profile.summary,
          trailing: _StatusPill(
            label: profile.role.label,
            color: profile.role.color,
          ),
        ),
        const SizedBox(height: 18),
        _MetricGrid(metrics: profile.metrics, accent: profile.role.color),
        const SizedBox(height: 18),
        _ResponsivePair(
          left: _RecordPanel(
            title: 'Priority Queue',
            subtitle: 'Current role focus',
            records: profile.priorities,
          ),
          right: _RecordPanel(
            title: 'Today Schedule',
            subtitle: 'Static calendar snapshot',
            records: profile.schedule,
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Role Modules',
          subtitle:
              '${accessibleFeatures.length} modules available for ${profile.role.label.toLowerCase()} access',
        ),
        const SizedBox(height: 10),
        _FeatureLaunchGrid(
          features: accessibleFeatures,
          onFeatureTap: onFeatureTap,
        ),
        const SizedBox(height: 18),
        _QuickActionPanel(
          actions: const [
            'Create notice',
            'Export report',
            'Review approvals',
            'Open support',
          ],
          onAction: onAction,
        ),
      ],
    );
  }
}

class _FeatureDetailView extends StatelessWidget {
  const _FeatureDetailView({
    required this.feature,
    required this.onAction,
    super.key,
  });

  final StaticFeature feature;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderBand(
          icon: feature.icon,
          accent: feature.accent,
          title: feature.title,
          subtitle: feature.description,
          trailing: Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.end,
            children: feature.access
                .map(
                  (role) => _StatusPill(label: role.label, color: role.color),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 18),
        _MetricGrid(metrics: feature.metrics, accent: feature.accent),
        const SizedBox(height: 18),
        _ResponsivePair(
          left: _QuickActionPanel(actions: feature.actions, onAction: onAction),
          right: _ModuleSnapshot(feature: feature),
        ),
        const SizedBox(height: 18),
        _RecordPanel(
          title: '${feature.title} Records',
          subtitle: feature.category,
          records: feature.records,
        ),
      ],
    );
  }
}

class _HeaderBand extends StatelessWidget {
  const _HeaderBand({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 720;

          final titleBlock = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accent, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleBlock,
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: trailing),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 18),
              Flexible(
                child: Align(alignment: Alignment.topRight, child: trailing),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics, required this.accent});

  final List<StaticMetric> metrics;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1020
            ? 4
            : constraints.maxWidth >= 640
            ? 2
            : 1;

        return GridView.builder(
          itemCount: metrics.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 128,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _MetricTile(metric: metric, accent: accent);
          },
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric, required this.accent});

  final StaticMetric metric;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, color: accent, size: 21),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Color(0xFF98A2B3), size: 20),
            ],
          ),
          const Spacer(),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ResponsivePair extends StatelessWidget {
  const _ResponsivePair({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 820) {
          return Column(children: [left, const SizedBox(height: 12), right]);
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              const SizedBox(width: 12),
              Expanded(child: right),
            ],
          ),
        );
      },
    );
  }
}

class _RecordPanel extends StatelessWidget {
  const _RecordPanel({
    required this.title,
    required this.subtitle,
    required this.records,
  });

  final String title;
  final String subtitle;
  final List<StaticRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _SectionHeader(title: title, subtitle: subtitle),
          ),
          const Divider(height: 1, color: Color(0xFFE3E6EA)),
          for (final record in records)
            _RecordTile(record: record, color: _statusColor(record.status)),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record, required this.color});

  final StaticRecord record;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(record.icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        record.title,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusPill(label: record.status, color: color),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  record.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  record.meta,
                  style: const TextStyle(
                    color: Color(0xFF475467),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionPanel extends StatelessWidget {
  const _QuickActionPanel({required this.actions, required this.onAction});

  final List<String> actions;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Quick Actions',
            subtitle: 'Static command center',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: actions
                .map(
                  (action) => OutlinedButton.icon(
                    onPressed: () => onAction(action),
                    icon: Icon(_actionIcon(action), size: 18),
                    label: Text(action),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ModuleSnapshot extends StatelessWidget {
  const _ModuleSnapshot({required this.feature});

  final StaticFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Module Snapshot', subtitle: feature.category),
          const SizedBox(height: 16),
          _SnapshotRow(
            icon: Icons.category_outlined,
            label: 'Category',
            value: feature.category,
            color: feature.accent,
          ),
          _SnapshotRow(
            icon: Icons.group_outlined,
            label: 'Access',
            value: feature.access.map((role) => role.label).join(', '),
            color: feature.accent,
          ),
          _SnapshotRow(
            icon: Icons.task_alt_outlined,
            label: 'Records',
            value: '${feature.records.length} highlighted',
            color: feature.accent,
          ),
          _SnapshotRow(
            icon: Icons.bolt_outlined,
            label: 'Actions',
            value: '${feature.actions.length} available',
            color: feature.accent,
          ),
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  const _SnapshotRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureLaunchGrid extends StatelessWidget {
  const _FeatureLaunchGrid({
    required this.features,
    required this.onFeatureTap,
  });

  final List<StaticFeature> features;
  final ValueChanged<String> onFeatureTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1020
            ? 4
            : constraints.maxWidth >= 720
            ? 3
            : constraints.maxWidth >= 520
            ? 2
            : 1;

        return GridView.builder(
          itemCount: features.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 118,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => onFeatureTap(feature.title),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE3E6EA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: feature.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              feature.icon,
                              color: feature.accent,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF98A2B3),
                            size: 18,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        feature.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        feature.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RoleSwitcher extends StatelessWidget {
  const _RoleSwitcher({required this.activeRole, required this.onRoleChanged});

  final PortalRole activeRole;
  final ValueChanged<PortalRole> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PortalRole.values.map((role) {
        final selected = role == activeRole;
        return ChoiceChip(
          selected: selected,
          avatar: Icon(
            role.icon,
            size: 17,
            color: selected ? AppColors.white : role.color,
          ),
          label: Text(role.label),
          labelStyle: TextStyle(
            color: selected ? AppColors.white : AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
          selectedColor: role.color,
          backgroundColor: AppColors.white,
          side: BorderSide(
            color: selected ? role.color : const Color(0xFFE3E6EA),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onSelected: (_) => onRoleChanged(role),
        );
      }).toList(),
    );
  }
}

class _RoleSummary extends StatelessWidget {
  const _RoleSummary({required this.role});

  final PortalRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: role.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: role.color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(role.icon, color: role.color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.label,
                  style: TextStyle(
                    color: role.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : const Color(0xFF344054);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? const Color(0xFFE9ECFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: enabled ? color : const Color(0xFF98A2B3),
                  size: 22,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: enabled ? color : const Color(0xFF98A2B3),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: enabled
                              ? const Color(0xFF667085)
                              : const Color(0xFF98A2B3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!enabled)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.visibility_outlined,
                      size: 17,
                      color: Color(0xFF98A2B3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: 42,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Icon(icon, size: 21),
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'urgent':
    case 'alert':
    case 'due':
    case 'flagged':
    case 'security':
      return const Color(0xFFB42318);
    case 'open':
    case 'pending':
    case 'review':
    case 'approval':
    case 'draft':
      return const Color(0xFFB54708);
    case 'paid':
    case 'published':
    case 'approved':
    case 'complete':
    case 'verified':
    case 'active':
    case 'enabled':
    case 'healthy':
    case 'ready':
    case 'live':
    case 'saved':
    case 'resolved':
    case 'done':
      return const Color(0xFF027A48);
    default:
      return const Color(0xFF344054);
  }
}

IconData _actionIcon(String action) {
  final lower = action.toLowerCase();
  if (lower.contains('create') || lower.contains('add')) {
    return Icons.add_circle_outline;
  }
  if (lower.contains('upload') || lower.contains('submit')) {
    return Icons.upload_file_outlined;
  }
  if (lower.contains('download') || lower.contains('export')) {
    return Icons.file_download_outlined;
  }
  if (lower.contains('pay')) {
    return Icons.payments_outlined;
  }
  if (lower.contains('approve') || lower.contains('publish')) {
    return Icons.verified_outlined;
  }
  if (lower.contains('view') || lower.contains('filter')) {
    return Icons.visibility_outlined;
  }
  if (lower.contains('contact') || lower.contains('send')) {
    return Icons.send_outlined;
  }
  if (lower.contains('logout')) {
    return Icons.logout_outlined;
  }

  return Icons.bolt_outlined;
}
