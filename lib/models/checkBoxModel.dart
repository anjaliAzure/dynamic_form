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
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    return data;
  }
}

class Values {
  int? id;
  String? value;
  List<Cond>? cond;

  Values({this.id, this.value, this.cond});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    if (json['cond'] != null) {
      cond = <Cond>[];
      json['cond'].forEach((v) {
        cond!.add(new Cond.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    if (this.cond != null) {
      data['cond'] = this.cond!.map((v) => v.toJson()).toList();
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

class Validation {
  int? minCheck;
  int? maxCheck;

  Validation({this.minCheck, this.maxCheck});

  Validation.fromJson(Map<String, dynamic> json) {
    minCheck = json['min_check'];
    maxCheck = json['max_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_check'] = this.minCheck;
    data['max_check'] = this.maxCheck;
    return data;
  }
}
