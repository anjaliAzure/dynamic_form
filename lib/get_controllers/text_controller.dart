import 'package:get/get.dart';

class TextController extends GetxController {
  RxMap<int, dynamic> editTextList = <int, dynamic>{}.obs;

  setEditTextList(int id, dynamic value) {
    editTextList[id] = value;
  }
}
