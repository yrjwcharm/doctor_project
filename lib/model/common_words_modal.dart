import 'dart:convert';
/// code : 200
/// data : [{"type_dictText":"系统","remark":"系统常用语1","id":"1","type":0},{"type_dictText":"系统","remark":"系统常用语2","id":"2","type":0}]
/// msg : "成功"

CommonWordsModal commonWordsModalFromJson(String str) => CommonWordsModal.fromJson(json.decode(str));
String commonWordsModalToJson(CommonWordsModal data) => json.encode(data.toJson());
class CommonWordsModal {
  CommonWordsModal({
      int? code, 
      List<Data>? data, 
      String? msg,}){
    _code = code;
    _data = data;
    _msg = msg;
}

  CommonWordsModal.fromJson(dynamic json) {
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
CommonWordsModal copyWith({  int? code,
  List<Data>? data,
  String? msg,
}) => CommonWordsModal(  code: code ?? _code,
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

/// type_dictText : "系统"
/// remark : "系统常用语1"
/// id : "1"
/// type : 0

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? typeDictText, 
      String? remark, 
      String? id, 
      int? type,}){
    _typeDictText = typeDictText;
    _remark = remark;
    _id = id;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _typeDictText = json['type_dictText'];
    _remark = json['remark'];
    _id = json['id'];
    _type = json['type'];
  }
  String? _typeDictText;
  String? _remark;
  String? _id;
  int? _type;
Data copyWith({  String? typeDictText,
  String? remark,
  String? id,
  int? type,
}) => Data(  typeDictText: typeDictText ?? _typeDictText,
  remark: remark ?? _remark,
  id: id ?? _id,
  type: type ?? _type,
);
  String? get typeDictText => _typeDictText;
  String? get remark => _remark;
  String? get id => _id;
  int? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type_dictText'] = _typeDictText;
    map['remark'] = _remark;
    map['id'] = _id;
    map['type'] = _type;
    return map;
  }

}