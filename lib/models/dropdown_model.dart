class DropDownModel {
  String? label;
  bool? dependent;
  Cond? cond;
  List<Values>? values;
  Validation? validation;

  DropDownModel(
      {this.label, this.dependent, this.cond, this.values, this.validation});

  DropDownModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
    cond = json['cond'] != null ? Cond.fromJson(json['cond']) : null;
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
    validation = json['validation'] != null
        ? Validation.fromJson(json['validation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['dependent'] = dependent;
    if (cond != null) {
      data['cond'] = cond!.toJson();
    }
    if (values != null) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    if (validation != null) {
      data['validation'] = validation!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_id'] = subId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_mandatory'] = isMandatory;
    return data;
  }
}
