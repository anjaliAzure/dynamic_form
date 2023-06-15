import 'package:get/get.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/dropdown_controller.dart';
import 'package:test2/get_controllers/image_controller.dart';
import 'package:test2/get_controllers/page_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';
import 'package:test2/get_controllers/selected_file_controller.dart';
import 'package:test2/get_controllers/text_controller.dart';
import 'package:test2/get_controllers/ui_model_controller.dart';

class AppBinding extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => RadioController());
    Get.lazyPut(() => CheckboxController());
    Get.lazyPut(() => DropDownController());
    Get.lazyPut(() => ImageController());
    Get.lazyPut(() => TextController());
    Get.lazyPut(() => CurrentPageController());
    Get.lazyPut(() => SelectedFileController());
    Get.lazyPut(() => UIModelController());
  }
}