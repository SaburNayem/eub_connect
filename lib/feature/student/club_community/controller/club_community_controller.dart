import 'package:eub_connect/feature/student/club_community/model/club_community_model.dart';
import 'package:get/get.dart';

class ClubCommunityController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const ClubCommunityModel().obs;
}
