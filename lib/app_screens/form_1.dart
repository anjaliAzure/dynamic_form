import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test2/app_constants/constants.dart';
import 'package:test2/get_controllers/checkbox_controller.dart';
import 'package:test2/get_controllers/image_controller.dart';
import 'package:test2/get_controllers/radio_controller.dart';
import 'package:test2/get_controllers/text_controller.dart';
import 'package:test2/models/checkBoxModel.dart';
import 'package:test2/models/condition_model.dart' as ConditionModel;
import 'package:test2/models/dropdown_model.dart';
import 'package:test2/models/image_model.dart';
import 'package:test2/models/radio_model.dart';
import 'package:test2/models/short_text_model.dart';
import 'package:test2/models/ui_model.dart';

import '../common_utilities/common_widgets.dart';
import '../get_controllers/drop_down_controller.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  int currentPage = 0; // initial page is  First Page
  late int totalPage;
  String? responseTxt;
  late UiModel uiModel;

  //late List<Map<int, String>?> radioValue;
  //late List<bool?> radioVisible, checkBoxVisible, dropDownVisible, imageVisible;

  //late List<Map<int, dynamic>?> dropDownValue;
  //late List<Map<int, bool>?> checkBoxValue;
  //late List<String?> editTexts;
  //late List<XFile>? imageFileList;
  final ImagePicker picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  RadioController radioValueController = Get.find<RadioController>();
  DropDownController dropDownValueController = Get.find<DropDownController>();
  CheckboxController checkboxController = Get.find<CheckboxController>();
  ImageController imageController = Get.find<ImageController>();
  TextController textController = Get.find<TextController>();

  bool checkCondition(
      {required bool isDependent,
      required List<dynamic> value,
      required int page}) {
    /// check is dependent
    if (isDependent) {
      /// this field does not dependent so return true
      if (value.isEmpty) {
        return true;
      }

      /// else
      for (int i = 0; i < value.length; i++) {
        ///traverse condition array
        ConditionModel.Cond conditionModel = ConditionModel.Cond.fromJson(
            jsonDecode(jsonEncode(value[i]).toString()));

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
              return false;
            }
        }
      }
      return true;
    }
    return true;
  }

  Widget buildShortText(int page, int idx) {
    /// idx is the index of the list
    ShortTextModel shortTextModel = ShortTextModel.fromJson(
        jsonDecode(responseTxt!)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt!)['fields']
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
          textController.editTextList[id] = value;
          textController.update();
        },
      ),
    );
  }

  Widget buildRadio(int page, int idx) {
    /// idx is the index of the list
    RadioModel radioModel = RadioModel.fromJson(
        jsonDecode(responseTxt!)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt!)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return GetBuilder<RadioController>(
        init: RadioController(),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (int i = 0; i < radioModel.values!.length; i++)
                    Visibility(
                      visible: checkCondition(
                          isDependent: radioModel.dependent ?? false,
                          value: radioModel.values!.elementAt(i).cond ?? [],
                          page: page),
                      child: Row(
                        children: [
                          Radio(
                              toggleable: true,
                              value: radioModel.values!.elementAt(i).value,
                              groupValue: radioValueController
                                  .radioValue[id]!.values.first,
                              onChanged: (value) {
                                if (value == null) {
                                  radioValueController.radioValue[id] = {
                                    -1: value.toString()
                                  };
                                  radioValueController.update();
                                } else {
                                  radioValueController.radioValue[id] = {
                                    i: value.toString()
                                  };
                                  radioValueController.update();
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
          );
        });
  }

  Widget buildDropDown(int page, int idx) {
    /// idx is the index of the list
    DropDownModel dropDownModel = DropDownModel.fromJson(
        jsonDecode(responseTxt!)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt!)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];
    return GetBuilder<DropDownController>(
        init: DropDownController(),
        builder: (context) {
          return Visibility(
            visible: checkCondition(
                isDependent: dropDownModel.dependent ?? false,
                value: dropDownModel.cond ?? [],
                page: page),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton(
                  hint: Text(dropDownModel.label.toString()),
                  // Not necessary for Option 1
                  value:
                      dropDownValueController.dropDownValue[id]!.values.first,
                  onChanged: (newValue) {
                    //setState(() {
                    int index = 0;
                    dropDownModel.values?.forEach((element) {
                      if (element.value == newValue) {
                        index = element.id!;
                        return;
                      }
                    });
                    dropDownValueController.dropDownValue[id] = {
                      index: newValue.toString()
                    };
                    dropDownValueController.update();
                    //dropDownValue[id] = {index: newValue.toString()};
                    //dropDownValue[idx]![] = newValue;
                    //});
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
          );
        });
  }

  Widget buildCheckBox(int page, int idx) {
    /// idx is the index of the list
    CheckBoxModel checkBoxModel = CheckBoxModel.fromJson(
        jsonDecode(responseTxt!)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt!)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < checkBoxModel.values!.length; i++)
              GetBuilder<CheckboxController>(
                  init: CheckboxController(),
                  builder: (context) {
                    return Visibility(
                      visible: checkCondition(
                          isDependent: checkBoxModel.dependent ?? false,
                          value: checkBoxModel.values!.elementAt(i).cond ?? [],
                          page: page),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                            value: checkboxController.checkboxValue[id]!.values
                                .elementAt(i),
                            //checkBoxValue.elementAt(id)![i],
                            onChanged: (bool? value) {
                              checkboxController.checkboxValue[id]![i] = value!;
                              checkboxController.update();
                            },
                          ),
                          Text(checkBoxModel.values!.elementAt(i).value!)
                        ],
                      ),
                    );
                  }),
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
    );
  }

  Widget buildImage(int page, int idx) {
    /// idx is the index of the list
    ImageModel imageModel = ImageModel.fromJson(
        jsonDecode(responseTxt!)['fields']
            .elementAt(0)["page"]
            .elementAt(page)["lists"]
            .elementAt(idx)['ob']);

    /// id is the id of the field
    int id = jsonDecode(responseTxt!)['fields']
        .elementAt(0)["page"]
        .elementAt(page)["lists"]
        .elementAt(idx)['id'];

    return GetBuilder<ImageController>(
        init: ImageController(),
        builder: (context) {
          return Visibility(
            visible: checkCondition(
                isDependent: imageModel.dependent ?? false,
                value: imageModel.cond ?? [],
                page: page),
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
                                        imageController.imageFileList[id] =
                                            pickedFile!;
                                        imageController.update();
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
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
                                        imageController.imageFileList[id] =
                                            pickedFile!;
                                        imageController.update();
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
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
                                    imageController.imageFileList[id] =
                                        XFile("");
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
                                errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) =>
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
          );
        });
  }

  Widget buildPages() {
    return responseTxt != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uiModel.fields!.first.page!
                .elementAt(currentPage)
                .lists!
                .length,
            itemBuilder: (context, i) {
              /// i represents index of the list
              switch (uiModel.fields!.first.page!
                  .elementAt(currentPage)
                  .lists!
                  .elementAt(i)
                  .type) {
                case Constants.text:
                  return buildShortText(currentPage, i);
                case Constants.radio:
                  return buildRadio(currentPage, i);
                case Constants.checkBox:
                  return buildCheckBox(currentPage, i);
                case Constants.dropDown:
                  return buildDropDown(currentPage, i);
                case Constants.image:
                  return buildImage(currentPage, i);
                default:
                  return Container();
              }
            })
        : Container();
  }

  loadJson() async {
    responseTxt = await rootBundle.loadString("assets/form.json");
    uiModel = UiModel.fromJson(jsonDecode(responseTxt!));
    //radioValue = List.generate(uiModel.noOfFields!, (index) => null);
    radioValueController.radioVisible =
        RxList.generate(uiModel.noOfFields!, (index) => false);
    checkboxController.checkBoxVisible =
        RxList.generate(uiModel.noOfFields!, (index) => false);
    dropDownValueController.dropDownVisible =
        RxList.generate(uiModel.noOfFields!, (index) => false);
    //dropDownValue = List.generate(uiModel.noOfFields!, (index) => null);
    imageController.imageVisible =
        RxList.generate(uiModel.noOfFields!, (index) => false);
    //imageFileList = List.generate(uiModel.fields!.length, (index) => XFile(""));
    //checkBoxValue =
    //    List.generate(uiModel.noOfFields!, (index) => <int, bool>{});
    //editTexts = List.generate(uiModel.noOfFields!, (index) => null);

    //log("check le ${checkBoxValue.length}");

    totalPage = uiModel.fields!.elementAt(0).page!.length;

    /// initialise list of all Types
    uiModel.fields!.elementAt(0).page!.forEach((element) {
      element.lists!.forEach((element) {
        switch (element.type) {
          case Constants.text:
            {
              textController.editTextList[element.id!] = null;
            }
            break;

          case Constants.radio:
            {
              radioValueController.radioValue[element.id!] = {-1: "null"};
              //radioValue.insert(element.id!, {-1: "null"});
            }
            break;

          case Constants.checkBox:
            {
              CheckBoxModel checkBoxModel =
                  CheckBoxModel.fromJson(element.ob!.toJson());

              Map<int, bool> x = {};
              for (int index = 0;
                  index < checkBoxModel.values!.length;
                  index++) {
                x[checkBoxModel.values![index].id!] = false;
              }

              checkboxController.checkboxValue[element.id!] = x;
            }
            break;

          case Constants.dropDown:
            {
              dropDownValueController.dropDownValue[element.id!] = {-1: null};
              //dropDownValue.insert(element.id!, {-1: null});
            }
            break;
          case Constants.image:
            imageController.imageFileList[element.id!] = XFile("");
            break;
        }
      });
    });
    setState(() {});
  }

  submit() {
    for (int i = 0; i < uiModel.fields!.elementAt(0).page!.length; i++) {
      for (int j = 0;
          j < uiModel.fields!.elementAt(0).page!.elementAt(i).lists!.length;
          j++) {
        int id = uiModel.fields!
            .elementAt(0)
            .page!
            .elementAt(i)
            .lists!
            .elementAt(j)
            .id!;
        //log("id is $id");
        switch (uiModel.fields!
            .elementAt(0)
            .page!
            .elementAt(i)
            .lists!
            .elementAt(j)
            .type) {
          case Constants.text:
            {
              log("Text is ${textController.editTextList[i]}");
            }
            break;
          case Constants.radio:
            {
              RadioModel radioModel = RadioModel.fromJson(
                  jsonDecode(responseTxt!)['fields']
                      .elementAt(0)["page"]
                      .elementAt(i)["lists"]
                      .elementAt(j)['ob']);
              if (radioModel.validation!.isMandatory != null &&
                  radioModel.validation!.isMandatory!) {
                if (radioValueController.radioValue[id]!.values.elementAt(0) ==
                    "null") {
                  radioValueController.radioVisible[id] = true;
                  radioValueController.update();
                } else {
                  radioValueController.radioVisible[id] = false;
                  radioValueController.update();
                }
              }
            }
            break;
          case Constants.checkBox:
            {
              //log("chckbox ${checkboxController.checkboxValue[id].toString()}");
              int selectedCount = 0;
              CheckBoxModel checkboxModel = CheckBoxModel.fromJson(
                  jsonDecode(responseTxt!)['fields']
                      .elementAt(0)["page"]
                      .elementAt(i)["lists"]
                      .elementAt(j)['ob']);
              for (int index = 0;
                  index < checkboxController.checkboxValue[id]!.length;
                  index++) {
                if (checkboxController.checkboxValue[id]![index] == true) {
                  selectedCount++;
                }
              }
              if (checkboxModel.validation!.minCheck! <= selectedCount &&
                  selectedCount <= checkboxModel.validation!.maxCheck!) {
                checkboxController.checkBoxVisible[id] = false;
                checkboxController.update();
              } else {
                checkboxController.checkBoxVisible[id] = true;
                checkboxController.update();
              }
            }
            break;
          case Constants.dropDown:
            {
              DropDownModel dropDownModel = DropDownModel.fromJson(
                  jsonDecode(responseTxt!)['fields']
                      .elementAt(0)["page"]
                      .elementAt(i)["lists"]
                      .elementAt(j)['ob']);
              if (dropDownModel.validation!.isMandatory != null &&
                  dropDownModel.validation!.isMandatory!) {
                if (dropDownValueController.dropDownValue[id]!.values
                        .elementAt(0) ==
                    null) {
                  dropDownValueController.dropDownVisible[id] = true;
                  dropDownValueController.update();
                } else {
                  dropDownValueController.dropDownVisible[id] = false;
                  dropDownValueController.update();
                }
              }
            }
            break;
          case Constants.image:
            {
              ImageModel imageModel = ImageModel.fromJson(
                  jsonDecode(responseTxt!)['fields']
                      .elementAt(0)["page"]
                      .elementAt(i)["lists"]
                      .elementAt(j)['ob']);
              if (imageModel.validation!.isMandatory != null &&
                  imageModel.validation!.isMandatory!) {
                if (imageController.imageFileList[id]!.path == "") {
                  imageController.imageVisible[id] = true;
                  imageController.update();
                } else {
                  imageController.imageVisible[id] = false;
                  imageController.update();
                }
              }
            }
            break;
          default:
            log("");
        }
      }
    }

    for (int i = 0; i < uiModel.fields!.length; i++) {}
    if (_formKey.currentState!.validate()) {
      if (!radioValueController.radioVisible.contains(true) &&
          !checkboxController.checkBoxVisible.contains(true) &&
          !dropDownValueController.dropDownVisible.contains(true)) {
        CommonWidgets.showToast("All Done!!!!!!!");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
    // radioValueController.radioValue.listen((p0) {
    //   p0.forEach((key, value) {
    //     print("\n - $key");
    //     value.forEach((key, value) {
    //       print("\n key $key value $value");
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: responseTxt == null
            ? Container()
            : Column(
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
                                buildPages(),
                                currentPage ==
                                        uiModel.fields!
                                                .elementAt(0)
                                                .page!
                                                .length -
                                            1
                                    ? ElevatedButton(
                                        onPressed: () {
                                          submit();
                                        },
                                        child: Text("Submit"))
                                    : Container()
                              ],
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Visibility(
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            visible: currentPage > 0 ? true : false,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentPage--;
                                  });
                                },
                                child: Text("Prev")),
                          ),
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: currentPage != totalPage - 1,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentPage++;
                                  });
                                },
                                child: Text("Next")),
                          )
                        ],
                      ))
                ],
              ));
  }
}
