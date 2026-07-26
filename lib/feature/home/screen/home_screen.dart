import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/data/async_value.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/core/routes/app_routes.dart';
import 'package:eub_connect/core/ui/state_panels.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/model/app_account.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:eub_connect/feature/home/repository/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthSessionController _session = ensureAuthSession();
  final DashboardRepository _dashboardRepository = DashboardRepository();
  final DemoStore _demoStore = DemoStore.instance;
  final activeRole = PortalRole.student.obs;
  final selectedFeatureIndex = (-1).obs;
  final selectedNavigationGroupIndex = 0.obs;
  final selectedBottomNavigationIndex = 0.obs;
  final navigationQuery = ''.obs;
  final dashboardMetrics = const AsyncValue<List<StaticMetric>>.loading().obs;

  AppAccount get account => _session.account;

  @override
  void onInit() {
    super.onInit();
    activeRole.value = _session.role;
    loadDashboardMetrics();
    ever(_session.currentAccount, (_) {
      activeRole.value = _session.role;
      selectedFeatureIndex.value = -1;
      selectedNavigationGroupIndex.value = 0;
      selectedBottomNavigationIndex.value = 0;
      navigationQuery.value = '';
      loadDashboardMetrics();
    });
    ever(_demoStore.revision, (_) => loadDashboardMetrics());
  }

  DashboardProfile get dashboardProfile {
    return dashboardProfiles.firstWhere(
      (profile) => profile.role == activeRole.value,
      orElse: () => dashboardProfiles.first,
    );
  }

  List<StaticFeature> get accessibleFeatures {
    return _navigationEntriesForRole(
      activeRole.value,
    ).map((entry) => entry.value).toList();
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

  void selectNavigationGroup(int index) {
    selectedNavigationGroupIndex.value = index;
    selectedBottomNavigationIndex.value = index;
    selectedFeatureIndex.value = -1;
  }

  void selectBottomNavigation(int index) {
    selectedBottomNavigationIndex.value = index;
    selectedNavigationGroupIndex.value = index;
    selectedFeatureIndex.value = -1;
  }

  void selectDashboard({bool closeDrawer = false}) {
    selectedFeatureIndex.value = -1;
    if (closeDrawer) {
      Get.back();
    }
  }

  void selectFeature(int index, {bool closeDrawer = false}) {
    if (index < 0 || index >= staticFeatures.length) {
      showMessage('Feature');
      return;
    }

    final feature = staticFeatures[index];
    if (!feature.access.contains(activeRole.value)) {
      showMessage(
        '${feature.title} is not available for ${activeRole.value.label}',
      );
      return;
    }

    selectedFeatureIndex.value = -1;
    _openFeature(feature, closeDrawer: closeDrawer);
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

    _openFeature(staticFeatures[index]);
  }

  void _openFeature(StaticFeature feature, {bool closeDrawer = false}) {
    void pushFeature() {
      final route = _routeForFeature(feature);
      if (route == null) {
        Get.to(() => FeatureModuleScreen(feature: feature));
        return;
      }

      Get.toNamed(route);
    }

    if (closeDrawer) {
      Get.back();
      Future<void>.delayed(const Duration(milliseconds: 120), pushFeature);
      return;
    }

    pushFeature();
  }

  String? _routeForFeature(StaticFeature feature) {
    switch (feature.title) {
      case 'Authentication':
        return AppRoutes.auth;
      case 'Student Portal':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentProfile
            : AppRoutes.studentManagement;
      case 'Teacher Portal':
        return AppRoutes.teacherDashboard;
      case 'Administration Portal':
        return AppRoutes.adminFaculty;
      case 'Admin Dashboard':
        return null;
      case 'Departments':
        return AppRoutes.departments;
      case 'Department Management':
        return AppRoutes.departmentManagement;
      case 'Programs':
      case 'Courses':
      case 'Sections':
      case 'Administration Staff':
      case 'Admissions':
      case 'Examinations':
      case 'Student Requests':
      case 'Invoices':
      case 'Payments':
      case 'Scholarships/Waivers':
      case 'Support Tickets':
      case 'Complaints/Cases':
      case 'Community Moderation':
      case 'Clubs':
      case 'Activity Log':
        return null;
      case 'Teacher Management':
        return AppRoutes.teacherManagement;
      case 'Student Management':
        return AppRoutes.studentManagement;
      case 'Events':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentEvents
            : AppRoutes.events;
      case 'Routine Management':
        return AppRoutes.routineManagement;
      case 'Class Routine':
        return AppRoutes.studentClassRoutine;
      case 'Academic Calendar':
        return AppRoutes.academicCalendar;
      case 'Lost and Found':
        return AppRoutes.lostFound;
      case 'Notice Board':
        return AppRoutes.notice;
      case 'Assignments':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentAssignments
            : AppRoutes.assignmentQuiz;
      case 'Attendance':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentAttendance
            : AppRoutes.attendanceManagement;
      case 'Student Notices':
        return AppRoutes.noticeForStudent;
      case 'Lecture Materials':
        return AppRoutes.lectureMaterials;
      case 'Academic Report':
        return AppRoutes.teacherAcademicReport;
      case 'Marks Result':
        return AppRoutes.marksResult;
      case 'Community Forum':
        return AppRoutes.studentClubCommunity;
      case 'Discussion Board':
        return AppRoutes.studentDiscussionForum;
      case 'Tuition Fees':
        return AppRoutes.studentTuitionFee;
      case 'Scholarships':
        return AppRoutes.studentScholarships;
      case 'Quiz System':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentQuizPractice
            : AppRoutes.assignmentQuiz;
      case 'Results':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentExamResults
            : AppRoutes.resultReport;
      case 'Payment History':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentPaymentHistory
            : AppRoutes.payment;
      case 'User Roles':
        return AppRoutes.userRoleManagement;
      case 'System Activity':
        return AppRoutes.systemActivity;
      case 'Notifications':
      case 'Settings':
        return AppRoutes.settings;
      case 'Student Support':
        return AppRoutes.studentSupport;
      case 'Semester Courses':
        return AppRoutes.studentSemesterCourses;
      case 'Profile':
        return activeRole.value == PortalRole.student
            ? AppRoutes.studentProfile
            : null;
      default:
        return null;
    }
  }

  Future<void> loadDashboardMetrics() async {
    dashboardMetrics.value = const AsyncValue.loading();
    final result = await _dashboardRepository.loadMetrics(activeRole.value);
    if (result.isSuccess) {
      dashboardMetrics.value = AsyncValue.data(result.requireData);
      return;
    }

    dashboardMetrics.value = AsyncValue.error(
      result.failure?.message ?? 'Unable to load dashboard metrics.',
    );
  }

  void showMessage(String label) {
    Get.snackbar(
      'EUB Connect',
      '$label is available through the local demo workspace.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(14),
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> signOut() async {
    await _session.signOut();
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
      final selectedNavigationGroupIndex =
          _controller.selectedNavigationGroupIndex.value;
      final selectedBottomNavigationIndex =
          _controller.selectedBottomNavigationIndex.value;
      final dashboardProfile = _controller.dashboardProfile;
      final dashboardMetricState = _controller.dashboardMetrics.value;
      final accessibleFeatures = _controller.accessibleFeatures;
      final navigationQuery = _controller.navigationQuery.value;
      final account = _controller.account;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1040;
          final drawerWidth = constraints.maxWidth >= 430
              ? 360.0
              : constraints.maxWidth * 0.9;
          final mobileNavigationGroups = _navigationGroupsForRole(activeRole);
          final selectedMobileGroupIndex = _safeNavigationGroupIndex(
            selectedBottomNavigationIndex,
            mobileNavigationGroups.length,
          );
          final selectedMobileGroup =
              mobileNavigationGroups[selectedMobileGroupIndex];
          final selectedMobileFeatures = _navigationEntriesForGroup(
            selectedMobileGroup,
            activeRole,
          ).map((entry) => entry.value).toList();
          final dashboardFeatures = isWide
              ? accessibleFeatures
              : selectedMobileFeatures;
          final showOperationsDashboard =
              isWide ||
              ((activeRole == PortalRole.admin ||
                      activeRole == PortalRole.administration) &&
                  selectedMobileGroupIndex == 0);

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: isWide
                ? null
                : Drawer(
                    width: drawerWidth,
                    child: _NavigationPanel(
                      account: account,
                      activeRole: activeRole,
                      selectedFeatureIndex: selectedFeatureIndex,
                      selectedNavigationGroupIndex:
                          selectedNavigationGroupIndex,
                      query: navigationQuery,
                      onQueryChanged: _controller.updateQuery,
                      onGroupSelected: _controller.selectNavigationGroup,
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
                    title: Text(
                      '${selectedMobileGroup.title} ${activeRole.label}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Search features',
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        icon: const Icon(Icons.search),
                      ),
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
                    groups: mobileNavigationGroups,
                    selectedIndex: selectedMobileGroupIndex,
                    onSelected: _controller.selectBottomNavigation,
                  ),
            body: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: 328,
                    child: _NavigationPanel(
                      account: account,
                      activeRole: activeRole,
                      selectedFeatureIndex: selectedFeatureIndex,
                      selectedNavigationGroupIndex:
                          selectedNavigationGroupIndex,
                      query: navigationQuery,
                      onQueryChanged: _controller.updateQuery,
                      onGroupSelected: _controller.selectNavigationGroup,
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
                                if (showOperationsDashboard)
                                  _DashboardView(
                                    key: ValueKey(activeRole),
                                    profile: dashboardProfile,
                                    accessibleFeatures: dashboardFeatures,
                                    metricsState: dashboardMetricState,
                                    featureTitle: isWide
                                        ? 'Role Features'
                                        : '${selectedMobileGroup.title} Actions',
                                    featureSubtitle:
                                        '${dashboardFeatures.length} features available for ${dashboardProfile.role.label.toLowerCase()} access',
                                    onFeatureTap: _controller.jumpToFeature,
                                  )
                                else
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: _MobileSectionView(
                                      key: ValueKey(
                                        '$activeRole-$selectedMobileGroupIndex',
                                      ),
                                      role: activeRole,
                                      group: selectedMobileGroup,
                                      features: dashboardFeatures,
                                      onFeatureTap: _controller.jumpToFeature,
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

double _dashboardTextScale(BuildContext context) {
  return MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 3.0).toDouble();
}

class FeatureModuleScreen extends StatelessWidget {
  const FeatureModuleScreen({
    this.title,
    this.category = 'Feature',
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
    return Obx(() {
      final store = DemoStore.instance;
      final revision = store.revision.value;
      final feature = store.hydrateFeature(_feature, ensureAuthSession().role);

      return KeyedSubtree(
        key: ValueKey(revision),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
            surfaceTintColor: AppColors.white,
            leading: BackButton(onPressed: () => Get.back()),
            title: Text(feature.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: _FeatureDetailView(feature: feature),
              ),
            ),
          ),
        ),
      );
    });
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
    required this.groups,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavigationGroup> groups;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    final safeIndex = _safeNavigationGroupIndex(selectedIndex, groups.length);
    final hasCompactTabCount = groups.length <= 5;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 6, 8, hasCompactTabCount ? 6 : 8),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: Color(0xFFE3E6EA))),
        ),
        child: SizedBox(
          height: hasCompactTabCount ? 62 : 64,
          child: hasCompactTabCount
              ? Row(
                  children: [
                    for (var index = 0; index < groups.length; index++)
                      Expanded(
                        child: _MobileBottomNavigationItem(
                          group: groups[index],
                          selected: index == safeIndex,
                          onTap: () => onSelected(index),
                        ),
                      ),
                  ],
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 76,
                      child: _MobileBottomNavigationItem(
                        group: groups[index],
                        selected: index == safeIndex,
                        onTap: () => onSelected(index),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _MobileBottomNavigationItem extends StatelessWidget {
  const _MobileBottomNavigationItem({
    required this.group,
    required this.selected,
    required this.onTap,
  });

  final _NavigationGroup group;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? group.color : const Color(0xFF667085);
    final background = selected
        ? group.color.withValues(alpha: 0.12)
        : Colors.transparent;

    return Semantics(
      button: true,
      selected: selected,
      label: '${group.title} section',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    width: selected ? 38 : 34,
                    height: 30,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(group.icon, color: foreground, size: 20),
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          group.title,
                          maxLines: 1,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 11,
                            fontWeight: selected
                                ? FontWeight.w900
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  final AppAccount account;
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
                  'Local demo operations workspace',
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

  final AppAccount account;

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

  final AppAccount account;

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
    required this.selectedNavigationGroupIndex,
    required this.query,
    required this.onQueryChanged,
    required this.onGroupSelected,
    required this.onFeatureSelected,
    required this.onLogout,
  });

  final AppAccount account;
  final PortalRole activeRole;
  final int selectedFeatureIndex;
  final int selectedNavigationGroupIndex;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<int> onGroupSelected;
  final ValueChanged<int> onFeatureSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final groups = _navigationGroupsForRole(activeRole);
    final normalizedQuery = query.trim().toLowerCase();
    final allEntries = _navigationEntriesForGroups(groups, activeRole);
    final selectedGroupIndex = _safeNavigationGroupIndex(
      selectedNavigationGroupIndex,
      groups.length,
    );
    final selectedGroup = groups.isEmpty ? null : groups[selectedGroupIndex];
    final visibleEntries = normalizedQuery.isEmpty
        ? (selectedGroup == null
              ? <MapEntry<int, StaticFeature>>[]
              : _navigationEntriesForGroup(selectedGroup, activeRole))
        : allEntries.where((entry) {
            final feature = entry.value;
            return feature.title.toLowerCase().contains(normalizedQuery) ||
                feature.category.toLowerCase().contains(normalizedQuery) ||
                feature.description.toLowerCase().contains(normalizedQuery);
          }).toList();

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EUB Connect',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${account.role.label} workspace',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
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
                  hintText: 'Search features',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
              child: _RoleSummary(account: account),
            ),
            if (normalizedQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                child: _NavigationSegmentBar(
                  groups: groups,
                  selectedIndex: selectedGroupIndex,
                  onSelected: onGroupSelected,
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
                children: [
                  if (normalizedQuery.isEmpty && selectedGroup != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                      child: _NavigationGroupHeader(group: selectedGroup),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                      child: _SectionHeader(
                        title: 'Search Results',
                        subtitle:
                            '${visibleEntries.length} features for ${activeRole.label.toLowerCase()}',
                      ),
                    ),
                  for (final entry in visibleEntries)
                    _NavigationTile(
                      title: entry.value.title,
                      subtitle: entry.value.category,
                      icon: entry.value.icon,
                      selected: selectedFeatureIndex == entry.key,
                      enabled: true,
                      onTap: () => onFeatureSelected(entry.key),
                    ),
                  if (visibleEntries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No features found',
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
    required this.metricsState,
    required this.featureTitle,
    required this.featureSubtitle,
    required this.onFeatureTap,
    super.key,
  });

  final DashboardProfile profile;
  final List<StaticFeature> accessibleFeatures;
  final AsyncValue<List<StaticMetric>> metricsState;
  final String featureTitle;
  final String featureSubtitle;
  final ValueChanged<String> onFeatureTap;

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
        _DashboardMetricStateView(
          state: metricsState,
          accent: profile.role.color,
        ),
        if (profile.role == PortalRole.admin ||
            profile.role == PortalRole.administration) ...[
          const SizedBox(height: 18),
          _OperationsDashboardSections(
            role: profile.role,
            accent: profile.role.color,
            onFeatureTap: onFeatureTap,
          ),
        ],
        const SizedBox(height: 18),
        _SectionHeader(title: featureTitle, subtitle: featureSubtitle),
        const SizedBox(height: 10),
        _FeatureLaunchGrid(
          features: accessibleFeatures,
          onFeatureTap: onFeatureTap,
        ),
      ],
    );
  }
}

class _OperationsDashboardSections extends StatelessWidget {
  const _OperationsDashboardSections({
    required this.role,
    required this.accent,
    required this.onFeatureTap,
  });

  final PortalRole role;
  final Color accent;
  final ValueChanged<String> onFeatureTap;

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    if (role == PortalRole.administration) {
      final officeFeature = store.hydrateFeature(
        moduleFeature(title: 'Administration Portal'),
        role,
      );
      final requestFeature = store.hydrateFeature(
        moduleFeature(title: 'Student Requests'),
        role,
      );
      final supportFeature = store.hydrateFeature(
        moduleFeature(title: 'Support Tickets'),
        role,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DashboardQuickActions(
            actions: const [
              'Student Requests',
              'Support Tickets',
              'Notice Board',
              'Examinations',
              'Payments',
            ],
            accent: accent,
            onFeatureTap: onFeatureTap,
          ),
          const SizedBox(height: 18),
          _DashboardSectionPanel(
            title: 'Office Workflow',
            subtitle:
                'Requests, support, and documents assigned to the current office',
            metrics: officeFeature.metrics.take(6).toList(),
            records: officeFeature.records.take(8).toList(),
            accent: accent,
          ),
          const SizedBox(height: 18),
          _DashboardSectionPanel(
            title: 'Student Requests',
            subtitle: 'Office-scoped document and service requests',
            metrics: requestFeature.metrics,
            records: requestFeature.records.take(6).toList(),
            accent: accent,
          ),
          const SizedBox(height: 18),
          _DashboardSectionPanel(
            title: 'Support Cases',
            subtitle: 'Tickets routed to this office',
            metrics: supportFeature.metrics,
            records: supportFeature.records.take(6).toList(),
            accent: accent,
          ),
        ],
      );
    }

    final adminFeature = store.hydrateFeature(
      moduleFeature(title: 'Admin Dashboard'),
      role,
    );
    final admissionFeature = store.hydrateFeature(
      moduleFeature(title: 'Admissions'),
      role,
    );
    final examFeature = store.hydrateFeature(
      moduleFeature(title: 'Examinations'),
      role,
    );
    final financeFeature = store.hydrateFeature(
      moduleFeature(title: 'Invoices'),
      role,
    );
    final paymentFeature = store.hydrateFeature(
      moduleFeature(title: 'Payments'),
      role,
    );
    final requestFeature = store.hydrateFeature(
      moduleFeature(title: 'Student Requests'),
      role,
    );
    final departmentFeature = store.hydrateFeature(
      moduleFeature(title: 'Department Management'),
      role,
    );

    final academicMetrics = [
      StaticMetric(
        label: 'Classes Today',
        value: '${store.todayScheduleCount()}',
        note: 'Routine entries',
        icon: Icons.today_outlined,
      ),
      StaticMetric(
        label: 'Avg Attendance',
        value: '${store.averageAttendancePercent().round()}%',
        note: 'Attendance rows',
        icon: Icons.query_stats_outlined,
      ),
      StaticMetric(
        label: 'Assignments Active',
        value:
            '${store.assignments.where((assignment) => assignment.status == 'published').length}',
        note: 'Published tasks',
        icon: Icons.assignment_outlined,
      ),
      StaticMetric(
        label: 'Pending Grading',
        value:
            '${store.submissions.where((submission) => submission.status != 'graded').length}',
        note: 'Submissions',
        icon: Icons.rate_review_outlined,
      ),
      StaticMetric(
        label: 'Active Quizzes',
        value:
            '${store.quizzes.where((quiz) => quiz.status == 'published').length}',
        note: 'Published quizzes',
        icon: Icons.quiz_outlined,
      ),
      StaticMetric(
        label: 'Courses With Problems',
        value:
            '${store.sections.where((section) => store.enrollments.where((enrollment) => enrollment.sectionId == section.id).length > section.capacity).length}',
        note: 'Over capacity',
        icon: Icons.warning_amber_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DashboardQuickActions(
          actions: const [
            'Student Management',
            'Teacher Management',
            'Administration Staff',
            'Notice Board',
            'Events',
            'Student Requests',
            'Community Moderation',
            'Payments',
          ],
          accent: accent,
          onFeatureTap: onFeatureTap,
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Needs Attention',
          subtitle:
              'Calculated from overdue invoices, low attendance, grading, support, reports, results, and capacity',
          metrics: adminFeature.metrics.skip(8).take(4).toList(),
          records: store.needsAttentionRecords(),
          accent: accent,
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Academic Operations',
          subtitle:
              'Classes, attendance, active assignments, grading, quizzes, and capacity',
          metrics: academicMetrics,
          records: departmentFeature.records.take(6).toList(),
          accent: const Color(0xFF2A2D7E),
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Finance Overview',
          subtitle:
              'Billed, collected, outstanding, overdue, verification, transactions, and ledgers',
          metrics: [
            ...financeFeature.metrics,
            ...paymentFeature.metrics.take(2),
          ],
          records: [
            ...paymentFeature.records.take(4),
            ...financeFeature.records.take(4),
          ],
          accent: const Color(0xFFCA8A04),
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Admission Overview',
          subtitle:
              'Application -> document review -> eligible -> approved -> payment -> registered',
          metrics: admissionFeature.metrics,
          records: admissionFeature.records.take(8).toList(),
          accent: const Color(0xFF0F766E),
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Examination Overview',
          subtitle:
              'Schedules, admit cards, result submission, approval, publication, and supplementary cases',
          metrics: examFeature.metrics,
          records: examFeature.records.take(8).toList(),
          accent: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Student Services',
          subtitle:
              'Support tickets, document requests, registration issues, complaints, events, and clubs',
          metrics: requestFeature.metrics,
          records: requestFeature.records.take(8).toList(),
          accent: const Color(0xFF007F3D),
        ),
        const SizedBox(height: 18),
        _DashboardSectionPanel(
          title: 'Administration Offices',
          subtitle:
              'Office heads, staff count, open tasks, pending requests, and status',
          metrics: const [],
          records: store.administrationOfficeRecords(),
          accent: const Color(0xFF0F766E),
        ),
      ],
    );
  }
}

