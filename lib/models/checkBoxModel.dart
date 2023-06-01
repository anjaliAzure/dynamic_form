class CheckBoxModel {
  List<Values>? values;
  Validation? validation;

  CheckBoxModel({this.values, this.validation});

  CheckBoxModel.fromJson(Map<String, dynamic> json) {
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

  Values({this.id, this.value});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['value'] = this.value;
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
