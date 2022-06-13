import 'dart:convert';
/// checkMsg : ""
/// pharmacistSign : ""
/// herbalMedicineVOS : ""
/// freq : ""
/// amt : "17.65"
/// type_dictText : ""
/// status_dictText : "审核中"
/// type : "1"
/// useType : ""
/// roomId : 2
/// freq_dictText : "未知字典"
/// registerId : 451214891395711000
/// category_dictText : "西药/中成药"
/// useType_dictText : "未知字典"
/// id : 944241327611052400
/// onceDosage : ""
/// pharId : ""
/// medicineVOS : [{"baseUnitid":"","wmOnceDosage":1,"freq":"bid","packageUnitid":"he2","amt":"17.65","specification":"0.25g*16粒","useType":"01","baseUnitid_dictText":"未知字典","medicineName":"云南白药胶囊0.25g","packageUnitid_dictText":"盒","medicineNum":1,"freq_dictText":"2次/天","manuname":"云南白药集团股份有限公司","dayNum":"12","useType_dictText":"口服","id":74516,"remarks":"好"}]
/// countNum : ""
/// doctorSign : ""
/// companySign : ""
/// recipeNo : "20220530193504348"
/// pharName : "未知字典"
/// checkDate : ""
/// drugRoom : "通海县人民医院中心药房"
/// repictDate : "2022-05-30 19:35"
/// diagnosisVOS : [{"diagnosisName":"诊断会谈和评价  ＮＯＳ","isMaster":1,"id":34022,"isMaster_dictText":"是"}]
/// onceDosageDes : ""
/// name : "普通处方"
/// patientVO : ""
/// category : 1
/// remarks : ""
/// status : 4

WesternRpTemplate westernRpTemplateFromJson(String str) => WesternRpTemplate.fromJson(json.decode(str));
String westernRpTemplateToJson(WesternRpTemplate data) => json.encode(data.toJson());
class WesternRpTemplate {
  WesternRpTemplate({
      String? checkMsg, 
      String? pharmacistSign, 
      String? herbalMedicineVOS, 
      String? freq, 
      String? amt, 
      String? typeDictText, 
      String? statusDictText, 
      String? type, 
      String? useType, 
      int? roomId, 
      String? freqDictText, 
      int? registerId, 
      String? categoryDictText, 
      String? useTypeDictText, 
      int? id, 
      String? onceDosage, 
      String? pharId, 
      List<MedicineVos>? medicineVOS, 
      String? countNum, 
      String? doctorSign, 
      String? companySign, 
      String? recipeNo, 
      String? pharName, 
      String? checkDate, 
      String? drugRoom, 
      String? repictDate, 
      List<DiagnosisVos>? diagnosisVOS, 
      String? onceDosageDes, 
      String? name, 
      String? patientVO, 
      int? category, 
      String? remarks, 
      int? status,}){
    _checkMsg = checkMsg;
    _pharmacistSign = pharmacistSign;
    _herbalMedicineVOS = herbalMedicineVOS;
    _freq = freq;
    _amt = amt;
    _typeDictText = typeDictText;
    _statusDictText = statusDictText;
    _type = type;
    _useType = useType;
    _roomId = roomId;
    _freqDictText = freqDictText;
    _registerId = registerId;
    _categoryDictText = categoryDictText;
    _useTypeDictText = useTypeDictText;
    _id = id;
    _onceDosage = onceDosage;
    _pharId = pharId;
    _medicineVOS = medicineVOS;
    _countNum = countNum;
    _doctorSign = doctorSign;
    _companySign = companySign;
    _recipeNo = recipeNo;
    _pharName = pharName;
    _checkDate = checkDate;
    _drugRoom = drugRoom;
    _repictDate = repictDate;
    _diagnosisVOS = diagnosisVOS;
    _onceDosageDes = onceDosageDes;
    _name = name;
    _patientVO = patientVO;
    _category = category;
    _remarks = remarks;
    _status = status;
}

