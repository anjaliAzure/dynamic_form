import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';

import '../get_controllers/drop_down_controller.dart';
import '../get_controllers/image_controller.dart';
import '../get_controllers/text_controller.dart';

class CommonWidgets {
  static showToast(String content) {
    Fluttertoast.showToast(msg: content);
  }

  initControllers() {
    Get.lazyPut(() => RadioController());
    Get.lazyPut(() => CheckboxController());
    Get.lazyPut(() => DropDownController());
    Get.lazyPut(() => ImageController());
    Get.lazyPut(() => TextController());
  }
}
