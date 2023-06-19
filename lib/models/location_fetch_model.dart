class LocationFetch {
  String? label;
  bool? dependent;
  bool? isPlace;
  bool? isCurrent;

  LocationFetch({this.label, this.dependent, this.isPlace, this.isCurrent});

  LocationFetch.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    dependent = json['dependent'];
    isPlace = json['is_place'];
    isCurrent = json['is_current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['dependent'] = this.dependent;
    data['is_place'] = this.isPlace;
    data['is_current'] = this.isCurrent;
    return data;
  }
}
