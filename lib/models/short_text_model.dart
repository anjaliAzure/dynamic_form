class ShortTextModel {
  String? label;
  Validation? validation;

  ShortTextModel({this.label, this.validation});

  ShortTextModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    validation = json['validation'] != null
        ? Validation.fromJson(json['validation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    if (validation != null) {
      data['validation'] = validation!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content_type'] = contentType;
    data['input_type'] = inputType;
    data['length'] = length;
    return data;
  }
}
