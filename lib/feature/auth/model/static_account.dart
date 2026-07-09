import 'package:eub_connect/feature/home/model/static_feature.dart';

const staticDemoPassword = '123456';

class StaticAccount {
  const StaticAccount({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.department,
  });

  final String id;
  final String fullName;
  final String email;
  final String password;
  final PortalRole role;
  final String department;
}

const staticAccounts = [
  StaticAccount(
    id: 'STU-2026-001',
    fullName: 'Nadia Rahman',
    email: 'student@eub.edu',
    password: staticDemoPassword,
    role: PortalRole.student,
    department: 'CSE, Batch 2026',
  ),
  StaticAccount(
    id: 'TCH-204',
    fullName: 'Dr. Farhan Karim',
    email: 'teacher@eub.edu',
    password: staticDemoPassword,
    role: PortalRole.teacher,
    department: 'Computer Science and Engineering',
  ),
  StaticAccount(
    id: 'FAC-018',
    fullName: 'Prof. Nusrat Jahan',
    email: 'faculty@eub.edu',
    password: staticDemoPassword,
    role: PortalRole.faculty,
    department: 'Faculty of Science and Engineering',
  ),
  StaticAccount(
    id: 'ADM-001',
    fullName: 'System Admin',
    email: 'admin@eub.edu',
    password: staticDemoPassword,
    role: PortalRole.admin,
    department: 'Registrar and ICT Office',
  ),
];

StaticAccount? findStaticAccount({
  required String email,
  required String password,
}) {
  final normalizedEmail = email.trim().toLowerCase();

  for (final account in staticAccounts) {
    if (account.email.toLowerCase() == normalizedEmail &&
        account.password == password) {
      return account;
    }
  }

  return null;
}
