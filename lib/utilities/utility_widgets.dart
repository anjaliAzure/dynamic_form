import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test2/app_constants/constants.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/dropdown_controller.dart';
import 'package:test2/get_controllers/image_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';
import 'package:test2/get_controllers/text_controller.dart';
import 'package:test2/models/checkbox_model.dart';
import 'package:test2/models/condition_model.dart' as condition_model;
import 'package:test2/models/dropdown_model.dart';
import 'package:test2/models/image_model.dart';
import 'package:test2/models/radio_model.dart';
import 'package:test2/models/short_text_model.dart';
import 'package:test2/models/ui_model.dart';

class UtilityWidgets {
  late RadioController radioValueController = Get.find<RadioController>();
  late DropDownController dropDownValueController =
      Get.find<DropDownController>();
  late CheckboxController checkboxController = Get.find<CheckboxController>();
  late ImageController imageController = Get.find<ImageController>();
  late TextController textController = Get.find<TextController>();

  initFields(UiModel uiModel) {
    /// initialise list of all Types
    for (var element in uiModel.fields!.elementAt(0).page!) {
      for (var element in element.lists!) {
        switch (element.type) {
          case Constants.text:
            {
              textController.setEditTextList(element.id!, null);
            }
            break;

          case Constants.radio:
            {
              radioValueController.setRadioValue(element.id!, {-1: "null"});
              radioValueController.setRadioVisible(element.id!, false);
            }
            break;

          case Constants.checkBox:
            {
              CheckBoxModel checkBoxModel =
                  CheckBoxModel.fromJson(element.ob!.toJson());

              Map<int, bool> temp = {};
              for (int index = 0;
                  index < checkBoxModel.values!.length;
                  index++) {
                temp[checkBoxModel.values![index].id!] = false;
              }
              checkboxController.initCheckboxValue(element.id!, temp);
              checkboxController.setCheckBoxVisible(element.id!, false);
            }
            break;

          case Constants.dropDown:
            {
              dropDownValueController.setDropdownValue(element.id!, {-1: null});
              dropDownValueController.setDropDownVisible(element.id!, false);
            }
            break;
          case Constants.image:
            imageController.setImageFileList(element.id!, XFile(""));
            imageController.setImageVisible(element.id!, false);
            break;
        }
      }
    }
  }

