import 'dart:convert';
/// code : 200
/// data : [{"name":"跖趾关节结核","type_dictText":"系统","details":[{"diagnosisName":"跖趾关节结核","seqNo":1,"diagnosisId":"1","diagnosisCode":"A18.012+","id":"1","templateId":"4"}],"id":"4","type":0}]
/// msg : "成功"

CommonDiagnosisModal commonDiagnosisModalFromJson(String str) => CommonDiagnosisModal.fromJson(json.decode(str));
String commonDiagnosisModalToJson(CommonDiagnosisModal data) => json.encode(data.toJson());
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
CommonDiagnosisModal copyWith({  int? code,
  List<Data>? data,
  String? msg,
}) => CommonDiagnosisModal(  code: code ?? _code,
  data: data ?? _data,
  msg: msg ?? _msg,
);
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

/// name : "跖趾关节结核"
/// type_dictText : "系统"
/// details : [{"diagnosisName":"跖趾关节结核","seqNo":1,"diagnosisId":"1","diagnosisCode":"A18.012+","id":"1","templateId":"4"}]
/// id : "4"
/// type : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? name, 
      String? typeDictText, 
      List<Details>? details, 
      String? id, 
      int? type,}){
    _name = name;
    _typeDictText = typeDictText;
    _details = details;
    _id = id;
    _type = type;
}

  Data.fromJson(dynamic json) {
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
  String? _name;
  String? _typeDictText;
  List<Details>? _details;
  String? _id;
  int? _type;
Data copyWith({  String? name,
  String? typeDictText,
  List<Details>? details,
  String? id,
  int? type,
}) => Data(  name: name ?? _name,
  typeDictText: typeDictText ?? _typeDictText,
  details: details ?? _details,
  id: id ?? _id,
  type: type ?? _type,
);
  String? get name => _name;
  String? get typeDictText => _typeDictText;
  List<Details>? get details => _details;
  String? get id => _id;
  int? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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

/// diagnosisName : "跖趾关节结核"
/// seqNo : 1
/// diagnosisId : "1"
/// diagnosisCode : "A18.012+"
/// id : "1"
/// templateId : "4"

Details detailsFromJson(String str) => Details.fromJson(json.decode(str));
String detailsToJson(Details data) => json.encode(data.toJson());
class Details {
  Details({
      String? diagnosisName, 
      int? seqNo, 
      String? diagnosisId, 
      String? diagnosisCode, 
      String? id, 
      String? templateId,}){
    _diagnosisName = diagnosisName;
    _seqNo = seqNo;
    _diagnosisId = diagnosisId;
    _diagnosisCode = diagnosisCode;
    _id = id;
    _templateId = templateId;
}

  Details.fromJson(dynamic json) {
    _diagnosisName = json['diagnosisName'];
    _seqNo = json['seqNo'];
    _diagnosisId = json['diagnosisId'];
    _diagnosisCode = json['diagnosisCode'];
    _id = json['id'];
    _templateId = json['templateId'];
  }
  String? _diagnosisName;
  int? _seqNo;
  String? _diagnosisId;
  String? _diagnosisCode;
  String? _id;
  String? _templateId;
Details copyWith({  String? diagnosisName,
  int? seqNo,
  String? diagnosisId,
  String? diagnosisCode,
  String? id,
  String? templateId,
}) => Details(  diagnosisName: diagnosisName ?? _diagnosisName,
  seqNo: seqNo ?? _seqNo,
  diagnosisId: diagnosisId ?? _diagnosisId,
  diagnosisCode: diagnosisCode ?? _diagnosisCode,
  id: id ?? _id,
  templateId: templateId ?? _templateId,
);
  String? get diagnosisName => _diagnosisName;
  int? get seqNo => _seqNo;
  String? get diagnosisId => _diagnosisId;
  String? get diagnosisCode => _diagnosisCode;
  String? get id => _id;
  String? get templateId => _templateId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['diagnosisName'] = _diagnosisName;
    map['seqNo'] = _seqNo;
    map['diagnosisId'] = _diagnosisId;
    map['diagnosisCode'] = _diagnosisCode;
    map['id'] = _id;
    map['templateId'] = _templateId;
    return map;
  }

}