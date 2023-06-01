import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test2/app_constants/constants.dart';
import 'package:test2/common_utilities/common_widgets.dart';
import 'package:test2/models/checkBoxModel.dart';
import 'package:test2/models/radio_model.dart';
import 'package:test2/models/short_text_model.dart';
import 'package:test2/models/ui_model.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  String? responseTxt;
  late UiModel uiModel;
  late List<String?> groupValue ;
  late List<List<bool>?> checkBoxValue;
  late List<String?> editTexts;

  final _formKey = GlobalKey<FormState>();

  Widget buildShortText(int idx)
  {
    ShortTextModel shortTextModel = ShortTextModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (val){
           if(shortTextModel.validation!.length!.first > -1 && shortTextModel.validation!.length!.last > -1 )
            {
              return val!.length < shortTextModel.validation!.length!.first  || val.length > shortTextModel.validation!.length!.last
                  ? "Please enter valid data" : null;
            }
            if(shortTextModel.validation!.length!.last > -1)
            {
              print("-- ${shortTextModel.validation!.length!.last} - ${val!.length}");
              return val.length < shortTextModel.validation!.length!.first ? "Min ${shortTextModel.validation!.length!.first} characters required !" : null;
            }
            if(shortTextModel.validation!.length!.last > -1)
            {
              print("-- ${shortTextModel.validation!.length!.last} - ${val!.length}");
              return val.length > shortTextModel.validation!.length!.last ? "Max ${shortTextModel.validation!.length!.last} characters required !" : null;
            }
          return null;
        } ,
        decoration: InputDecoration(
          label: Text(shortTextModel.label!)
        ),
        onChanged: (value){
          editTexts[idx] = value;
        },
      ),
    );
  }

  Widget buildRadio(int idx)
  {
    RadioModel radioModel = RadioModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);

    return Row(
      children: [
        for(int i = 0 ; i < radioModel.values!.length ; i++)
          Row(
            children: [
              Radio(
                  toggleable: true,
                  value: radioModel.values!.elementAt(i), groupValue: groupValue.elementAt(idx), onChanged: (value){
                    if(value == null)
                      {
                        log("-  now NULL ");
                      }
                  setState(() {
                    groupValue[idx] = value.toString();
                  });
              }),
              Text(radioModel.values!.elementAt(i))
            ],
          )
      ],
    );
  }

  Widget buildCheckBox(int idx)
  {
    CheckBoxModel checkBoxModel = CheckBoxModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);


    return Row(
      children: [
        for(int i = 0 ; i < checkBoxModel.values!.length ; i++)
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: checkBoxValue.elementAt(idx)!.elementAt(i),
                onChanged: (bool? value) {
                  checkBoxValue[idx]![i] = value!;
                  setState(() { });
                },
              ),
              Text( checkBoxModel.values!.elementAt(i).value!)
            ],
          ),
      ],
    );
  }

  loadJson() async
  {
    responseTxt = await rootBundle.loadString("assets/form.json");
    uiModel = UiModel.fromJson(jsonDecode(responseTxt!));
    groupValue = List.generate(uiModel.fields!.length , (index) => null);
    checkBoxValue  = List.generate(uiModel.fields!.length, (index) => null);
    editTexts  = List.generate(uiModel.fields!.length, (index) => null);
    uiModel.fields!.forEach((element) {
       if(element.type == Constants.radio)
         {
           groupValue.insert(element.id!, "null");
         }
       else if(element.type == Constants.checkBox)
       {
         CheckBoxModel checkBoxModel = CheckBoxModel.fromJson(element.ob!.toJson());
         checkBoxValue.insert(element.id!, List.generate(checkBoxModel.values!.length, (index) => false));
       }
    });
    setState(() {});
    print(uiModel.fields!.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: responseTxt == null ? Container() : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView.builder(
                shrinkWrap: true,
                  itemCount: uiModel.fields!.length,
                  itemBuilder: (ctx , i){
                    switch(uiModel.fields!.elementAt(i).type)
                    {
                      case Constants.shortText : return buildShortText(i);
                      case Constants.radio : return buildRadio(i);
                      case Constants.checkBox : return buildCheckBox(i);
                      default : return Container();
                    }
                  }),
              ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate())
                  {
                    for(int i= 0; i <uiModel.fields!.length ; i++)
                    {
                      log("- ${uiModel.fields!.elementAt(i).type}");
                      switch(uiModel.fields!.elementAt(i).type)
                      {
                        case Constants.shortText : {
                          log("Text is ${editTexts.elementAt(i)}");
                        }
                        break;
                        case Constants.radio : {

                          RadioModel radioModel = RadioModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(i)["ob"]);
                          if(radioModel.validation!.isMandatory != null && radioModel.validation!.isMandatory!)
                            {
                              if(groupValue[i] == "null")
                              {
                                  CommonWidgets.showToast("Please select item !");
                              }
                              else
                                {
                                  log("Radio is ${groupValue[i]}");
                                }
                            }
                        }
                        break;
                        case Constants.checkBox : {
                          log("chckbox ${checkBoxValue.elementAt(i).toString()}");
                        }
                        break;
                        default : log("");
                      }
                    }
                  }
              }, child: Text("Submit"))
            ],
          ),
        )),
    );
  }
}