  WesternRpTemplate.fromJson(dynamic json) {
    _checkMsg = json['checkMsg'];
    _pharmacistSign = json['pharmacistSign'];
    _herbalMedicineVOS = json['herbalMedicineVOS'];
    _freq = json['freq'];
    _amt = json['amt'];
    _typeDictText = json['type_dictText'];
    _statusDictText = json['status_dictText'];
    _type = json['type'];
    _useType = json['useType'];
    _roomId = json['roomId'];
    _freqDictText = json['freq_dictText'];
    _registerId = json['registerId'];
    _categoryDictText = json['category_dictText'];
    _useTypeDictText = json['useType_dictText'];
    _id = json['id'];
    _onceDosage = json['onceDosage'];
    _pharId = json['pharId'];
    if (json['medicineVOS'] != null) {
      _medicineVOS = [];
      json['medicineVOS'].forEach((v) {
        _medicineVOS?.add(MedicineVos.fromJson(v));
      });
    }
    _countNum = json['countNum'];
    _doctorSign = json['doctorSign'];
    _companySign = json['companySign'];
    _recipeNo = json['recipeNo'];
    _pharName = json['pharName'];
    _checkDate = json['checkDate'];
    _drugRoom = json['drugRoom'];
    _repictDate = json['repictDate'];
    if (json['diagnosisVOS'] != null) {
      _diagnosisVOS = [];
      json['diagnosisVOS'].forEach((v) {
        _diagnosisVOS?.add(DiagnosisVos.fromJson(v));
      });
    }
    _onceDosageDes = json['onceDosageDes'];
    _name = json['name'];
    _patientVO = json['patientVO'];
    _category = json['category'];
    _remarks = json['remarks'];
    _status = json['status'];
  }
  String? _checkMsg;
  String? _pharmacistSign;
  String? _herbalMedicineVOS;
  String? _freq;
  String? _amt;
  String? _typeDictText;
  String? _statusDictText;
  String? _type;
  String? _useType;
  int? _roomId;
  String? _freqDictText;
  int? _registerId;
  String? _categoryDictText;
  String? _useTypeDictText;
  int? _id;
  String? _onceDosage;
  String? _pharId;
  List<MedicineVos>? _medicineVOS;
  String? _countNum;
  String? _doctorSign;
  String? _companySign;
  String? _recipeNo;
  String? _pharName;
  String? _checkDate;
  String? _drugRoom;
  String? _repictDate;
  List<DiagnosisVos>? _diagnosisVOS;
  String? _onceDosageDes;
  String? _name;
  String? _patientVO;
  int? _category;
  String? _remarks;
  int? _status;
WesternRpTemplate copyWith({  String? checkMsg,
  String? pharmacistSign,
  String? herbalMedicineVOS,
  String? freq,
  String? amt,
  String? typeDictText,
  String? statusDictText,
  String? type,
  String? useType,
  int? roomId,
  String? freqDictText,
  int? registerId,
  String? categoryDictText,
  String? useTypeDictText,
  int? id,
  String? onceDosage,
  String? pharId,
  List<MedicineVos>? medicineVOS,
  String? countNum,
  String? doctorSign,
  String? companySign,
  String? recipeNo,
  String? pharName,
  String? checkDate,
  String? drugRoom,
  String? repictDate,
  List<DiagnosisVos>? diagnosisVOS,
  String? onceDosageDes,
  String? name,
  String? patientVO,
  int? category,
  String? remarks,
  int? status,
}) => WesternRpTemplate(  checkMsg: checkMsg ?? _checkMsg,
  pharmacistSign: pharmacistSign ?? _pharmacistSign,
  herbalMedicineVOS: herbalMedicineVOS ?? _herbalMedicineVOS,
  freq: freq ?? _freq,
  amt: amt ?? _amt,
  typeDictText: typeDictText ?? _typeDictText,
  statusDictText: statusDictText ?? _statusDictText,
  type: type ?? _type,
  useType: useType ?? _useType,
  roomId: roomId ?? _roomId,
  freqDictText: freqDictText ?? _freqDictText,
  registerId: registerId ?? _registerId,
  categoryDictText: categoryDictText ?? _categoryDictText,
  useTypeDictText: useTypeDictText ?? _useTypeDictText,
  id: id ?? _id,
  onceDosage: onceDosage ?? _onceDosage,
  pharId: pharId ?? _pharId,
  medicineVOS: medicineVOS ?? _medicineVOS,
  countNum: countNum ?? _countNum,
  doctorSign: doctorSign ?? _doctorSign,
  companySign: companySign ?? _companySign,
  recipeNo: recipeNo ?? _recipeNo,
  pharName: pharName ?? _pharName,
  checkDate: checkDate ?? _checkDate,
  drugRoom: drugRoom ?? _drugRoom,
  repictDate: repictDate ?? _repictDate,
  diagnosisVOS: diagnosisVOS ?? _diagnosisVOS,
  onceDosageDes: onceDosageDes ?? _onceDosageDes,
  name: name ?? _name,
  patientVO: patientVO ?? _patientVO,
  category: category ?? _category,
  remarks: remarks ?? _remarks,
  status: status ?? _status,
);
  String? get checkMsg => _checkMsg;
  String? get pharmacistSign => _pharmacistSign;
  String? get herbalMedicineVOS => _herbalMedicineVOS;
  String? get freq => _freq;
  String? get amt => _amt;
  String? get typeDictText => _typeDictText;
  String? get statusDictText => _statusDictText;
  String? get type => _type;
  String? get useType => _useType;
  int? get roomId => _roomId;
  String? get freqDictText => _freqDictText;
  int? get registerId => _registerId;
  String? get categoryDictText => _categoryDictText;
  String? get useTypeDictText => _useTypeDictText;
  int? get id => _id;
  String? get onceDosage => _onceDosage;
  String? get pharId => _pharId;
  List<MedicineVos>? get medicineVOS => _medicineVOS;
  String? get countNum => _countNum;
  String? get doctorSign => _doctorSign;
  String? get companySign => _companySign;
  String? get recipeNo => _recipeNo;
  String? get pharName => _pharName;
  String? get checkDate => _checkDate;
  String? get drugRoom => _drugRoom;
  String? get repictDate => _repictDate;
  List<DiagnosisVos>? get diagnosisVOS => _diagnosisVOS;
  String? get onceDosageDes => _onceDosageDes;
  String? get name => _name;
  String? get patientVO => _patientVO;
  int? get category => _category;
  String? get remarks => _remarks;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['checkMsg'] = _checkMsg;
    map['pharmacistSign'] = _pharmacistSign;
    map['herbalMedicineVOS'] = _herbalMedicineVOS;
    map['freq'] = _freq;
    map['amt'] = _amt;
    map['type_dictText'] = _typeDictText;
    map['status_dictText'] = _statusDictText;
    map['type'] = _type;
    map['useType'] = _useType;
    map['roomId'] = _roomId;
    map['freq_dictText'] = _freqDictText;
    map['registerId'] = _registerId;
    map['category_dictText'] = _categoryDictText;
    map['useType_dictText'] = _useTypeDictText;
    map['id'] = _id;
    map['onceDosage'] = _onceDosage;
    map['pharId'] = _pharId;
    if (_medicineVOS != null) {
      map['medicineVOS'] = _medicineVOS?.map((v) => v.toJson()).toList();
    }
    map['countNum'] = _countNum;
    map['doctorSign'] = _doctorSign;
    map['companySign'] = _companySign;
    map['recipeNo'] = _recipeNo;
    map['pharName'] = _pharName;
    map['checkDate'] = _checkDate;
    map['drugRoom'] = _drugRoom;
    map['repictDate'] = _repictDate;
    if (_diagnosisVOS != null) {
      map['diagnosisVOS'] = _diagnosisVOS?.map((v) => v.toJson()).toList();
    }
    map['onceDosageDes'] = _onceDosageDes;
    map['name'] = _name;
    map['patientVO'] = _patientVO;
    map['category'] = _category;
    map['remarks'] = _remarks;
    map['status'] = _status;
    return map;
  }

}

