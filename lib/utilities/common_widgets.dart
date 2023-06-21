
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidgets {

  static showToast(String content) {
    Fluttertoast.showToast(msg: content);
  }

  static printLog(dynamic value)
  {
    log(value.toString());
  }

}