  void currentValue(
      {required int currentId,
      required int prevId,
      required String currentType,
      dynamic checkBoxModel}) {
    ///set the default value as per current widget type
    switch (currentType) {
      case Constants.radio:
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            radioValueController.setRadioValue(currentId, {-1: "null"});
          });
          break;
        }
      case Constants.checkBox:
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (int index = 0;
                index < checkBoxModel!.values!.length;
                index++) {
              if (checkBoxModel.values![index].cond!.id != null) {
                if (checkBoxModel.values![index].cond!.id == prevId) {
                  checkboxController.setCheckBoxValue(currentId, index, false);
                }
              }
            }
          });
          break;
        }
      case Constants.dropDown:
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            dropDownValueController.setDropdownValue(currentId, {-1: null});
          });
          break;
        }
      default:
        break;
    }
  }

  bool checkCondition(
      {required int currentId,
      required String currentType,
      required bool isDependent,
      required dynamic conditionValue,
      required int page,
      required UiModel uiModel,
      required dynamic currentModel}) {
    /// check is dependent
    if (isDependent) {
      /// this field does not dependent so return true
      // if (conditionValue.) {
      //   return true;
      // }

      /// else
      //for (int i = 0; i < conditionValue.length; i++) {
      ///traverse condition array
      condition_model.Cond conditionModel = condition_model.Cond.fromJson(
          jsonDecode(jsonEncode(conditionValue).toString()));

      if (conditionModel.id != null && conditionModel.subId != null) {
        /// check what is the type of field on which current fields depends
        switch (uiModel.fields!
            .elementAt(0)
            .page!
            .elementAt(page)
            .lists!
            .singleWhere((element) => element.id == conditionModel.id)
            .type) {
          ///  check if the element on which current field is dependent is selected or not
          case Constants.radio:
            {
              if (radioValueController
                      .radioValue[conditionModel.id]!.keys.first ==
                  conditionModel.subId) {
                ///clear current widget value as per dependency
                currentValue(
                    currentId: currentId,
                    prevId: conditionModel.id!,
                    currentType: currentType,
                    checkBoxModel: currentModel);
                return false;
              }
            }
            break;

          case Constants.checkBox:
            {
              for (int index = 0;
                  index <
                      checkboxController
                          .checkboxValue[conditionModel.id!]!.keys.length;
                  index++) {
                if (checkboxController.checkboxValue[conditionModel.id!]!.keys
                            .elementAt(index) ==
                        conditionModel.subId &&
                    checkboxController
                            .checkboxValue[conditionModel.id!]![index] ==
                        true) {
                  ///clear current widget value as per dependency
                  currentValue(
                      currentId: currentId,
                      prevId: conditionModel.id!,
                      currentType: currentType,
                      checkBoxModel: currentModel);
                  return false;
                }
              }
            }
            break;
          case Constants.dropDown:
            if (dropDownValueController
                    .dropDownValue[conditionModel.id!]!.keys.first ==
                conditionModel.subId) {
              return true;
            } else {
              ///clear current widget value as per dependency
              currentValue(
                  currentId: currentId,
                  prevId: conditionModel.id!,
                  currentType: currentType,
                  checkBoxModel: currentModel);
              return false;
            }
        }
      }
      // }
      return true;
    }
    return true;
  }

  /// Text
  Widget buildShortText(
      int page, int idx, String responseTxt, UiModel uiModel) {
    /// idx is the index of the list
    ShortTextModel shortTextModel = ShortTextModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (val) {
          if (shortTextModel.validation!.length!.first > -1) {
            if (val!.isEmpty) {
              return "Please Enter Data";
            } else if (shortTextModel.validation!.length!.first > val.length ||
                shortTextModel.validation!.length!.last < val.length) {
              return "Please Enter Value Between ${shortTextModel.validation!.length!.first} to ${shortTextModel.validation!.length!.last}";
            } else {
              return null;
            }
          } else {
            if (shortTextModel.validation!.length!.last > -1 &&
                shortTextModel.validation!.length!.last < val!.length) {
              return "Max ${shortTextModel.validation!.length!.last} characters required !";
            } else {
              return null;
            }
          }
        },
        decoration: InputDecoration(label: Text(shortTextModel.label!)),
        onChanged: (value) {
          textController.setEditTextList(id, value);
        },
      ),
    );
  }

  /// Radio
  Widget buildRadio(int page, int idx, String responseTxt, UiModel uiModel) {
    /// idx is the index of the list
    RadioModel radioModel = RadioModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (int i = 0; i < radioModel.values!.length; i++)
                  Visibility(
                    visible: checkCondition(
                        currentId: id,
                        currentType: Constants.radio,
                        isDependent: radioModel.dependent ?? false,
                        conditionValue:
                            radioModel.values!.elementAt(i).cond ?? [],
                        page: page,
                        uiModel: uiModel,
                        currentModel: radioModel),
                    child: Row(
                      children: [
                        Radio(
                            toggleable: true,
                            value: radioModel.values!.elementAt(i).value,
                            groupValue: radioValueController
                                .radioValue[id]!.values.first,
                            onChanged: (value) {
                              if (value == null) {
                                radioValueController
                                    .setRadioValue(id, {-1: value.toString()});
                              } else {
                                radioValueController
                                    .setRadioValue(id, {i: value.toString()});
                              }
                            }),
                        Text(radioModel.values!.elementAt(i).value!)
                      ],
                    ),
                  ),
              ],
            ),
            Visibility(
              visible: radioValueController.radioVisible[id]!,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Please Choose One",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ));
  }

  /// DropDown
  Widget buildDropDown(int page, int idx, String responseTxt, UiModel uiModel) {
    /// idx is the index of the list
    DropDownModel dropDownModel = DropDownModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Obx(() => Visibility(
          visible: checkCondition(
              currentId: id,
              currentType: Constants.dropDown,
              isDependent: dropDownModel.dependent ?? false,
              conditionValue: dropDownModel.cond ?? [],
              page: page,
              uiModel: uiModel,
              currentModel: dropDownModel),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                hint: Text(dropDownModel.label.toString()),
                // Not necessary for Option 1
                value: dropDownValueController.dropDownValue[id]!.values.first,
                onChanged: (newValue) {
                  int index = 0;
                  dropDownModel.values?.forEach((element) {
                    if (element.value == newValue) {
                      index = element.id!;
                      return;
                    }
                  });
                  dropDownValueController
                      .setDropdownValue(id, {index: newValue.toString()});
                },
                items: dropDownModel.values!
                    .map((c) => c.value)
                    .toList()
                    .map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location!),
                  );
                }).toList(),
              ),
              Visibility(
                visible: dropDownValueController.dropDownVisible[id]!,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Please Choose one",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  /// CheckBox
  Widget buildCheckBox(int page, int idx, String responseTxt, UiModel uiModel) {
    /// idx is the index of the list
    CheckBoxModel checkBoxModel = CheckBoxModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (int i = 0; i < checkBoxModel.values!.length; i++)
                  Visibility(
                    visible: checkCondition(
                        currentId: id,
                        currentType: Constants.checkBox,
                        isDependent: checkBoxModel.dependent ?? false,
                        conditionValue:
                            checkBoxModel.values!.elementAt(i).cond ?? [],
                        page: page,
                        uiModel: uiModel,
                        currentModel: checkBoxModel),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.blue,
                          value: checkboxController.checkboxValue[id]!.values
                              .elementAt(i),
                          onChanged: (bool? value) {
                            checkboxController.setCheckBoxValue(id, i, value);
                          },
                        ),
                        Text(checkBoxModel.values!.elementAt(i).value!)
                      ],
                    ),
                  )
              ],
            ),
            Visibility(
              visible: checkboxController.checkBoxVisible[id]!,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Please Choose between ${checkBoxModel.validation!.minCheck!} to ${checkBoxModel.validation!.maxCheck!}",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ));
  }

  /// Image
  Widget buildImage(int page, int idx, String responseTxt, UiModel uiModel) {
    final ImagePicker picker = ImagePicker();

    /// idx is the index of the list
    ImageModel imageModel = ImageModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Obx(() => Visibility(
          visible: checkCondition(
              currentId: id,
              currentType: Constants.image,
              isDependent: imageModel.dependent ?? false,
              conditionValue: imageModel.cond ?? [],
              page: page,
              uiModel: uiModel,
              currentModel: imageModel),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageController.imageFileList[id]!.path == ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //width: 80,
                        //height: 80,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black26,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                imageModel.label!,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final XFile? pickedFile =
                                          await picker.pickImage(
                                        source: ImageSource.camera,
                                        maxWidth: 100,
                                        maxHeight: 100,
                                        imageQuality: 100,
                                      );
                                      imageController.setImageFileList(
                                          id, pickedFile!);
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                    color: Colors.grey)))),
                                    child:
                                        const Icon(Icons.camera_alt_outlined),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final XFile? pickedFile =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                        maxWidth: 100,
                                        maxHeight: 100,
                                        imageQuality: 100,
                                      );
                                      imageController.setImageFileList(
                                          id, pickedFile!);
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                    color: Colors.grey)))),
                                    child: const Icon(
                                        Icons.photo_library_outlined),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              ElevatedButton(
                                onPressed: () async {
                                  imageController.setImageFileList(
                                      id, XFile(""));
                                  imageController.update();
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Colors.white)))),
                                child: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                          Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black,
                            )),
                            child: Image.file(
                              File(imageController.imageFileList[id]!.path),
                              errorBuilder: (BuildContext context, Object error,
                                      StackTrace? stackTrace) =>
                                  const Center(
                                      child: Text(
                                          'This image type is not supported')),
                            ),
                          ),
                        ],
                      ),
                    ),
              Visibility(
                visible: imageController.imageVisible[id]!,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Please add required image",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
