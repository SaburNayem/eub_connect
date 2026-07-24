import 'package:eub_connect/feature/home/model/static_feature.dart';

class AppAccount {
  const AppAccount({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.universityId,
    this.department,
    this.phone,
    this.profilePhotoPath,
  });

  factory AppAccount.fromProfile({
    required Map<String, dynamic> profile,
    required PortalRole role,
  }) {
    return AppAccount(
      id: profile['id'] as String,
      fullName: (profile['full_name'] as String?) ?? 'EUB User',
      email: (profile['email'] as String?) ?? '',
      role: role,
      universityId: profile['university_id'] as String?,
      department: profile['department_name'] as String?,
      phone: profile['phone'] as String?,
      profilePhotoPath: profile['profile_photo_path'] as String?,
    );
  }

  static const guest = AppAccount(
    id: 'guest',
    fullName: 'Not signed in',
    email: '',
    role: PortalRole.student,
    department: 'Backend not connected',
  );

  final String id;
  final String fullName;
  final String email;
  final PortalRole role;
  final String? universityId;
  final String? department;
  final String? phone;
  final String? profilePhotoPath;
}

PortalRole portalRoleFromCode(String? code) {
  switch ((code ?? '').toLowerCase()) {
    case 'teacher':
      return PortalRole.teacher;
    case 'faculty':
      return PortalRole.faculty;
    case 'admin':
      return PortalRole.admin;
    case 'student':
    default:
      return PortalRole.student;
  }
}
