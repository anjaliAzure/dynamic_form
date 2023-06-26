import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:test2/app_constants/constants.dart';
import 'package:test2/app_screens/fetch_location.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/dropdown_controller.dart';
import 'package:test2/get_controllers/image_controller.dart';
import 'package:test2/get_controllers/page_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';
import 'package:test2/get_controllers/signature_controller.dart';
import 'package:test2/get_controllers/text_controller.dart';
import 'package:test2/get_controllers/ui_model_controller.dart';
import 'package:test2/models/checkbox_model.dart';
import 'package:test2/models/condition_model.dart' as condition_model;
import 'package:test2/models/dropdown_model.dart';
import 'package:test2/models/image_model.dart';
import 'package:test2/models/radio_model.dart';
import 'package:test2/models/short_text_model.dart';
import 'package:test2/models/signature_model.dart';
import 'package:test2/models/ui_model.dart';
import 'package:test2/utilities/common_widgets.dart';
import 'package:test2/utilities/hive_crud.dart';

class UtilityWidgets {
  late RadioController radioValueController = Get.find<RadioController>();
  late DropDownController dropDownValueController =
      Get.find<DropDownController>();
  late CheckboxController checkboxController = Get.find<CheckboxController>();
  late ImageController imageController = Get.find<ImageController>();
  late TextController textController = Get.find<TextController>();
  late UIModelController uiModelController = Get.find<UIModelController>();
  late CurrentPageController pageController = Get.find<CurrentPageController>();
  late SignatureControllers signatureControllers =
      Get.find<SignatureControllers>();
  late dynamic location = '';

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
          case Constants.signature:
            signatureControllers.setSignatureImagePath(element.id!, '');
            signatureControllers.controller[element.id!] = SignatureController(
              penStrokeWidth: 1,
              penColor: Colors.red,
              exportBackgroundColor: Colors.transparent,
              exportPenColor: Colors.black,
              onDrawStart: () {
                signatureControllers.takePic(element.id!);
                log("====================== picture   ${signatureControllers.imagePath[element.id]!}");
              },
              onDrawEnd: () => log('onDrawEnd called!'),
            );
            signatureControllers.setSignatureVisible(element.id!, false);
            break;
        }
      }
    }
  }

  void currentValue(
      {required int currentId,
      required int prevId,
      required String currentType,
      dynamic currentModel}) {
    ///set the default value as per current widget type
    switch (currentType) {
      case Constants.radio:
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (int index = 0; index < currentModel!.values!.length; index++) {
              if (currentModel.values![index].cond!.id != null) {
                if (currentModel.values![index].cond!.id == prevId &&
                    radioValueController.radioValue[currentId]!.keys.first ==
                        currentModel.values![index].id) {
                  radioValueController.setRadioValue(currentId, {-1: "null"});
                }
              }
            }
          });
          break;
        }
      case Constants.checkBox:
        {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (int index = 0; index < currentModel!.values!.length; index++) {
              if (currentModel.values![index].cond!.id != null) {
                if (currentModel.values![index].cond!.id == prevId) {
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
                    currentModel: currentModel);
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
                      currentModel: currentModel);
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
                  currentModel: currentModel);
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
        initialValue: textController.editTextList[id],
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
                                      _checkGPSData(id).then((value) {
                                        location =
                                            '${value?.latitude} ${value?.longitude}';
                                      });
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
                                      _checkGPSData(id).then((value) {
                                        location =
                                            '${value?.latitude} ${value?.longitude}';
                                      });
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
                            child: Column(
                              children: [
                                Image.file(
                                  File(imageController.imageFileList[id]!.path),
                                  errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) =>
                                      const Center(
                                          child: Text(
                                              'This image type is not supported')),
                                ),
                                Text('${location ?? ''}'),
                              ],
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

  /// Location
  Widget buildLocation(int page, int idx, String responseTxt, UiModel uiModel,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const FetchLocation()))
                .then((value) {
              if (value != null && value.isNotEmpty) {
                CommonWidgets.showToast(
                    "Current Location \n ${value[2].toStringAsFixed(3)}, ${value[3].toStringAsFixed(3)}");
                CommonWidgets.showToast(
                    "Marked Location \n ${value[0].toStringAsFixed(3)}, ${value[1].toStringAsFixed(3)}");
              }
            });
          },
          child: const Text("Select Location")),
    );
  }

  Widget buildSignature(
      int page, int idx, String responseTxt, UiModel uiModel) {
    /// idx is the index of the list
    SignatureModel signatureModel = SignatureModel.fromJson(
        jsonDecode(responseTxt)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      signatureControllers.controller[id]!.clear();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.white)))),
                    child: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${signatureModel.label}'),
              Signature(
                controller: signatureControllers.controller[id]!,
                height: 100,
                width: 300,
                backgroundColor: Colors.grey[300]!,
              ),
              const SizedBox(
                height: 10,
              ),
              Image.file(File(signatureControllers.imagePath[id]!)),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: signatureControllers.signatureVisible[id]!,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Please add your signature",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  /// Submit
  submit() {
    int totalPage = pageController.totalPage.value;
    try {
      for (int i = 0; i < totalPage; i++) {
        for (int j = 0;
            j <
                uiModelController.uiModel.value!.fields!
                    .elementAt(0)
                    .page!
                    .elementAt(i)
                    .lists!
                    .length;
            j++) {
          int id = uiModelController.uiModel.value!.fields!
              .elementAt(0)
              .page!
              .elementAt(i)
              .lists!
              .elementAt(j)
              .id!;
          switch (uiModelController.uiModel.value!.fields!
              .elementAt(0)
              .page!
              .elementAt(i)
              .lists!
              .elementAt(j)
              .type) {
            case Constants.text:
              {
                HiveHelper().insert({id: textController.editTextList[id]!});
              }
              break;
            case Constants.radio:
              {
                Map<int, String> val = {};
                val = radioValueController.radioValue[id]!;
                HiveHelper().insert({
                  id: {val.keys.first: val.values.first}
                });
              }
              break;
            case Constants.checkBox:
              {
                Map<int, dynamic>? val = {};
                val = checkboxController.checkboxValue[id];

                Map<int, dynamic> x = {};
                val?.forEach((key, value) {
                  x.addAll({key: value});
                });

                HiveHelper().insert({id: val});
              }
              break;
            case Constants.dropDown:
              {
                Map<int, dynamic>? val = {};
                val = dropDownValueController.dropDownValue[id];
                HiveHelper().insert({
                  id: {val?.keys.first: val?.values.first}
                });
              }
              break;
            case Constants.image:
              {}
              break;
            default:
              {}
          }
        }
      }
    } catch (e) {
      CommonWidgets.printLog("Error ${e.toString()}");
    }

    fetchData();
  }

  fetchData() async {
    //if (await askStoragePermission()) {
    HiveHelper().read(isWrite: true);
    // }
  }

  Future<bool> askStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (!(await Permission.storage.isGranted)) {
      if (await Permission.storage.request() == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    return true;
  }

  Future<GeoFirePoint?> _checkGPSData(int i) async {
    Map<String, IfdTag> imgTags = await readExifFromBytes(
        File(imageController.imageFileList[i]!.path).readAsBytesSync());

    if (imgTags.containsKey('GPS GPSLongitude')) {
      //_imgHasLocation = true;
      return exifGPSToGeoFirePoint(imgTags);
    }
    return null;
  }

  GeoFirePoint exifGPSToGeoFirePoint(Map<String, IfdTag> tags) {
    final latitudeValue = tags['GPS GPSLatitude']!
        .values
        .toList()
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final latitudeSignal = tags['GPS GPSLatitudeRef']!.printable;

    final longitudeValue = tags['GPS GPSLongitude']!
        .values
        .toList()
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final longitudeSignal = tags['GPS GPSLongitudeRef']!.printable;

    double latitude =
        latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    double longitude = longitudeValue[0] +
        (longitudeValue[1] / 60) +
        (longitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    return GeoFirePoint(latitude, longitude);
  }
}
