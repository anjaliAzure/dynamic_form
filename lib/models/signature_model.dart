class SignatureModel {
  String? label;
  bool? dependent;

  SignatureModel({this.label, this.dependent});

  SignatureModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['dependent'] = dependent;
    return data;
  }
}
