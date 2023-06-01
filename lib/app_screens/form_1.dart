import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test2/app_constants/constants.dart';
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

  Widget buildShortText(int idx)
  {
    ShortTextModel shortTextModel = ShortTextModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
    print(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);
    RadioModel radioModel = RadioModel.fromJson(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);

    return Row(
      children: [
        for(int i = 0 ; i < radioModel.values!.length ; i++)
          Row(
            children: [
              Radio(value: radioModel.values!.elementAt(i), groupValue: groupValue.elementAt(idx), onChanged: (value){
                  setState(() {
                    print("Hi");
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
    print(jsonDecode(responseTxt!)['fields'].elementAt(idx)["ob"]);
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
           groupValue.insert(element.id!, null);
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
    return Scaffold(
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
              print("hi!!!");
              for(int i= 0; i <uiModel.fields!.length ; i++)
                {
                  switch(uiModel.fields!.elementAt(i).type)
                  {
                    case Constants.shortText : {
                      log("-- ${editTexts.elementAt(i)}");
                    }
                    break;
                    case Constants.radio : {
                       if(groupValue[i] != null)
                         {
                           log(groupValue[i].toString());
                         }
                    }
                    break;
                    case Constants.checkBox : {
                       log(checkBoxValue.elementAt(i).toString());
                    };
                    default : log("");
                  }
                }

            }, child: Text("Submit"))
          ],
        ),
      ));
  }
}
