import 'package:get/get.dart';

class DropDownController extends GetxController {
  RxMap<int, Map<int, dynamic>> dropDownValue = <int, Map<int, dynamic>>{}.obs;
  RxList<bool?> dropDownVisible = <bool?>[].obs;
}
