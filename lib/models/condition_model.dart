class ConditionModel {
  List<Cond>? cond;

  ConditionModel({this.cond});

  ConditionModel.fromJson(Map<String, dynamic> json) {
    if (json['cond'] != null) {
      cond = <Cond>[];
      json['cond'].forEach((v) {
        cond!.add(new Cond.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
