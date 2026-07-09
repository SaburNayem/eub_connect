import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/routes/app_routes.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/model/static_account.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthSessionController _session = ensureAuthSession();
  final activeRole = PortalRole.student.obs;
  final selectedFeatureIndex = (-1).obs;
  final navigationQuery = ''.obs;

  StaticAccount get account => _session.account;

  @override
  void onInit() {
    super.onInit();
    activeRole.value = _session.role;
    ever(_session.currentAccount, (_) {
      activeRole.value = _session.role;
      selectedFeatureIndex.value = -1;
    });
  }

  DashboardProfile get dashboardProfile {
    return dashboardProfiles.firstWhere(
      (profile) => profile.role == activeRole.value,
      orElse: () => dashboardProfiles.first,
    );
  }

  List<StaticFeature> get accessibleFeatures {
    return staticFeatures
        .where((feature) => feature.access.contains(activeRole.value))
        .toList();
  }

  int get mobileDestinationIndex {
    final feature = selectedFeature;
    if (feature == null) {
      return 0;
    }

    switch (feature.category) {
      case 'Academic':
      case 'Teacher':
        return 1;
      case 'Finance':
        return 2;
      case 'Campus':
      case 'Communication':
        return 3;
      default:
        return 4;
    }
  }

  StaticFeature? get selectedFeature {
    if (selectedFeatureIndex.value < 0 ||
        selectedFeatureIndex.value >= staticFeatures.length) {
      return null;
    }

    return staticFeatures[selectedFeatureIndex.value];
  }

  void updateQuery(String value) {
    navigationQuery.value = value;
  }

  void selectDashboard({bool closeDrawer = false}) {
    selectedFeatureIndex.value = -1;
    if (closeDrawer) {
      Get.back();
    }
  }

  void selectFeature(int index, {bool closeDrawer = false}) {
    final feature = staticFeatures[index];
    if (!feature.access.contains(activeRole.value)) {
      showMessage('${feature.title} is not available for ${activeRole.value.label}');
      return;
    }

    selectedFeatureIndex.value = index;
    if (closeDrawer) {
      Get.back();
    }
  }

  void jumpToFeature(String title) {
    final index = staticFeatures.indexWhere((feature) {
      return feature.title == title &&
          feature.access.contains(activeRole.value);
    });
    if (index == -1) {
      showMessage('$title is not available for ${activeRole.value.label}');
      return;
    }

    selectFeature(index);
  }

  void selectMobileDestination(int index, {VoidCallback? onMenu}) {
    switch (index) {
      case 0:
        selectDashboard();
        return;
      case 1:
        _jumpToPreferredFeature(
          categories: const ['Academic', 'Teacher'],
          preferredTitles: _academicDestinationTitles(),
        );
        return;
      case 2:
        _jumpToPreferredFeature(
          categories: const ['Finance'],
          preferredTitles: const [
            'Tuition Fees',
            'Payment History',
            'Scholarships',
          ],
        );
        return;
      case 3:
        _jumpToPreferredFeature(
          categories: const ['Campus', 'Communication'],
          preferredTitles: const [
            'Events',
            'Notice Board',
            'Student Support',
            'Lost and Found',
            'Community Forum',
            'Discussion Board',
          ],
        );
        return;
      default:
        onMenu?.call();
        return;
    }
  }

  void _jumpToPreferredFeature({
    required List<String> categories,
    required List<String> preferredTitles,
  }) {
    for (final title in preferredTitles) {
      final index = staticFeatures.indexWhere((feature) {
        return feature.title == title &&
            feature.access.contains(activeRole.value);
      });
      if (index != -1) {
        selectFeature(index);
        return;
      }
    }

    final index = staticFeatures.indexWhere((feature) {
      return categories.contains(feature.category) &&
          feature.access.contains(activeRole.value);
    });
    if (index != -1) {
      selectFeature(index);
      return;
    }

    showMessage('Module');
  }

  List<String> _academicDestinationTitles() {
    switch (activeRole.value) {
      case PortalRole.student:
        return const [
          'Class Routine',
          'Assignments',
          'Attendance',
          'Results',
          'Semester Courses',
        ];
      case PortalRole.teacher:
        return const [
          'Teacher Portal',
          'Lecture Materials',
          'Attendance',
          'Quiz System',
          'Marks Result',
        ];
      case PortalRole.faculty:
        return const [
          'Academic Calendar',
          'Routine Management',
          'Department Management',
          'Results',
        ];
      case PortalRole.admin:
        return const [
          'Academic Calendar',
          'Routine Management',
          'Results',
          'Quiz System',
        ];
    }
  }

  void showMessage(String label) {
    Get.snackbar(
      'EUB Connect',
      '$label is ready in the demo',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(14),
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void signOut() {
    _session.signOut();
    Get.offAllNamed(AppRoutes.auth);
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeRole = _controller.activeRole.value;
      final selectedFeatureIndex = _controller.selectedFeatureIndex.value;
      final selectedFeature = _controller.selectedFeature;
      final dashboardProfile = _controller.dashboardProfile;
      final accessibleFeatures = _controller.accessibleFeatures;
      final navigationQuery = _controller.navigationQuery.value;
      final account = _controller.account;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1040;

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: isWide
                ? null
                : Drawer(
                    width: 318,
                    child: _NavigationPanel(
                      account: account,
                      activeRole: activeRole,
                      selectedFeatureIndex: selectedFeatureIndex,
                      query: navigationQuery,
                      onQueryChanged: _controller.updateQuery,
                      onDashboardSelected: () =>
                          _controller.selectDashboard(closeDrawer: true),
                      onFeatureSelected: (index) =>
                          _controller.selectFeature(index, closeDrawer: true),
                      onLogout: _controller.signOut,
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
                            _controller.jumpToFeature('Notifications'),
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      IconButton(
                        tooltip: 'Profile',
                        onPressed: () => _controller.jumpToFeature('Profile'),
                        icon: const Icon(Icons.account_circle_outlined),
                      ),
                    ],
                  ),
            bottomNavigationBar: isWide
                ? null
                : _MobileBottomNavigation(
                    selectedIndex: _controller.mobileDestinationIndex,
                    onDestinationSelected: (index) {
                      _controller.selectMobileDestination(
                        index,
                        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                      );
                    },
                  ),
            body: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: 304,
                    child: _NavigationPanel(
                      account: account,
                      activeRole: activeRole,
                      selectedFeatureIndex: selectedFeatureIndex,
                      query: navigationQuery,
                      onQueryChanged: _controller.updateQuery,
                      onDashboardSelected: _controller.selectDashboard,
                      onFeatureSelected: _controller.selectFeature,
                      onLogout: _controller.signOut,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      if (isWide)
                        _DesktopTopBar(
                          account: account,
                          onProfileTap: () =>
                              _controller.jumpToFeature('Profile'),
                          onNotificationsTap: () =>
                              _controller.jumpToFeature('Notifications'),
                          onLogout: _controller.signOut,
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
                                  _MobileAccountStrip(account: account),
                                if (!isWide) const SizedBox(height: 16),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: selectedFeature == null
                                      ? _DashboardView(
                                          key: ValueKey(activeRole),
                                          profile: dashboardProfile,
                                          accessibleFeatures:
                                              accessibleFeatures,
                                          onFeatureTap:
                                              _controller.jumpToFeature,
                                          onAction: _controller.showMessage,
                                        )
                                      : _FeatureDetailView(
                                          key: ValueKey(selectedFeature.title),
                                          feature: selectedFeature,
                                          onAction: _controller.showMessage,
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
    });
  }
}

class FeatureModuleScreen extends StatelessWidget {
  const FeatureModuleScreen({
    this.title,
    this.category = 'Module',
    this.feature,
    super.key,
  }) : assert(feature != null || title != null);

  final String? title;
  final String category;
  final StaticFeature? feature;

  StaticFeature get _feature {
    return feature ?? moduleFeature(title: title!, category: category);
  }

  @override
  Widget build(BuildContext context) {
    final feature = _feature;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: AppColors.white,
        title: Text(feature.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: _FeatureDetailView(
              feature: feature,
              onAction: (label) {
                Get.snackbar(
                  'EUB Connect',
                  '$label is ready in the demo',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(14),
                  backgroundColor: AppColors.primary,
                  colorText: AppColors.white,
                  duration: const Duration(seconds: 2),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureModuleControllerScreen<T extends GetxController>
    extends StatelessWidget {
  const FeatureModuleControllerScreen({
    required this.create,
    required this.featureBuilder,
    super.key,
  });

  final T Function() create;
  final StaticFeature Function(T controller) featureBuilder;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<T>()
        ? Get.find<T>()
        : Get.put(create());

    return Obx(() => FeatureModuleScreen(feature: featureBuilder(controller)));
  }
}

class _MobileBottomNavigation extends StatelessWidget {
  const _MobileBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      elevation: 0,
      selectedIndex: selectedIndex,
      backgroundColor: AppColors.white,
      indicatorColor: const Color(0xFFE9ECFF),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Academic',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Finance',
        ),
        NavigationDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign),
          label: 'Campus',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu_open),
          label: 'Menu',
        ),
      ],
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({
    required this.account,
    required this.onProfileTap,
    required this.onNotificationsTap,
    required this.onLogout,
  });

  final StaticAccount account;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onLogout;

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
          _AccountBadge(account: account),
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
          const SizedBox(width: 8),
          _IconAction(
            tooltip: 'Logout',
            icon: Icons.logout_outlined,
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _AccountBadge extends StatelessWidget {
  const _AccountBadge({required this.account});

  final StaticAccount account;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: account.role.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: account.role.color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(account.role.icon, color: account.role.color, size: 21),
          const SizedBox(width: 9),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: account.role.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  account.role.label,
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
        ],
      ),
    );
  }
}

