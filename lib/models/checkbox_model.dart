class CheckBoxModel {
  String? label;
  bool? dependent;
  List<Values>? values;
  Validation? validation;

  CheckBoxModel({this.label, this.dependent, this.values, this.validation});

  CheckBoxModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
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
    if (values != null) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    if (validation != null) {
      data['validation'] = validation!.toJson();
    }
    return data;
  }
}

class Values {
  int? id;
  String? value;
  Cond? cond;

  Values({this.id, this.value, this.cond});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    cond = json['cond'] != null ? Cond.fromJson(json['cond']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    if (cond != null) {
      data['cond'] = cond!.toJson();
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

class Validation {
  int? minCheck;
  int? maxCheck;

  Validation({this.minCheck, this.maxCheck});

  Validation.fromJson(Map<String, dynamic> json) {
    minCheck = json['min_check'];
    maxCheck = json['max_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_check'] = minCheck;
    data['max_check'] = maxCheck;
    return data;
  }
}