/// diagnosisName : "诊断会谈和评价  ＮＯＳ"
/// isMaster : 1
/// id : 34022
/// isMaster_dictText : "是"

DiagnosisVos diagnosisVosFromJson(String str) => DiagnosisVos.fromJson(json.decode(str));
String diagnosisVosToJson(DiagnosisVos data) => json.encode(data.toJson());
class DiagnosisVos {
  DiagnosisVos({
      String? diagnosisName, 
      int? isMaster, 
      int? id, 
      String? isMasterDictText,}){
    _diagnosisName = diagnosisName;
    _isMaster = isMaster;
    _id = id;
    _isMasterDictText = isMasterDictText;
}

  DiagnosisVos.fromJson(dynamic json) {
    _diagnosisName = json['diagnosisName'];
    _isMaster = json['isMaster'];
    _id = json['id'];
    _isMasterDictText = json['isMaster_dictText'];
  }
  String? _diagnosisName;
  int? _isMaster;
  int? _id;
  String? _isMasterDictText;
DiagnosisVos copyWith({  String? diagnosisName,
  int? isMaster,
  int? id,
  String? isMasterDictText,
}) => DiagnosisVos(  diagnosisName: diagnosisName ?? _diagnosisName,
  isMaster: isMaster ?? _isMaster,
  id: id ?? _id,
  isMasterDictText: isMasterDictText ?? _isMasterDictText,
);
  String? get diagnosisName => _diagnosisName;
  int? get isMaster => _isMaster;
  int? get id => _id;
  String? get isMasterDictText => _isMasterDictText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['diagnosisName'] = _diagnosisName;
    map['isMaster'] = _isMaster;
    map['id'] = _id;
    map['isMaster_dictText'] = _isMasterDictText;
    return map;
  }

}

