class CommonDiagnosisModal {
  CommonDiagnosisModal({
      int? code, 
      List<Data>? data, 
      String? msg,}){
    _code = code;
    _data = data;
    _msg = msg;
}

  CommonDiagnosisModal.fromJson(dynamic json) {
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
      String? deptIdDictText, 
      String? deptId, 
      String? name, 
      String? typeDictText, 
      List<Details>? details, 
      String? id, 
      int? type,}){
    _deptIdDictText = deptIdDictText;
    _deptId = deptId;
    _name = name;
    _typeDictText = typeDictText;
    _details = details;
    _id = id;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _deptIdDictText = json['deptId_dictText'];
    _deptId = json['deptId'];
    _name = json['name'];
    _typeDictText = json['type_dictText'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(Details.fromJson(v));
      });
    }
    _id = json['id'];
    _type = json['type'];
  }
  String? _deptIdDictText;
  String? _deptId;
  String? _name;
  String? _typeDictText;
  List<Details>? _details;
  String? _id;
  int? _type;

  String? get deptIdDictText => _deptIdDictText;
  String? get deptId => _deptId;
  String? get name => _name;
  String? get typeDictText => _typeDictText;
  List<Details>? get details => _details;
  String? get id => _id;
  int? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deptId_dictText'] = _deptIdDictText;
    map['deptId'] = _deptId;
    map['name'] = _name;
    map['type_dictText'] = _typeDictText;
    if (_details != null) {
      map['details'] = _details?.map((v) => v.toJson()).toList();
    }
    map['id'] = _id;
    map['type'] = _type;
    return map;
  }

}

class Details {
  Details({
      String? diagnosisName, 
      String? seqNo, 
      String? diagnosisId, 
      int? isMaster, 
      String? diagnosisCode, 
      String? id, 
      String? templateId, 
      String? isMasterDictText,}){
    _diagnosisName = diagnosisName;
    _seqNo = seqNo;
    _diagnosisId = diagnosisId;
    _isMaster = isMaster;
    _diagnosisCode = diagnosisCode;
    _id = id;
    _templateId = templateId;
    _isMasterDictText = isMasterDictText;
}

  Details.fromJson(dynamic json) {
    _diagnosisName = json['diagnosisName'];
    _seqNo = json['seqNo'].toString();
    _diagnosisId = json['diagnosisId'];
    _isMaster = json['isMaster'];
    _diagnosisCode = json['diagnosisCode'];
    _id = json['id'];
    _templateId = json['templateId'];
    _isMasterDictText = json['isMaster_dictText'];
  }
  String? _diagnosisName;
  String? _seqNo;
  String? _diagnosisId;
  int? _isMaster;
  String? _diagnosisCode;
  String? _id;
  String? _templateId;
  String? _isMasterDictText;
  set isMaster(int? isMaster){
    _isMaster = isMaster;
  }
  String? get diagnosisName => _diagnosisName;
  String? get seqNo => _seqNo;
  String? get diagnosisId => _diagnosisId;
  int? get isMaster => _isMaster;
  String? get diagnosisCode => _diagnosisCode;
  String? get id => _id;
  String? get templateId => _templateId;
  String? get isMasterDictText => _isMasterDictText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['diagnosisName'] = _diagnosisName;
    map['seqNo'] = _seqNo;
    map['diagnosisId'] = _diagnosisId;
    map['isMaster'] = _isMaster;
    map['diagnosisCode'] = _diagnosisCode;
    map['id'] = _id;
    map['templateId'] = _templateId;
    map['isMaster_dictText'] = _isMasterDictText;
    return map;
  }

}