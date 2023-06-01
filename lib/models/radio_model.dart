class RadioModel {
  List<String>? values;
  Validation? validation;

  RadioModel({this.values, this.validation});

  RadioModel.fromJson(Map<String, dynamic> json) {
    values = json['values'].cast<String>();
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['values'] = this.values;
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
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
