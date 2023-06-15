import 'package:get/get.dart';

class DropDownController extends GetxController {
  RxMap<int, Map<int, dynamic>> dropDownValue = <int, Map<int, dynamic>>{}.obs;
  RxMap<int, bool?> dropDownVisible = <int, bool?>{}.obs;

  setDropdownValue(int id, Map<int, dynamic> value) {
    dropDownValue[id] = value;
  }

  setDropDownVisible(int id, bool? value) {
    dropDownVisible[id] = value;
  }
}
