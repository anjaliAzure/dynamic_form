import 'package:get/get.dart';

class SelectedFileController extends GetxController{
  RxString selectedJson = "".obs;

  setJson(String s)
  {
    selectedJson.value = s;
  }
}