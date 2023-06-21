
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidgets {

  static showToast(String content) {
    Fluttertoast.showToast(msg: content, toastLength: Toast.LENGTH_LONG);
  }

  static printLog(dynamic value)
  {
    log(value.toString());
  }

}
