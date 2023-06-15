import 'package:get/get.dart';

class RadioController extends GetxController {

  RxMap<int, Map<int, String>> radioValue = <int, Map<int, String>>{}.obs;
  RxList<bool?> radioVisible = <bool?>[].obs;

  setRadioValue(int id , Map<int , String> value)
  {
    radioValue[id] = value;
  }

  setRadioVisible()
  {

  }
}
