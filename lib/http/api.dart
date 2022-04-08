class Api {
  static const BASE_URL = 'https://interhospital.youjiankang.net';
  static const dataDicUrl ='/doctor/dr-service/baDatadictDetail/getDatadictDetail';
  static const createPrescriptionUrl = "/doctor/dr-service/recipe/create"; //新建西药处方
  static const pharmacyListUrl = "/doctor/dr-service/pharmacy/getList"; //获取药房列表
  static const writeCaseUrl = "/doctor/dr-service/case/write"; //写病历
  static const userSignatureUrl = "/doctor/dr-service/buYxq/userSignature"; //电子签名
  static const prescriptionDetailUrl = "/doctor/dr-service/recipe/queryByRegisterId"; //查看中医处方、西医处方

}
