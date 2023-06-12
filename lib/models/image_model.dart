class ImageModel {
  String? label;
  bool? dependent;
  List<Cond>? cond;
  Validation? validation;

  ImageModel({this.label, this.dependent, this.cond, this.validation});

  ImageModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
    if (json['cond'] != null) {
      cond = <Cond>[];
      json['cond'].forEach((v) {
        cond!.add(new Cond.fromJson(v));
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