class _DashboardQuickActions extends StatelessWidget {
  const _DashboardQuickActions({
    required this.actions,
    required this.accent,
    required this.onFeatureTap,
  });

  final List<String> actions;
  final Color accent;
  final ValueChanged<String> onFeatureTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          title: 'Quick Actions',
          subtitle: 'Open the local workflow pages and dialogs used most often',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final action in actions)
              OutlinedButton.icon(
                onPressed: () => onFeatureTap(action),
                icon: Icon(moduleFallbackIcon(action), size: 18),
                label: Text(action),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DashboardSectionPanel extends StatelessWidget {
  const _DashboardSectionPanel({
    required this.title,
    required this.subtitle,
    required this.metrics,
    required this.records,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final List<StaticMetric> metrics;
  final List<StaticRecord> records;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: title, subtitle: subtitle),
        if (metrics.isNotEmpty) ...[
          const SizedBox(height: 10),
          _MetricGrid(metrics: metrics, accent: accent),
        ],
        if (records.isNotEmpty) ...[
          const SizedBox(height: 10),
          for (final record in records.take(10)) ...[
            _FeatureRecordTile(record: record, accent: accent),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _DashboardMetricStateView extends StatelessWidget {
  const _DashboardMetricStateView({required this.state, required this.accent});

  final AsyncValue<List<StaticMetric>> state;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const LoadingPanel();
    }

    final error = state.error;
    if (error != null) {
      return ErrorStatePanel(message: error);
    }

    final metrics = state.data ?? const <StaticMetric>[];
    if (metrics.isEmpty) {
      return const EmptyStatePanel(
        title: 'No dashboard records yet',
        message:
            'Demo metrics are calculated from the local university dataset.',
        icon: Icons.query_stats_outlined,
      );
    }

    return _MetricGrid(metrics: metrics, accent: accent);
  }
}

class _MobileSectionView extends StatelessWidget {
  const _MobileSectionView({
    required this.role,
    required this.group,
    required this.features,
    required this.onFeatureTap,
    super.key,
  });

  final PortalRole role;
  final _NavigationGroup group;
  final List<StaticFeature> features;
  final ValueChanged<String> onFeatureTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderBand(
          icon: group.icon,
          accent: group.color,
          title: group.title,
          subtitle: group.description,
          trailing: _StatusPill(
            label: '${features.length} features',
            color: group.color,
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: '${group.title} Features',
          subtitle:
              'Available for ${role.label.toLowerCase()} access in this section',
        ),
        const SizedBox(height: 10),
        if (features.isEmpty)
          _EmptySectionPanel(group: group, role: role)
        else
          _FeatureLaunchGrid(features: features, onFeatureTap: onFeatureTap),
      ],
    );
  }
}

class _EmptySectionPanel extends StatelessWidget {
  const _EmptySectionPanel({required this.group, required this.role});

  final _NavigationGroup group;
  final PortalRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: group.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(group.icon, color: group.color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No ${group.title.toLowerCase()} features are enabled for ${role.label.toLowerCase()} access yet.',
              style: const TextStyle(color: Color(0xFF667085), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureDetailView extends StatelessWidget {
  const _FeatureDetailView({required this.feature});

  final StaticFeature feature;

  @override
  Widget build(BuildContext context) {
    final hasMetrics = feature.metrics.isNotEmpty;
    final hasRecords = feature.records.isNotEmpty;

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
        if (!hasMetrics && !hasRecords)
          EmptyStatePanel(
            title: 'No records yet',
            message:
                '${feature.title} has no matching local demo records for the current filter.',
            icon: feature.icon,
          )
        else if (hasMetrics)
          _MetricGrid(metrics: feature.metrics, accent: feature.accent),
        if (feature.actions.isNotEmpty) ...[
          const SizedBox(height: 18),
          _FeatureActionBar(feature: feature),
        ],
        if (hasRecords) ...[
          const SizedBox(height: 18),
          _FeatureRecordList(feature: feature),
        ],
      ],
    );
  }
}

class _FeatureActionBar extends StatelessWidget {
  const _FeatureActionBar({required this.feature});

  final StaticFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final action in feature.actions)
            FilledButton.icon(
              onPressed: () => _runAction(context, action),
              icon: Icon(_actionIcon(action)),
              label: Text(action),
              style: FilledButton.styleFrom(
                backgroundColor: feature.accent,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _runAction(BuildContext context, String action) async {
    if (action == 'Create forum post') {
      await _showForumPostForm(context);
      return;
    }
    if (action == 'Create support ticket') {
      await _showSupportTicketForm(context);
      return;
    }
    if (action == 'Reply to open ticket') {
      await _showSupportReplyForm(context);
      return;
    }
    if (action == 'Report latest post') {
      await _showReportForm(context);
      return;
    }
    if (action == 'Publish course notice') {
      await _showNoticeForm(context);
      return;
    }
    if (action == 'Create notice') {
      await _showNoticeForm(context);
      return;
    }
    if (action == 'Create event') {
      await _showEventForm(context);
      return;
    }
    if (action == 'Add Student') {
      await _showStudentForm(context);
      return;
    }
    if (action == 'Add Teacher') {
      await _showTeacherForm(context);
      return;
    }
    if (action == 'Add Administration Staff') {
      await _showAdministrationStaffForm(context);
      return;
    }
    if (action == 'Create student request') {
      await _showStudentRequestForm(context);
      return;
    }
    if (action == 'Report lost item') {
      await _showLostFoundForm(context, type: 'Lost');
      return;
    }
    if (action == 'Report found item') {
      await _showLostFoundForm(context, type: 'Found');
      return;
    }

    final needsConfirm =
        action == 'Reset Demo Data' || action == 'Hide reported content';
    if (needsConfirm) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(action),
            content: Text(
              action == 'Reset Demo Data'
                  ? 'Restore the original local demo seed? This removes changes made during this demo session.'
                  : 'Hide the first pending reported forum item in local demo state?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
      if (confirmed != true) {
        return;
      }
    }

    try {
      final message = DemoStore.instance.performFeatureAction(
        feature.title,
        action,
      );
      Get.snackbar(
        feature.title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
        backgroundColor: feature.accent,
        colorText: AppColors.white,
      );
    } on StateError catch (error) {
      Get.snackbar(
        feature.title,
        error.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
    } catch (error) {
      Get.snackbar(
        feature.title,
        'Unable to complete this local demo action.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
    }
  }

  Future<void> _showForumPostForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    var categoryId = store.forumCategories.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Discussion Post'),
              content: SizedBox(
                width: 520,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: categoryId,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: [
                            for (final category in store.forumCategories)
                              DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => categoryId = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 8) {
                              return 'Enter a clear title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: bodyController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 20) {
                              return 'Write at least 20 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }
                    store.createForumPost(
                      categoryId: categoryId,
                      title: titleController.text,
                      body: bodyController.text,
                    );
                    Navigator.of(dialogContext).pop();
                    _showSuccess('Discussion post created');
                  },
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _showSupportTicketForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    var category = 'Academic';
    var priority = 'Medium';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Support Ticket'),
              content: SizedBox(
                width: 520,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Academic',
                              child: Text('Academic'),
                            ),
                            DropdownMenuItem(
                              value: 'Finance',
                              child: Text('Finance'),
                            ),
                            DropdownMenuItem(
                              value: 'IT Support',
                              child: Text('IT Support'),
                            ),
                            DropdownMenuItem(
                              value: 'Student Affairs',
                              child: Text('Student Affairs'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => category = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Low', child: Text('Low')),
                            DropdownMenuItem(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem(
                              value: 'High',
                              child: Text('High'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => priority = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: subjectController,
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 6) {
                              return 'Enter a specific subject';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: descriptionController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 20) {
                              return 'Describe the issue clearly';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }
                    store.createSupportTicket(
                      category: category,
                      subject: subjectController.text,
                      priority: priority,
                      description: descriptionController.text,
                    );
                    Navigator.of(dialogContext).pop();
                    _showSuccess('Support ticket created');
                  },
                  icon: const Icon(Icons.support_agent_outlined),
                  label: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );

    subjectController.dispose();
    descriptionController.dispose();
  }

  Future<void> _showSupportReplyForm(BuildContext context) async {
    final controller = TextEditingController();
    await _showSingleTextForm(
      context: context,
      title: 'Reply To Ticket',
      label: 'Response',
      controller: controller,
      minLength: 12,
      onSubmit: () {
        DemoStore.instance.replyFirstOpenSupportTicket(
          message: controller.text,
        );
      },
      success: 'Support reply sent',
    );
    controller.dispose();
  }

  Future<void> _showReportForm(BuildContext context) async {
    final controller = TextEditingController();
    await _showSingleTextForm(
      context: context,
      title: 'Report Discussion',
      label: 'Reason',
      controller: controller,
      minLength: 10,
      onSubmit: () {
        DemoStore.instance.reportLatestForumPost(reason: controller.text);
      },
      success: 'Forum report created',
    );
    controller.dispose();
  }

  Future<void> _showNoticeForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final visibleSections = store.visibleSectionsForRole();
    var target = store.currentRole == PortalRole.teacher ? 'students' : 'all';
    String? sectionId = visibleSections.isEmpty
        ? null
        : visibleSections.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Publish Notice'),
              content: SizedBox(
                width: 520,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: target,
                          decoration: const InputDecoration(
                            labelText: 'Audience',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Students'),
                            ),
                            DropdownMenuItem(
                              value: 'teacher',
                              child: Text('Teachers'),
                            ),
                            DropdownMenuItem(
                              value: 'administration',
                              child: Text('Administration'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => target = value);
                            }
                          },
                        ),
                        if (visibleSections.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: sectionId,
                            decoration: const InputDecoration(
                              labelText: 'Course section',
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: '',
                                child: Text('No section target'),
                              ),
                              for (final section in visibleSections)
                                DropdownMenuItem(
                                  value: section.id,
                                  child: Text(
                                    '${store.subjectForSection(section.id).code} ${section.sectionCode}',
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                sectionId = value?.isEmpty == true
                                    ? null
                                    : value;
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 6) {
                              return 'Enter a notice title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: bodyController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.length < 20) {
                              return 'Write at least 20 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }
                    store.publishNotice(
                      title: titleController.text,
                      body: bodyController.text,
                      target: target,
                      sectionId: sectionId,
                    );
                    Navigator.of(dialogContext).pop();
                    _showSuccess('Notice published');
                  },
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('Publish'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _showEventForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final venueController = TextEditingController(text: 'Auditorium');
    final organizerController = TextEditingController(
      text: 'EUB Connect Office',
    );
    final timeController = TextEditingController(text: '10:30 AM');
    final capacityController = TextEditingController(text: '120');
    var audience = 'All';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Event'),
              content: SizedBox(
                width: 540,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: _minValidator(6),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            alignLabelWithHint: true,
                          ),
                          validator: _minValidator(20),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: venueController,
                          decoration: const InputDecoration(labelText: 'Venue'),
                          validator: _minValidator(3),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: organizerController,
                          decoration: const InputDecoration(
                            labelText: 'Organizer',
                          ),
                          validator: _minValidator(3),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: timeController,
                          decoration: const InputDecoration(labelText: 'Time'),
                          validator: _minValidator(4),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: capacityController,
                          decoration: const InputDecoration(
                            labelText: 'Capacity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final parsed = int.tryParse(value ?? '');
                            if (parsed == null || parsed < 1) {
                              return 'Enter a valid capacity';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: audience,
                          decoration: const InputDecoration(
                            labelText: 'Audience',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All')),
                            DropdownMenuItem(
                              value: 'Student',
                              child: Text('Students'),
                            ),
                            DropdownMenuItem(
                              value: 'Teacher',
                              child: Text('Teachers'),
                            ),
                            DropdownMenuItem(
                              value: 'Administration',
                              child: Text('Administration'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => audience = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) return;
                    store.createEventRecord(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: DateTime.now().add(const Duration(days: 10)),
                      time: timeController.text,
                      venue: venueController.text,
                      capacity: int.parse(capacityController.text),
                      organizer: organizerController.text,
                      audience: audience,
                    );
                    Navigator.of(dialogContext).pop();
                    _showSuccess('Event created');
                  },
                  icon: const Icon(Icons.event_outlined),
                  label: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    organizerController.dispose();
    timeController.dispose();
    capacityController.dispose();
  }

  Future<void> _showStudentForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController(text: '+88017');
    var departmentId = store.departments.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Student'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: _minValidator(3),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _minValidator(6),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: _minValidator(8),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: departmentId,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                      items: [
                        for (final department in store.departments)
                          DropdownMenuItem(
                            value: department.id,
                            child: Text(department.shortName),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => departmentId = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() != true) return;
                  store.addStudentAccount(
                    fullName: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    departmentId: departmentId,
                  );
                  Navigator.of(dialogContext).pop();
                  _showSuccess('Student added');
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Future<void> _showTeacherForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final designationController = TextEditingController(text: 'Lecturer');
    var departmentId = store.departments.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Teacher'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: _minValidator(3),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _minValidator(6),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: designationController,
                      decoration: const InputDecoration(
                        labelText: 'Designation',
                      ),
                      validator: _minValidator(3),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: departmentId,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                      items: [
                        for (final department in store.departments)
                          DropdownMenuItem(
                            value: department.id,
                            child: Text(department.shortName),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => departmentId = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() != true) return;
                  store.addTeacherAccount(
                    fullName: nameController.text,
                    email: emailController.text,
                    designation: designationController.text,
                    departmentId: departmentId,
                  );
                  Navigator.of(dialogContext).pop();
                  _showSuccess('Teacher added');
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    designationController.dispose();
  }

  Future<void> _showAdministrationStaffForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final designationController = TextEditingController(text: 'Office Officer');
    var officeId = store.offices.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Administration Staff'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: _minValidator(3),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _minValidator(6),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: designationController,
                      decoration: const InputDecoration(
                        labelText: 'Designation',
                      ),
                      validator: _minValidator(3),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: officeId,
                      decoration: const InputDecoration(labelText: 'Office'),
                      items: [
                        for (final office in store.offices)
                          DropdownMenuItem(
                            value: office.id,
                            child: Text(office.shortName),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => officeId = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() != true) return;
                  store.addAdministrationStaff(
                    fullName: nameController.text,
                    email: emailController.text,
                    designation: designationController.text,
                    officeId: officeId,
                  );
                  Navigator.of(dialogContext).pop();
                  _showSuccess('Administration staff added');
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    designationController.dispose();
  }

  Future<void> _showStudentRequestForm(BuildContext context) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final notesController = TextEditingController();
    var type = 'Transcript';
    var priority = 'Normal';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Create Student Request'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Transcript',
                          child: Text('Transcript'),
                        ),
                        DropdownMenuItem(
                          value: 'Provisional Certificate',
                          child: Text('Provisional Certificate'),
                        ),
                        DropdownMenuItem(
                          value: 'Course registration issue',
                          child: Text('Course registration issue'),
                        ),
                        DropdownMenuItem(
                          value: 'Payment correction',
                          child: Text('Payment correction'),
                        ),
                        DropdownMenuItem(
                          value: 'Result correction',
                          child: Text('Result correction'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => type = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(
                          value: 'Urgent',
                          child: Text('Urgent'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => priority = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: notesController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        alignLabelWithHint: true,
                      ),
                      validator: _minValidator(12),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() != true) return;
                  store.createStudentRequest(
                    type: type,
                    notes: notesController.text,
                    priority: priority,
                  );
                  Navigator.of(dialogContext).pop();
                  _showSuccess('Student request created');
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
    notesController.dispose();
  }

  Future<void> _showLostFoundForm(
    BuildContext context, {
    required String type,
  }) async {
    final store = DemoStore.instance;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Report $type Item'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Item'),
                  validator: _minValidator(4),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: _minValidator(3),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                  validator: _minValidator(12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              store.reportLostFoundItem(
                type: type,
                title: titleController.text,
                description: descriptionController.text,
                location: locationController.text,
              );
              Navigator.of(dialogContext).pop();
              _showSuccess('$type item reported');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
  }

  FormFieldValidator<String> _minValidator(int minLength) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.length < minLength) {
        return 'Enter at least $minLength characters';
      }
      return null;
    };
  }

  Future<void> _showSingleTextForm({
    required BuildContext context,
    required String title,
    required String label,
    required TextEditingController controller,
    required int minLength,
    required VoidCallback onSubmit,
    required String success,
  }) {
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: label,
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < minLength) {
                    return 'Please enter at least $minLength characters';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) {
                  return;
                }
                onSubmit();
                Navigator.of(dialogContext).pop();
                _showSuccess(success);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      feature.title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(14),
      backgroundColor: feature.accent,
      colorText: AppColors.white,
    );
  }

  IconData _actionIcon(String action) {
    if (action.contains('Reset')) return Icons.restart_alt_outlined;
    if (action.contains('payment')) return Icons.payments_outlined;
    if (action.contains('event') || action.contains('Register')) {
      return Icons.event_available_outlined;
    }
    if (action.contains('club') || action.contains('Join')) {
      return Icons.groups_outlined;
    }
    if (action.contains('support') || action.contains('ticket')) {
      return Icons.support_agent_outlined;
    }
    if (action.contains('Student')) return Icons.person_add_alt_outlined;
    if (action.contains('Teacher')) return Icons.co_present_outlined;
    if (action.contains('Administration')) return Icons.badge_outlined;
    if (action.contains('course')) return Icons.menu_book_outlined;
    if (action.contains('section')) return Icons.class_outlined;
    if (action.contains('request')) return Icons.request_page_outlined;
    if (action.contains('result')) return Icons.publish_outlined;
    if (action.contains('lost') || action.contains('found')) {
      return Icons.search_outlined;
    }
    if (action.contains('forum') || action.contains('post')) {
      return Icons.forum_outlined;
    }
    if (action.contains('Approve')) return Icons.verified_outlined;
    if (action.contains('attendance')) return Icons.how_to_reg_outlined;
    if (action.contains('notice')) return Icons.campaign_outlined;
    if (action.contains('notifications')) return Icons.notifications_outlined;
    return Icons.check_circle_outline;
  }
}

class _FeatureRecordList extends StatefulWidget {
  const _FeatureRecordList({required this.feature});

  final StaticFeature feature;

  @override
  State<_FeatureRecordList> createState() => _FeatureRecordListState();
}

class _FeatureRecordListState extends State<_FeatureRecordList> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';
  String _status = 'All';
  String _sort = 'Title';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  List<StaticRecord> get _filteredRecords {
    final normalizedQuery = _query.trim().toLowerCase();
    final records = widget.feature.records.where((record) {
      final queryMatch =
          normalizedQuery.isEmpty ||
          record.title.toLowerCase().contains(normalizedQuery) ||
          record.subtitle.toLowerCase().contains(normalizedQuery) ||
          record.meta.toLowerCase().contains(normalizedQuery) ||
          record.status.toLowerCase().contains(normalizedQuery) ||
          record.details.values.any(
            (value) => value.toLowerCase().contains(normalizedQuery),
          );
      final statusMatch = _status == 'All' || record.status == _status;
      return queryMatch && statusMatch;
    }).toList();
    records.sort((a, b) {
      switch (_sort) {
        case 'Status':
          return a.status.compareTo(b.status);
        case 'Meta':
          return a.meta.compareTo(b.meta);
        case 'Title':
        default:
          return a.title.compareTo(b.title);
      }
    });
    return records;
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final statuses = {
      'All',
      ...widget.feature.records
          .map((record) => record.status)
          .where((status) => status.trim().isNotEmpty),
    }.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: widget.feature.title,
            subtitle:
                '${records.length} of ${widget.feature.records.length} calculated demo records',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final searchControl = TextField(
                controller: _queryController,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search records',
                  prefixIcon: Icon(Icons.search),
                ),
              );
              final controls = [
                if (compact)
                  searchControl
                else
                  Expanded(flex: 2, child: searchControl),
                SizedBox(
                  width: compact ? double.infinity : 210,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final status in statuses)
                        DropdownMenuItem(value: status, child: Text(status)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _status = value);
                    },
                  ),
                ),
                SizedBox(
                  width: compact ? double.infinity : 180,
                  child: DropdownButtonFormField<String>(
                    initialValue: _sort,
                    decoration: const InputDecoration(labelText: 'Sort'),
                    items: const [
                      DropdownMenuItem(value: 'Title', child: Text('Title')),
                      DropdownMenuItem(value: 'Status', child: Text('Status')),
                      DropdownMenuItem(value: 'Meta', child: Text('Meta')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _sort = value);
                    },
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _queryController.clear();
                    setState(() {
                      _query = '';
                      _status = 'All';
                      _sort = 'Title';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ];
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final control in controls) ...[
                      control,
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < controls.length; index++) ...[
                    controls[index],
                    if (index != controls.length - 1) const SizedBox(width: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            EmptyStatePanel(
              title: 'No matching records',
              message: 'Clear filters or search another term.',
              icon: widget.feature.icon,
            ),
          for (final record in records) ...[
            _FeatureRecordTile(
              record: record,
              accent: widget.feature.accent,
              onTap: () => _showRecordDetails(context, record),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  void _showRecordDetails(BuildContext context, StaticRecord record) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _RecordDetailDialog(
          record: record,
          accent: widget.feature.accent,
        );
      },
    );
  }
}

class _FeatureRecordTile extends StatelessWidget {
  const _FeatureRecordTile({
    required this.record,
    required this.accent,
    this.onTap,
  });

  final StaticRecord record;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE3E6EA)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(record.icon, color: accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _StatusPill(label: record.meta, color: accent),
                        _StatusPill(
                          label: record.status,
                          color: const Color(0xFF475467),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordDetailDialog extends StatelessWidget {
  const _RecordDetailDialog({required this.record, required this.accent});

  final StaticRecord record;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final details = record.details.isEmpty
        ? {
            'Title': record.title,
            'Summary': record.subtitle,
            'Meta': record.meta,
            'Status': record.status,
          }
        : record.details;

    return AlertDialog(
      title: Text(record.title),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                record.subtitle,
                style: const TextStyle(color: Color(0xFF667085), height: 1.4),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusPill(label: record.meta, color: accent),
                  _StatusPill(
                    label: record.status,
                    color: const Color(0xFF475467),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final entry in details.entries) ...[
                Text(
                  entry.key,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  entry.value.isEmpty ? '-' : entry.value,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
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
        final textScale = _dashboardTextScale(context);
        final spacing = constraints.maxWidth < 360 ? 10.0 : 12.0;
        final tileExtent = (88.0 + (74.0 * textScale))
            .clamp(162.0, 320.0)
            .toDouble();
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
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: tileExtent,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 320;
        final padding = isCompact ? 14.0 : 16.0;
        final iconBoxSize = isCompact ? 36.0 : 38.0;
        final valueFontSize = isCompact ? 23.0 : 25.0;

        return Container(
          padding: EdgeInsets.all(padding),
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
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(metric.icon, color: accent, size: 21),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_horiz,
                    color: Color(0xFF98A2B3),
                    size: 20,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                metric.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
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
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                metric.note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
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
        final textScale = _dashboardTextScale(context);
        final spacing = constraints.maxWidth < 360 ? 10.0 : 12.0;
        final tileExtent = (82.0 + (38.0 * textScale))
            .clamp(118.0, 240.0)
            .toDouble();
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
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: tileExtent,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => onFeatureTap(feature.title),
                borderRadius: BorderRadius.circular(8),
                child: LayoutBuilder(
                  builder: (context, tileConstraints) {
                    final isCompact = tileConstraints.maxWidth < 260;
                    final padding = isCompact ? 12.0 : 14.0;
                    final iconBoxSize = isCompact ? 34.0 : 36.0;

                    return Container(
                      padding: EdgeInsets.all(padding),
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
                                width: iconBoxSize,
                                height: iconBoxSize,
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
                    );
                  },
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

  final AppAccount account;

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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

class _NavigationSegmentBar extends StatelessWidget {
  const _NavigationSegmentBar({
    required this.groups,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavigationGroup> groups;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final group = groups[index];
          return _NavigationSegmentChip(
            group: group,
            selected: index == selectedIndex,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _NavigationSegmentChip extends StatelessWidget {
  const _NavigationSegmentChip({
    required this.group,
    required this.selected,
    required this.onTap,
  });

  final _NavigationGroup group;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.white : group.color;
    final background = selected ? group.color : const Color(0xFFF8FAFC);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? group.color : const Color(0xFFE3E6EA),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(group.icon, color: foreground, size: 18),
              const SizedBox(width: 7),
              Text(
                group.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationGroupHeader extends StatelessWidget {
  const _NavigationGroupHeader({required this.group});

  final _NavigationGroup group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: group.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(group.icon, color: group.color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                group.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
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
      constraints: const BoxConstraints(maxWidth: 260),
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

class _NavigationGroup {
  const _NavigationGroup({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.featureTitles,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> featureTitles;
}

List<_NavigationGroup> _navigationGroupsForRole(PortalRole role) {
  switch (role) {
    case PortalRole.student:
      return const [
        _NavigationGroup(
          title: 'Study',
          description: 'Portal, classes, courses, tasks, marks',
          icon: Icons.school_outlined,
          color: Color(0xFF2A2D7E),
          featureTitles: [
            'Student Portal',
            'Departments',
            'Academic Calendar',
            'Routine Management',
            'Class Routine',
            'Semester Courses',
            'Assignments',
            'Attendance',
            'Quiz System',
            'Results',
          ],
        ),
        _NavigationGroup(
          title: 'Finance',
          description: 'Fees, receipts, scholarships',
          icon: Icons.account_balance_wallet_outlined,
          color: Color(0xFFCA8A04),
          featureTitles: ['Tuition Fees', 'Payment History', 'Scholarships'],
        ),
        _NavigationGroup(
          title: 'Campus',
          description: 'Events, notices, support',
          icon: Icons.campaign_outlined,
          color: Color(0xFF007F3D),
          featureTitles: [
            'Events',
            'Notice Board',
            'Student Support',
            'Lost and Found',
          ],
        ),
        _NavigationGroup(
          title: 'Connect',
          description: 'Clubs and discussions',
          icon: Icons.groups_2_outlined,
          color: Color(0xFF0D9488),
          featureTitles: ['Community Forum', 'Discussion Board'],
        ),
        _NavigationGroup(
          title: 'Account',
          description: 'Profile and preferences',
          icon: Icons.account_circle_outlined,
          color: Color(0xFF475569),
          featureTitles: [
            'Authentication',
            'Profile',
            'Notifications',
            'Settings',
          ],
        ),
      ];
    case PortalRole.teacher:
      return const [
        _NavigationGroup(
          title: 'Teaching',
          description: 'Courses, attendance, marks',
          icon: Icons.co_present_outlined,
          color: Color(0xFF8B5E00),
          featureTitles: [
            'Teacher Portal',
            'Semester Courses',
            'Assignments',
            'Attendance',
            'Lecture Materials',
            'Student Notices',
            'Quiz System',
            'Results',
            'Marks Result',
            'Academic Report',
          ],
        ),
        _NavigationGroup(
          title: 'Academic',
          description: 'Departments, calendar, routine',
          icon: Icons.calendar_month_outlined,
          color: Color(0xFF2A2D7E),
          featureTitles: [
            'Departments',
            'Academic Calendar',
            'Routine Management',
          ],
        ),
        _NavigationGroup(
          title: 'Finance',
          description: 'Receipts and payment history',
          icon: Icons.account_balance_wallet_outlined,
          color: Color(0xFFCA8A04),
          featureTitles: ['Payment History'],
        ),
        _NavigationGroup(
          title: 'Campus',
          description: 'Events, notices, support',
          icon: Icons.campaign_outlined,
          color: Color(0xFF007F3D),
          featureTitles: [
            'Events',
            'Notice Board',
            'Lost and Found',
            'Student Support',
          ],
        ),
        _NavigationGroup(
          title: 'Connect',
          description: 'Clubs and discussions',
          icon: Icons.groups_2_outlined,
          color: Color(0xFF0D9488),
          featureTitles: ['Community Forum', 'Discussion Board'],
        ),
        _NavigationGroup(
          title: 'Account',
          description: 'Profile and preferences',
          icon: Icons.account_circle_outlined,
          color: Color(0xFF475569),
          featureTitles: [
            'Authentication',
            'Profile',
            'Notifications',
            'Settings',
          ],
        ),
      ];
    case PortalRole.administration:
      return const [
        _NavigationGroup(
          title: 'Office',
          description: 'Dashboard and assigned office work',
          icon: Icons.business_center_outlined,
          color: Color(0xFF0F766E),
          featureTitles: [
            'Administration Portal',
            'Student Requests',
            'Support Tickets',
            'Notice Board',
          ],
        ),
        _NavigationGroup(
          title: 'Academic',
          description: 'Departments, programs, courses',
          icon: Icons.calendar_month_outlined,
          color: Color(0xFF2A2D7E),
          featureTitles: [
            'Departments',
            'Department Management',
            'Programs',
            'Courses',
            'Sections',
            'Academic Calendar',
            'Routine Management',
            'Examinations',
          ],
        ),
        _NavigationGroup(
          title: 'Finance',
          description: 'Invoices, payments, waivers',
          icon: Icons.account_balance_wallet_outlined,
          color: Color(0xFFCA8A04),
          featureTitles: [
            'Invoices',
            'Payments',
            'Scholarships/Waivers',
            'Payment History',
          ],
        ),
        _NavigationGroup(
          title: 'Admissions',
          description: 'Applicants and registration progress',
          icon: Icons.how_to_reg_outlined,
          color: Color(0xFF0F766E),
          featureTitles: ['Admissions', 'Student Management'],
        ),
        _NavigationGroup(
          title: 'Campus',
          description: 'Events, notices, support',
          icon: Icons.campaign_outlined,
          color: Color(0xFF007F3D),
          featureTitles: [
            'Events',
            'Notice Board',
            'Lost and Found',
            'Student Support',
            'Complaints/Cases',
          ],
        ),
        _NavigationGroup(
          title: 'Connect',
          description: 'Clubs and discussions',
          icon: Icons.groups_2_outlined,
          color: Color(0xFF0D9488),
          featureTitles: ['Community Forum', 'Discussion Board'],
        ),
        _NavigationGroup(
          title: 'Account',
          description: 'Profile and preferences',
          icon: Icons.account_circle_outlined,
          color: Color(0xFF475569),
          featureTitles: [
            'Authentication',
            'Profile',
            'Notifications',
            'Settings',
          ],
        ),
      ];
    case PortalRole.admin:
      return const [
        _NavigationGroup(
          title: 'Dashboard',
          description: 'University command center',
          icon: Icons.admin_panel_settings_outlined,
          color: Color(0xFFB42318),
          featureTitles: [
            'Admin Dashboard',
            'Student Requests',
            'Support Tickets',
            'Activity Log',
          ],
        ),
        _NavigationGroup(
          title: 'Academic',
          description: 'Departments, programs, courses',
          icon: Icons.account_tree_outlined,
          color: Color(0xFF2A2D7E),
          featureTitles: [
            'Departments',
            'Department Management',
            'Programs',
            'Courses',
            'Sections',
            'Academic Calendar',
            'Routine Management',
            'Semester Courses',
            'Assignments',
            'Attendance',
            'Quiz System',
            'Results',
            'Examinations',
          ],
        ),
        _NavigationGroup(
          title: 'People',
          description: 'Students, teachers, offices',
          icon: Icons.groups_outlined,
          color: Color(0xFF0F766E),
          featureTitles: [
            'Student Management',
            'Teacher Management',
            'Administration Staff',
            'User Roles',
          ],
        ),
        _NavigationGroup(
          title: 'Operations',
          description: 'Admissions, exams, requests',
          icon: Icons.fact_check_outlined,
          color: Color(0xFF7C3AED),
          featureTitles: [
            'Admissions',
            'Examinations',
            'Student Requests',
            'Attendance',
          ],
        ),
        _NavigationGroup(
          title: 'Finance',
          description: 'Fees, receipts, scholarships',
          icon: Icons.account_balance_wallet_outlined,
          color: Color(0xFFCA8A04),
          featureTitles: [
            'Invoices',
            'Payments',
            'Scholarships/Waivers',
            'Tuition Fees',
            'Payment History',
            'Scholarships',
          ],
        ),
        _NavigationGroup(
          title: 'Campus',
          description: 'Events, notices, support',
          icon: Icons.campaign_outlined,
          color: Color(0xFF007F3D),
          featureTitles: [
            'Events',
            'Notice Board',
            'Lost and Found',
            'Student Support',
            'Complaints/Cases',
          ],
        ),
        _NavigationGroup(
          title: 'Engagement',
          description: 'Clubs, community, moderation',
          icon: Icons.groups_2_outlined,
          color: Color(0xFF0D9488),
          featureTitles: [
            'Community Forum',
            'Discussion Board',
            'Clubs',
            'Community Moderation',
          ],
        ),
        _NavigationGroup(
          title: 'System',
          description: 'Audit, settings, reset',
          icon: Icons.settings_outlined,
          color: Color(0xFF475569),
          featureTitles: [
            'Activity Log',
            'System Activity',
            'Notifications',
            'Settings',
            'Authentication',
          ],
        ),
        _NavigationGroup(
          title: 'Account',
          description: 'Profile and alerts',
          icon: Icons.account_circle_outlined,
          color: Color(0xFF475569),
          featureTitles: ['Profile', 'Notifications'],
        ),
      ];
  }
}

List<MapEntry<int, StaticFeature>> _navigationEntriesForRole(PortalRole role) {
  return staticFeatures.asMap().entries.where((entry) {
    return entry.value.access.contains(role);
  }).toList();
}

List<MapEntry<int, StaticFeature>> _navigationEntriesForGroups(
  List<_NavigationGroup> groups,
  PortalRole role,
) {
  final entries = <MapEntry<int, StaticFeature>>[];

  for (final group in groups) {
    for (final entry in _navigationEntriesForGroup(group, role)) {
      if (entries.every((item) => item.key != entry.key)) {
        entries.add(entry);
      }
    }
  }

  return entries;
}

List<MapEntry<int, StaticFeature>> _navigationEntriesForGroup(
  _NavigationGroup group,
  PortalRole role,
) {
  final entries = <MapEntry<int, StaticFeature>>[];

  for (final title in group.featureTitles) {
    final index = staticFeatures.indexWhere((feature) {
      return feature.title == title && feature.access.contains(role);
    });
    if (index != -1 && entries.every((entry) => entry.key != index)) {
      entries.add(MapEntry(index, staticFeatures[index]));
    }
  }

  return entries;
}

int _safeNavigationGroupIndex(int index, int length) {
  if (length <= 0 || index < 0) {
    return 0;
  }
  if (index >= length) {
    return length - 1;
  }
  return index;
}
