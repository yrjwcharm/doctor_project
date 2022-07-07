class DiagnosisDataModal {
  DiagnosisDataModal({
      int? code, 
      Data? data, 
      String? msg,}){
    _code = code;
    _data = data;
    _msg = msg;
}

  DiagnosisDataModal.fromJson(dynamic json) {
    _code = json['code'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _msg = json['msg'];
  }
  int? _code;
  Data? _data;
  String? _msg;

  int? get code => _code;
  Data? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['msg'] = _msg;
    return map;
  }

}

class Data {
  Data({
      int? total, 
      int? size, 
      List<Records>? records, 
      int? page,}){
    _total = total;
    _size = size;
    _records = records;
    _page = page;
}

  Data.fromJson(dynamic json) {
    _total = json['total'];
    _size = json['size'];
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(Records.fromJson(v));
      });
    }
    _page = json['page'];
  }
  int? _total;
  int? _size;
  List<Records>? _records;
  int? _page;

  int? get total => _total;
  int? get size => _size;
  List<Records>? get records => _records;
  int? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['size'] = _size;
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    map['page'] = _page;
    return map;
  }

}

class Records {
  Records({
      String? dianame, 
      String? diacode, 
      int? id, 
      int? isMaster, 
      bool? isSelected, 
      String? diadesc,}){
    _dianame = dianame;
    _diacode = diacode;
    _id = id;
    _isMaster = isMaster;
    _isSelected = isSelected;
    _diadesc = diadesc;
}

  Records.fromJson(dynamic json) {
    _dianame = json['dianame'];
    _diacode = json['diacode'];
    _id = json['id'];
    _isMaster = json['isMaster']??0;
    _isSelected = json['isSelected']??false;
    _diadesc = json['diadesc'];
  }
  String? _dianame;
  String? _diacode;
  int? _id;
  int? _isMaster;
  bool? _isSelected;
  String? _diadesc;
  set isSelected(bool? isSelected){
    _isSelected = isSelected;
  }
  set isMaster(int? isMaster){
    _isMaster = isMaster;
  }
  String? get dianame => _dianame;
  String? get diacode => _diacode;
  int? get id => _id;
  int? get isMaster => _isMaster;
  bool? get isSelected => _isSelected;
  String? get diadesc => _diadesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dianame'] = _dianame;
    map['diacode'] = _diacode;
    map['id'] = _id;
    map['isMaster'] = _isMaster;
    map['isSelected'] = _isSelected;
    map['diadesc'] = _diadesc;
    return map;
  }

}