class DropDownModel {
  String? label;
  bool? dependent;
  List<Cond>? cond;
  List<Values>? values;
  Validation? validation;

  DropDownModel({this.label, this.dependent, this.cond, this.values, this.validation});

  DropDownModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
    if (json['cond'] != null) {
      cond = <Cond>[];
      json['cond'].forEach((v) {
        cond!.add(new Cond.fromJson(v));
      });
    }
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['dependent'] = this.dependent;
    if (this.cond != null) {
      data['cond'] = this.cond!.map((v) => v.toJson()).toList();
    }
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    return data;
  }
}

class Cond {
  int? id;
  int? subId;

  Cond({this.id, this.subId});

  Cond.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subId = json['sub_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_id'] = this.subId;
    return data;
  }
}

class Values {
  int? id;
  String? value;

  Values({this.id, this.value});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

class Validation {
  bool? isMandatory;

  Validation({this.isMandatory});

  Validation.fromJson(Map<String, dynamic> json) {
    isMandatory = json['is_mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_mandatory'] = this.isMandatory;
    return data;
  }
}