/// baseUnitid : ""
/// wmOnceDosage : 1
/// freq : "bid"
/// packageUnitid : "he2"
/// amt : "17.65"
/// specification : "0.25g*16粒"
/// useType : "01"
/// baseUnitid_dictText : "未知字典"
/// medicineName : "云南白药胶囊0.25g"
/// packageUnitid_dictText : "盒"
/// medicineNum : 1
/// freq_dictText : "2次/天"
/// manuname : "云南白药集团股份有限公司"
/// dayNum : "12"
/// useType_dictText : "口服"
/// id : 74516
/// remarks : "好"

MedicineVos medicineVosFromJson(String str) => MedicineVos.fromJson(json.decode(str));
String medicineVosToJson(MedicineVos data) => json.encode(data.toJson());
class MedicineVos {
  MedicineVos({
      String? baseUnitid, 
      int? wmOnceDosage, 
      String? freq, 
      String? packageUnitid, 
      String? amt, 
      String? specification, 
      String? useType, 
      String? baseUnitidDictText, 
      String? medicineName, 
      String? packageUnitidDictText, 
      int? medicineNum, 
      String? freqDictText, 
      String? manuname, 
      String? dayNum, 
      String? useTypeDictText, 
      int? id, 
      String? remarks,}){
    _baseUnitid = baseUnitid;
    _wmOnceDosage = wmOnceDosage;
    _freq = freq;
    _packageUnitid = packageUnitid;
    _amt = amt;
    _specification = specification;
    _useType = useType;
    _baseUnitidDictText = baseUnitidDictText;
    _medicineName = medicineName;
    _packageUnitidDictText = packageUnitidDictText;
    _medicineNum = medicineNum;
    _freqDictText = freqDictText;
    _manuname = manuname;
    _dayNum = dayNum;
    _useTypeDictText = useTypeDictText;
    _id = id;
    _remarks = remarks;
}

