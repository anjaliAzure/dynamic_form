import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:test2/app_constants/constants.dart';
import 'package:test2/get_controllers/page_controller.dart';
import 'package:test2/get_controllers/selected_file_controller.dart';
import 'package:test2/get_controllers/ui_model_controller.dart';
import 'package:test2/models/ui_model.dart';
import 'package:test2/utilities/common_widgets.dart';
import 'package:test2/utilities/utility_widgets.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  String? responseTxt;

  final _formKey = GlobalKey<FormState>();

  CurrentPageController pageController = Get.find<CurrentPageController>();
  SelectedFileController selectedFileController = Get.find<SelectedFileController>();
  UIModelController uiModelController = Get.find<UIModelController>();

  Widget buildPages() {
    return  Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uiModelController.uiModel.value?.fields!.first.page!
                .elementAt(pageController.currentPage.value)
                .lists!
                .length,
            itemBuilder: (context, i) {
              /// i represents index of the list
              switch (uiModelController.uiModel.value?.fields!.first.page!
                  .elementAt(pageController.currentPage.value)
                  .lists!
                  .elementAt(i)
                  .type) {
                case Constants.text:
                  return UtilityWidgets().buildShortText(
                      pageController.currentPage.value,
                      i,
                      selectedFileController.selectedJson.value!,
                      uiModelController.uiModel.value!);
                case Constants.radio:
                  return UtilityWidgets().buildRadio(
                      pageController.currentPage.value,
                      i,
                      selectedFileController.selectedJson.value!,
                      uiModelController.uiModel.value!);
                case Constants.checkBox:
                  return UtilityWidgets().buildCheckBox(
                      pageController.currentPage.value,
                      i,
                      selectedFileController.selectedJson.value!,
                      uiModelController.uiModel.value!);
                case Constants.dropDown:
                  return UtilityWidgets().buildDropDown(
                      pageController.currentPage.value,
                      i,
                      selectedFileController.selectedJson.value!,
                      uiModelController.uiModel.value!);
                case Constants.image:
                  return UtilityWidgets().buildImage(
                      pageController.currentPage.value,
                      i,
                      selectedFileController.selectedJson.value!,
                      uiModelController.uiModel.value!);
                default:
                  return Container();
              }
            }));
  }

  loadJson() async {
    try
     {
       UtilityWidgets().initFields(uiModelController.uiModel.value!);
       pageController.setTotalPage(uiModelController.uiModel.value!.fields!.elementAt(0).page!.length);
     }
     catch(e)
     {
       CommonWidgets.showToast("Error ${e.toString()}");
     }
  }

  // submit() {
  //   for (int i = 0; i < uiModel.fields!.elementAt(0).page!.length; i++) {
  //     for (int j = 0;
  //         j < uiModel.fields!.elementAt(0).page!.elementAt(i).lists!.length;
  //         j++) {
  //       int id = uiModel.fields!
  //           .elementAt(0)
  //           .page!
  //           .elementAt(i)
  //           .lists!
  //           .elementAt(j)
  //           .id!;
  //       //log("id is $id");
  //       switch (uiModel.fields!
  //           .elementAt(0)
  //           .page!
  //           .elementAt(i)
  //           .lists!
  //           .elementAt(j)
  //           .type) {
  //         case Constants.text:
  //           {
  //             log("Text is ${textController.editTextList[i]}");
  //           }
  //           break;
  //         case Constants.radio:
  //           {
  //             RadioModel radioModel = RadioModel.fromJson(
  //                 jsonDecode(responseTxt!)['fields']
  //                     .elementAt(0)["page"]
  //                     .elementAt(i)["lists"]
  //                     .elementAt(j)['ob']);
  //             if (radioModel.validation!.isMandatory != null &&
  //                 radioModel.validation!.isMandatory!) {
  //               if (radioValueController.radioValue[id]!.values.elementAt(0) ==
  //                   "null") {
  //                 radioValueController.radioVisible[id] = true;
  //                 radioValueController.update();
  //               } else {
  //                 radioValueController.radioVisible[id] = false;
  //                 radioValueController.update();
  //               }
  //             }
  //           }
  //           break;
  //         case Constants.checkBox:
  //           {
  //             //log("chckbox ${checkboxController.checkboxValue[id].toString()}");
  //             int selectedCount = 0;
  //             CheckBoxModel checkboxModel = CheckBoxModel.fromJson(
  //                 jsonDecode(responseTxt!)['fields']
  //                     .elementAt(0)["page"]
  //                     .elementAt(i)["lists"]
  //                     .elementAt(j)['ob']);
  //             for (int index = 0;
  //                 index < checkboxController.checkboxValue[id]!.length;
  //                 index++) {
  //               if (checkboxController.checkboxValue[id]![index] == true) {
  //                 selectedCount++;
  //               }
  //             }
  //             if (checkboxModel.validation!.minCheck! <= selectedCount &&
  //                 selectedCount <= checkboxModel.validation!.maxCheck!) {
  //               checkboxController.checkBoxVisible[id] = false;
  //               checkboxController.update();
  //             } else {
  //               checkboxController.checkBoxVisible[id] = true;
  //               checkboxController.update();
  //             }
  //           }
  //           break;
  //         case Constants.dropDown:
  //           {
  //             DropDownModel dropDownModel = DropDownModel.fromJson(
  //                 jsonDecode(responseTxt!)['fields']
  //                     .elementAt(0)["page"]
  //                     .elementAt(i)["lists"]
  //                     .elementAt(j)['ob']);
  //             if (dropDownModel.validation!.isMandatory != null &&
  //                 dropDownModel.validation!.isMandatory!) {
  //               if (dropDownValueController.dropDownValue[id]!.values
  //                       .elementAt(0) ==
  //                   null) {
  //                 dropDownValueController.dropDownVisible[id] = true;
  //                 dropDownValueController.update();
  //               } else {
  //                 dropDownValueController.dropDownVisible[id] = false;
  //                 dropDownValueController.update();
  //               }
  //             }
  //           }
  //           break;
  //         case Constants.image:
  //           {
  //             ImageModel imageModel = ImageModel.fromJson(
  //                 jsonDecode(responseTxt!)['fields']
  //                     .elementAt(0)["page"]
  //                     .elementAt(i)["lists"]
  //                     .elementAt(j)['ob']);
  //             if (imageModel.validation!.isMandatory != null &&
  //                 imageModel.validation!.isMandatory!) {
  //               if (imageController.imageFileList[id]!.path == "") {
  //                 imageController.imageVisible[id] = true;
  //                 imageController.update();
  //               } else {
  //                 imageController.imageVisible[id] = false;
  //                 imageController.update();
  //               }
  //             }
  //           }
  //           break;
  //         default:
  //           log("");
  //       }
  //     }
  //   }
  //
  //   for (int i = 0; i < uiModel.fields!.length; i++) {}
  //   if (_formKey.currentState!.validate()) {
  //     if (!radioValueController.radioVisible.contains(true) &&
  //         !checkboxController.checkBoxVisible.contains(true) &&
  //         !dropDownValueController.dropDownVisible.contains(true)) {
  //       CommonWidgets.showToast("All Done!!!!!!!");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          /// This shows maing UI
                          buildPages(),

                          pageController.currentPage.value ==
                              uiModelController.uiModel.value!.fields!
                                  .elementAt(0)
                                  .page!
                                  .length - 1
                              ? ElevatedButton(
                              onPressed: () {
                                //submit();
                              },
                              child: const Text("Submit"))
                              : Container()
                        ],
                      )),
                ),
              ),
            ),

            /// For Prev And Next
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                          () => Visibility(
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        visible: pageController.currentPage.value > 0
                            ? true
                            : false,
                        child: ElevatedButton(
                            onPressed: () {
                              pageController.setCurrentPage(
                                  pageController.currentPage.value - 1);
                            },
                            child: const Text("Prev")),
                      ),
                    ),
                    Obx(() => Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: pageController.currentPage.value !=
                          pageController.totalPage.value - 1,
                      child: ElevatedButton(
                          onPressed: () {
                            pageController.setCurrentPage(
                                pageController.currentPage.value + 1);
                          },
                          child: const Text("Next")),
                    ))
                  ],
                ))
          ],
        ));
  }
}