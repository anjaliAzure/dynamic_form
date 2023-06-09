class UiModel {
  List<Fields>? fields;
  int? noOfFields;

  UiModel({this.fields, this.noOfFields});

  UiModel.fromJson(Map<String, dynamic> json) {
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
    noOfFields = json['no_of_fields'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    data['no_of_fields'] = noOfFields;
    return data;
  }
}

class Fields {
  List<Page>? page;

  Fields({this.page});

  Fields.fromJson(Map<String, dynamic> json) {
    if (json['page'] != null) {
      page = <Page>[];
      json['page'].forEach((v) {
        page!.add(Page.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.page != null) {
      data['page'] = this.page!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Page {
  int? pageNo;
  List<Lists>? lists;

  Page({this.pageNo, this.lists});

  Page.fromJson(Map<String, dynamic> json) {
    pageNo = json['page_no'];
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(Lists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_no'] = this.pageNo;
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  String? type;
  int? id;
  Ob? ob;

  Lists({this.type, this.id, this.ob});

  Lists.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    ob = json['ob'] != null ? Ob.fromJson(json['ob']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.ob != null) {
      data['ob'] = this.ob!.toJson();
    }
    return data;
  }
}

class Ob {
  String? label;
  dynamic values;
  dynamic validation;


  Ob({/*this.values,*/this.label});

  Ob.fromJson(Map<String, dynamic> json) {
    values = json['values'];
    validation = json['validation'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = this.label;
    data['values'] = this.values;
    data['validation'] = this.validation;
    return data;
  }
}