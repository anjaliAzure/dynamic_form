import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test2/utilities/common_widgets.dart';

class HiveHelper {
  initHive() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);

      clear();
    } catch (e) {
      CommonWidgets.showToast("Failed initialising database!");
    }
  }

  insert(Map<int, dynamic> value) async {
    try {
      Box box = await Hive.openBox("test_1");
      box.add(value);
    } catch (e) {
      CommonWidgets.showToast("Failed inserting values!");
    }
  }

  read({required bool isWrite}) async {
    try {
      final directory = await getTemporaryDirectory();
      Box box = await Hive.openBox("test_1");
      for (int i = 0; i < box.length; i++) {
        CommonWidgets.printLog(
            "=========================\n${box.getAt(i).toString()}\n");
        if (isWrite) {
          await File("/storage/emulated/0/Download/form_data.txt")
              .writeAsString(
                  "=========================\n${box.getAt(i).toString()}\n",
                  mode: FileMode.append);
        }
      }
      CommonWidgets.printLog(
          "////////////////////////////////////////////////////////////////////////////////");
      CommonWidgets.printLog(
          "${File("${directory.path}/form_data.txt").open(mode: FileMode.read).toString()}");
    } catch (e) {
      CommonWidgets.showToast("Failed reading values!");
    }
  }

  update(int index, dynamic value) async {
    try {
      Box box = await Hive.openBox("test_1");

      box.putAt(index, value);
    } catch (e) {
      CommonWidgets.showToast("Failed updating values!");
    }
  }

  delete(int index) async {
    try {
      Box box = await Hive.openBox("test_1");

      box.deleteAt(index);
    } catch (e) {
      CommonWidgets.showToast("Failed deleting values!");
    }
  }

  clear() async {
    try {
      Box box = await Hive.openBox("test_1");

      box.clear();
    } catch (e) {
      CommonWidgets.showToast("Failed deleting values!");
    }
  }
}