  MedicineVos.fromJson(dynamic json) {
    _baseUnitid = json['baseUnitid'];
    _wmOnceDosage = json['wmOnceDosage'];
    _freq = json['freq'];
    _packageUnitid = json['packageUnitid'];
    _amt = json['amt'];
    _specification = json['specification'];
    _useType = json['useType'];
    _baseUnitidDictText = json['baseUnitid_dictText'];
    _medicineName = json['medicineName'];
    _packageUnitidDictText = json['packageUnitid_dictText'];
    _medicineNum = json['medicineNum'];
    _freqDictText = json['freq_dictText'];
    _manuname = json['manuname'];
    _dayNum = json['dayNum'];
    _useTypeDictText = json['useType_dictText'];
    _id = json['id'];
    _remarks = json['remarks'];
  }
  String? _baseUnitid;
  int? _wmOnceDosage;
  String? _freq;
  String? _packageUnitid;
  String? _amt;
  String? _specification;
  String? _useType;
  String? _baseUnitidDictText;
  String? _medicineName;
  String? _packageUnitidDictText;
  int? _medicineNum;
  String? _freqDictText;
  String? _manuname;
  String? _dayNum;
  String? _useTypeDictText;
  int? _id;
  String? _remarks;
MedicineVos copyWith({  String? baseUnitid,
  int? wmOnceDosage,
  String? freq,
  String? packageUnitid,
  String? amt,
  String? specification,
  String? useType,
  String? baseUnitidDictText,
  String? medicineName,
  String? packageUnitidDictText,
  int? medicineNum,
  String? freqDictText,
  String? manuname,
  String? dayNum,
  String? useTypeDictText,
  int? id,
  String? remarks,
}) => MedicineVos(  baseUnitid: baseUnitid ?? _baseUnitid,
  wmOnceDosage: wmOnceDosage ?? _wmOnceDosage,
  freq: freq ?? _freq,
  packageUnitid: packageUnitid ?? _packageUnitid,
  amt: amt ?? _amt,
  specification: specification ?? _specification,
  useType: useType ?? _useType,
  baseUnitidDictText: baseUnitidDictText ?? _baseUnitidDictText,
  medicineName: medicineName ?? _medicineName,
  packageUnitidDictText: packageUnitidDictText ?? _packageUnitidDictText,
  medicineNum: medicineNum ?? _medicineNum,
  freqDictText: freqDictText ?? _freqDictText,
  manuname: manuname ?? _manuname,
  dayNum: dayNum ?? _dayNum,
  useTypeDictText: useTypeDictText ?? _useTypeDictText,
  id: id ?? _id,
  remarks: remarks ?? _remarks,
);
  String? get baseUnitid => _baseUnitid;
  int? get wmOnceDosage => _wmOnceDosage;
  String? get freq => _freq;
  String? get packageUnitid => _packageUnitid;
  String? get amt => _amt;
  String? get specification => _specification;
  String? get useType => _useType;
  String? get baseUnitidDictText => _baseUnitidDictText;
  String? get medicineName => _medicineName;
  String? get packageUnitidDictText => _packageUnitidDictText;
  int? get medicineNum => _medicineNum;
  String? get freqDictText => _freqDictText;
  String? get manuname => _manuname;
  String? get dayNum => _dayNum;
  String? get useTypeDictText => _useTypeDictText;
  int? get id => _id;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['baseUnitid'] = _baseUnitid;
    map['wmOnceDosage'] = _wmOnceDosage;
    map['freq'] = _freq;
    map['packageUnitid'] = _packageUnitid;
    map['amt'] = _amt;
    map['specification'] = _specification;
    map['useType'] = _useType;
    map['baseUnitid_dictText'] = _baseUnitidDictText;
    map['medicineName'] = _medicineName;
    map['packageUnitid_dictText'] = _packageUnitidDictText;
    map['medicineNum'] = _medicineNum;
    map['freq_dictText'] = _freqDictText;
    map['manuname'] = _manuname;
    map['dayNum'] = _dayNum;
    map['useType_dictText'] = _useTypeDictText;
    map['id'] = _id;
    map['remarks'] = _remarks;
    return map;
  }

}