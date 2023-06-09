class ShortTextModel {
  String? label;
  Validation? validation;

  ShortTextModel({this.label, this.validation});

  ShortTextModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    return data;
  }
}

class Validation {
  String? contentType;
  String? inputType;
  List<int>? length;

  Validation({this.contentType, this.inputType, this.length});

  Validation.fromJson(Map<String, dynamic> json) {
    contentType = json['content_type'];
    inputType = json['input_type'];
    length = json['length'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_type'] = this.contentType;
    data['input_type'] = this.inputType;
    data['length'] = this.length;
    return data;
  }
}
