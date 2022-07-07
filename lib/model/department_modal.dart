class DepartmentModal {
  DepartmentModal({
      int? code, 
      List<Data>? data, 
      String? msg,}){
    _code = code;
    _data = data;
    _msg = msg;
}

  DepartmentModal.fromJson(dynamic json) {
    _code = json['code'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _msg = json['msg'];
  }
  int? _code;
  List<Data>? _data;
  String? _msg;

  int? get code => _code;
  List<Data>? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['msg'] = _msg;
    return map;
  }

}

class Data {
  Data({
      String? deptName, 
      String? deptId, 
      List<Child>? child,}){
    _deptName = deptName;
    _deptId = deptId;
    _child = child;
}

  Data.fromJson(dynamic json) {
    _deptName = json['deptName'];
    _deptId = json['deptId'];
    if (json['child'] != null) {
      _child = [];
      json['child'].forEach((v) {
        _child?.add(Child.fromJson(v));
      });
    }
  }
  String? _deptName;
  String? _deptId;
  List<Child>? _child;

  String? get deptName => _deptName;
  String? get deptId => _deptId;
  List<Child>? get child => _child;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deptName'] = _deptName;
    map['deptId'] = _deptId;
    if (_child != null) {
      map['child'] = _child?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Child {
  Child({
      String? deptName, 
      String? deptId, 
      List<dynamic>? child,}){
    _deptName = deptName;
    _deptId = deptId;
    _child = child;
}

  Child.fromJson(dynamic json) {
    _deptName = json['deptName'];
    _deptId = json['deptId'];
    if (json['child'] != null) {
      _child = [];
      json['child'].forEach((v) {
        _child?.add(json.fromJson(v));
      });
    }
  }
  String? _deptName;
  String? _deptId;
  List<dynamic>? _child;

  String? get deptName => _deptName;
  String? get deptId => _deptId;
  List<dynamic>? get child => _child;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deptName'] = _deptName;
    map['deptId'] = _deptId;
    if (_child != null) {
      map['child'] = _child?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}