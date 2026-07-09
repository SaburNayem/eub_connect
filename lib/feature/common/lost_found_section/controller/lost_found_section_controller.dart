import 'package:eub_connect/feature/common/lost_found_section/model/lost_found_section_model.dart';
import 'package:get/get.dart';

class LostFoundSectionController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const LostFoundSectionModel().obs;
}
