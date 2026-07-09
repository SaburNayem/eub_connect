import 'package:eub_connect/feature/home/model/static_feature.dart';

class RegistrationModel {
  const RegistrationModel({
    required this.userId,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.emailAddress,
    required this.role,
    this.photoPath,
  });

  final String userId;
  final String fullName;
  final String password;
  final String phoneNumber;
  final String emailAddress;
  final PortalRole role;
  final String? photoPath;
}
