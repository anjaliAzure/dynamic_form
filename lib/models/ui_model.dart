class UiModel {
  List<Fields>? fields;

  UiModel({this.fields});

  UiModel.fromJson(Map<String, dynamic> json) {
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  String? type;
  int? id;
  Ob? ob;

  Fields({this.type, this.id, this.ob});

  Fields.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    ob = json['ob'] != null ? new Ob.fromJson(json['ob']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.ob != null) {
      data['ob'] = this.ob!.toJson();
    }
    return data;
  }
}

class Ob {
  String? label;
  dynamic values;
  dynamic validation;


  Ob({/*this.values,*/this.label});

  Ob.fromJson(Map<String, dynamic> json) {
    values = json['values'];
    validation = json['validation'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['values'] = this.values;
    data['validation'] = this.validation;
    return data;
  }
}

// class Values {
//   int? id;
//   String? value;
//
//   Values({this.id, this.value});
//
//   Values.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['value'] = this.value;
//     return data;
//   }
// }
