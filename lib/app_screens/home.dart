import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test2/app_constants/constants.dart';
import 'package:test2/get_controllers/page_controller.dart';
import 'package:test2/get_controllers/selected_file_controller.dart';
import 'package:test2/get_controllers/ui_model_controller.dart';
import 'package:test2/utilities/common_widgets.dart';
import 'package:test2/utilities/utility_widgets.dart';

import '../get_controllers/checkbox_controller.dart';
import '../get_controllers/dropdown_controller.dart';
import '../get_controllers/image_controller.dart';
import '../get_controllers/radio_controller.dart';
import '../get_controllers/text_controller.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  CurrentPageController pageController = Get.find<CurrentPageController>();
  SelectedFileController selectedFileController =
      Get.find<SelectedFileController>();
  UIModelController uiModelController = Get.find<UIModelController>();
  late RadioController radioValueController = Get.find<RadioController>();
  late DropDownController dropDownValueController =
      Get.find<DropDownController>();
  late CheckboxController checkboxController = Get.find<CheckboxController>();
  late ImageController imageController = Get.find<ImageController>();
  late TextController textController = Get.find<TextController>();

  Widget buildPages() {
    return Obx(() => ListView.builder(
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
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!);
            case Constants.radio:
              return UtilityWidgets().buildRadio(
                  pageController.currentPage.value,
                  i,
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!);
            case Constants.checkBox:
              return UtilityWidgets().buildCheckBox(
                  pageController.currentPage.value,
                  i,
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!);
            case Constants.dropDown:
              return UtilityWidgets().buildDropDown(
                  pageController.currentPage.value,
                  i,
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!);
            case Constants.image:
              return UtilityWidgets().buildImage(
                  pageController.currentPage.value,
                  i,
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!);
            case Constants.location:
              return UtilityWidgets().buildLocation(
                  pageController.currentPage.value,
                  i,
                  selectedFileController.selectedJson.value,
                  uiModelController.uiModel.value!,
                  context);
            default:
              return Container();
          }
        }));
  }

  loadJson() async {
    try {
      UtilityWidgets().initFields(uiModelController.uiModel.value!);
      pageController.setTotalPage(
          uiModelController.uiModel.value!.fields!.elementAt(0).page!.length);
    } catch (e) {
      CommonWidgets.showToast("Error ${e.toString()}");
    }
  }

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
                      /// This shows main UI
                      buildPages(),
                      Obx(() => pageController.currentPage.value ==
                              uiModelController.uiModel.value!.fields!
                                      .elementAt(0)
                                      .page!
                                      .length -
                                  1
                          ? ElevatedButton(
                              onPressed: () {
                                //submit();
                              },
                              child: const Text("Submit"))
                          : Container())
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
                    visible:
                        pageController.currentPage.value > 0 ? true : false,
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