class _MobileAccountStrip extends StatelessWidget {
  const _MobileAccountStrip({required this.account});

  final StaticAccount account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: account.role.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(account.role.icon, color: account.role.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${account.role.label} - ${account.email}',
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
        ],
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  const _NavigationPanel({
    required this.account,
    required this.activeRole,
    required this.selectedFeatureIndex,
    required this.query,
    required this.onQueryChanged,
    required this.onDashboardSelected,
    required this.onFeatureSelected,
    required this.onLogout,
  });

  final StaticAccount account;
  final PortalRole activeRole;
  final int selectedFeatureIndex;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onDashboardSelected;
  final ValueChanged<int> onFeatureSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final indexedFeatures = staticFeatures.asMap().entries.where((entry) {
      final feature = entry.value;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          feature.title.toLowerCase().contains(normalizedQuery) ||
          feature.category.toLowerCase().contains(normalizedQuery);
      return feature.access.contains(activeRole) && matchesQuery;
    }).toList();
    final categories = <String>{
      for (final entry in indexedFeatures) entry.value.category,
    }.toList();
    final pinnedEntries = normalizedQuery.isEmpty
        ? _pinnedFeatureEntries(activeRole)
        : <MapEntry<int, StaticFeature>>[];

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
              child: _RoleSummary(account: account),
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
                  if (pinnedEntries.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 18, 12, 8),
                      child: Text(
                        'PINNED FEATURES',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    _PinnedFeaturePanel(
                      entries: pinnedEntries,
                      selectedFeatureIndex: selectedFeatureIndex,
                      onFeatureSelected: onFeatureSelected,
                    ),
                  ],
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
                        subtitle: 'Available for ${activeRole.label}',
                        icon: entry.value.icon,
                        selected: selectedFeatureIndex == entry.key,
                        enabled: true,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
          actions: _dashboardActions(profile.role),
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

class _RoleSummary extends StatelessWidget {
  const _RoleSummary({required this.account});

