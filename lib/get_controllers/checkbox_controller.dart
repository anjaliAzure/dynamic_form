import 'package:get/get.dart';

class CheckboxController extends GetxController {
  RxMap<int, Map<int, dynamic>> checkboxValue = <int, Map<int, dynamic>>{}.obs;
  RxList<bool?> checkBoxVisible = <bool?>[].obs;
}
