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
      String? deptId, 
      bool? checked, 
      String? deptName,}){
    _deptId = deptId;
    _checked = checked;
    _deptName = deptName;
}

  Data.fromJson(dynamic json) {
    _deptId = json['dept_id'];
    _checked =false;
    _deptName = json['dept_name'];
  }
  String? _deptId;
  bool? _checked;
  String? _deptName;
  set checked(bool? checked){
    _checked = checked;
  }
  String? get deptId => _deptId;
  bool? get checked => _checked;
  String? get deptName => _deptName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dept_id'] = _deptId;
    map['checked'] = _checked;
    map['dept_name'] = _deptName;
    return map;
  }

}