import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test2/app_screens/fetch_location.dart';
import 'package:test2/app_screens/home.dart';
import 'package:test2/get_controllers/selected_file_controller.dart';
import 'package:test2/get_controllers/ui_model_controller.dart';
import 'package:test2/utilities/common_widgets.dart';

class PickFile extends StatefulWidget {
  const PickFile({Key? key}) : super(key: key);

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  SelectedFileController selectedFileController =
      Get.find<SelectedFileController>();
  UIModelController uiModelController = Get.find<UIModelController>();

  pickFile({isDefault = false}) async {
    if (!isDefault) {
      try {
        FilePickerResult? filePickerResult =
            await FilePicker.platform.pickFiles(allowMultiple: false);

        if (filePickerResult != null) {
          File file = File(filePickerResult.paths.first!);
          String f = file.readAsStringSync();
          selectedFileController.setJson(f);
          Map<String, dynamic> map =
              jsonDecode(selectedFileController.selectedJson.value);
          uiModelController.setUiModel(map);
          if (!mounted) return;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UserForm()));
        } else {
          CommonWidgets.showToast("Please pick a file !");
        }
      } catch (e) {
        CommonWidgets.showToast("Error ! ${e.toString()}");
      }
    } else {
      try {
        String x = await rootBundle.loadString("assets/form.txt");
        selectedFileController.setJson(x);
        Map<String, dynamic> map =
            jsonDecode(selectedFileController.selectedJson.value);
        uiModelController.setUiModel(map);
        if (!mounted) return;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserForm()));
      } catch (e) {
        log(e.toString());
        CommonWidgets.showToast("Error !");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  pickFile();
                },
                child: const Text("Browse")),
            const Text("or"),
            ElevatedButton(
                onPressed: () {
                  pickFile(isDefault: true);
                },
                child: const Text("Proceed with default")),
          ],
        ),
      ),
    );
  }
}
