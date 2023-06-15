import 'package:get/get.dart';

class CheckboxController extends GetxController {
  RxMap<int, Map<int, dynamic>> checkboxValue = <int, Map<int, dynamic>>{}.obs;
  RxMap<int, bool?> checkBoxVisible = <int, bool?>{}.obs;

  initCheckboxValue(int id, Map<int, dynamic> value) {
    checkboxValue[id] = value;
  }

  setCheckBoxValue(int id, int i, bool? value) {
    Map<int, dynamic> temp = checkboxValue[id]!;
    temp[i] = value;
    checkboxValue[id] = temp;
  }

  setCheckBoxVisible(int id, bool? value) {
    checkBoxVisible[id] = value;
  }
}
