import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';

class CommonWidgets
{
   static showToast(String content)
   {
     Fluttertoast.showToast(msg: content);
   }

   initControllers()
   {
     Get.lazyPut(() => RadioController());
     Get.lazyPut(() => CheckboxController());
   }
}