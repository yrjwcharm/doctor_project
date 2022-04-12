class Api {
  static const BASE_URL = 'https://interhospital.youjiankang.net';
  static const dataDicUrl ='/doctor/dr-service/baDatadictDetail/getDatadictDetail';
  static const createPrescriptionUrl = "/doctor/dr-service/recipe/create"; //新建西药处方
  static const pharmacyListUrl = "/doctor/dr-service/pharmacy/getList"; //获取药房列表
  static const writeCaseUrl = "/doctor/dr-service/case/write"; //写病历
  static const userSignatureUrl = "/doctor/dr-service/buYxq/userSignature"; //医信签 电子签名
  static const YXQSignDataUrl = "/doctor/dr-service/buYxq/signData"; //医信签 提交数据电子签名
  static const prescriptionDetailUrl = "/doctor/dr-service/recipe/queryByRegisterId"; //查看中医处方、西医处方
  static const patientInfoUrl = "/doctor/dr-service/patient/get"; //获取患者信息
  static const getReceiveConsultList= "/doctor/dr-service/register/getList" ; //获取接诊列表
  static const getReceiveConsultCount = "/doctor/dr-service/register/getCount"; //获取接诊与待接诊数量
  static const getReceiveConsultApi = '/doctor/dr-service/register/receive';
  static const createRoomApi= '/doctor/dr-service/order-room/open';
  static const getToken = '/doctor/dr-service/order-room/getToken';
}
