import 'package:eub_connect/feature/common/notice/model/notice_model.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const NoticeModel().obs;
}
