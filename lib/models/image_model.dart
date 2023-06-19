class ImageModel {
  String? label;
  bool? dependent;
  Cond? cond;
  Validation? validation;

  ImageModel({this.label, this.dependent, this.cond, this.validation});

  ImageModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
    cond = json['cond'] != null ? Cond.fromJson(json['cond']) : null;
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
