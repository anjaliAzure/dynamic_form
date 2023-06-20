import 'package:get/get.dart';
import 'package:test2/models/ui_model.dart';

class UIModelController extends GetxController {
  Rx<UiModel?> uiModel = Rxn<UiModel>();

  setUiModel(Map<String, dynamic> jsonTxt) {
    uiModel.value = UiModel.fromJson(jsonTxt);
  }
}
