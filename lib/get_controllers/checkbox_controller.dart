

import 'package:get/get.dart';

class CheckboxController extends GetxController {
  RxMap<int, Map<int, dynamic>> checkboxValue = <int, Map<int, dynamic>>{}.obs;
  RxList<bool?> checkBoxVisible = <bool?>[].obs;

  initCheckboxValue(int id , Map<int , dynamic> value)
  {
    checkboxValue[id] = value;
  }

  setCheckBoxValue(int id, int i , bool? v)
  {
    Map<int , dynamic> x = checkboxValue[id]!;
    x[i] = v;
    checkboxValue[id] = x;
  }
}
