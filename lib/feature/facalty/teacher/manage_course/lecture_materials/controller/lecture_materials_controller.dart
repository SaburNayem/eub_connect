import 'package:eub_connect/feature/facalty/teacher/manage_course/lecture_materials/model/lecture_materials_model.dart';
import 'package:get/get.dart';

class LectureMaterialsController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const LectureMaterialsModel().obs;
}
