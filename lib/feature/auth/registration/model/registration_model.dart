class RegistrationModel {
  const RegistrationModel({
    required this.studentId,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.emailAddress,
    this.photoPath,
  });

  final String studentId;
  final String fullName;
  final String password;
  final String phoneNumber;
  final String emailAddress;
  final String? photoPath;
}