  final StaticAccount account;

  @override
  Widget build(BuildContext context) {
    final role = account.role;

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
                  account.fullName,
                  style: TextStyle(
                    color: role.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${role.label} - ${account.department}',
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

class _PinnedFeaturePanel extends StatelessWidget {
  const _PinnedFeaturePanel({
    required this.entries,
    required this.selectedFeatureIndex,
    required this.onFeatureSelected,
  });

  final List<MapEntry<int, StaticFeature>> entries;
  final int selectedFeatureIndex;
  final ValueChanged<int> onFeatureSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: entries
            .map(
              (entry) => _PinnedFeatureTile(
                feature: entry.value,
                selected: selectedFeatureIndex == entry.key,
                onTap: () => onFeatureSelected(entry.key),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PinnedFeatureTile extends StatelessWidget {
  const _PinnedFeatureTile({
    required this.feature,
    required this.selected,
    required this.onTap,
  });

  final StaticFeature feature;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : feature.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xFFE9ECFF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minHeight: 62),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFE3E6EA),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(feature.icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        feature.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF98A2B3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
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

List<MapEntry<int, StaticFeature>> _pinnedFeatureEntries(PortalRole role) {
  final entries = <MapEntry<int, StaticFeature>>[];

  for (final title in _pinnedFeatureTitles(role)) {
    final index = staticFeatures.indexWhere((feature) {
      return feature.title == title && feature.access.contains(role);
    });
    if (index != -1 && entries.every((entry) => entry.key != index)) {
      entries.add(MapEntry(index, staticFeatures[index]));
    }
  }

  return entries;
}

List<String> _pinnedFeatureTitles(PortalRole role) {
  switch (role) {
    case PortalRole.student:
      return const [
        'Class Routine',
        'Assignments',
        'Attendance',
        'Tuition Fees',
        'Results',
        'Student Support',
      ];
    case PortalRole.teacher:
      return const [
        'Teacher Portal',
        'Attendance',
        'Lecture Materials',
        'Student Notices',
        'Marks Result',
        'Academic Report',
      ];
    case PortalRole.faculty:
      return const [
        'Faculty Portal',
        'Department Management',
        'Teacher Management',
        'Student Management',
        'Routine Management',
        'Payment History',
      ];
    case PortalRole.admin:
      return const [
        'Administration Panel',
        'User Roles',
        'System Activity',
        'Events',
        'Notice Board',
        'Settings',
      ];
  }
}

List<String> _dashboardActions(PortalRole role) {
  switch (role) {
    case PortalRole.student:
      return const [
        'View routine',
        'Submit assignment',
        'Pay tuition',
        'Open support',
      ];
    case PortalRole.teacher:
      return const [
        'Take attendance',
        'Upload material',
        'Publish notice',
        'Review marks',
      ];
    case PortalRole.faculty:
      return const [
        'Manage department',
        'Review payment',
        'Approve routine',
        'Export report',
      ];
    case PortalRole.admin:
      return const [
        'Manage roles',
        'Audit activity',
        'Publish notice',
        'Review approvals',
      ];
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
