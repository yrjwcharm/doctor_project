class Api {
  static const BASE_URL = 'https://interhospital.youjiankang.net';
  static const loginApi ='/doctor/dr-service/ba-doctor-user/doLogin';
  static const bindJG = '/doctor/dr-service/jig/bindRid';
  static const sendRpNoticeApi = '/doctor/dr-service/recipe/notice';
  static const dataDicUrl ='/doctor/dr-service/baDatadictDetail/getDatadictDetail';
  static const detailChildDicUrl ='/doctor/dr-service/baDatadictDetail/getDatadictDetailChild';
  static const createPrescriptionUrl = "/doctor/dr-service/recipe/create"; //新建西药处方
  static const pharmacyListUrl = "/doctor/dr-service/pharmacy/getList"; //获取药房列表
  static const writeCaseUrl = "/doctor/dr-service/case/write"; //写病历
  static const queryCaseUrl = "/doctor/dr-service/case/find"; //写病历
  static const userSignatureUrl = "/doctor/dr-service/buYxq/userSignature"; //医信签 电子签名
  static const YXQSignDataUrl = "/doctor/dr-service/buYxq/signData"; //医信签 提交数据电子签名
  static const prescriptionListUrl = "/doctor/dr-service/recipe/queryByRegisterId"; //查看中医处方、西医处方
  static const patientInfoUrl = "/doctor/dr-service/patient/get"; //获取患者信息
  static const getReceiveConsultList= "/doctor/dr-service/register/getList" ; //获取接诊列表
  static const getReceiveConsultCount = "/doctor/dr-service/register/getCount"; //获取接诊与待接诊数量
  static const getReceiveConsultApi = '/doctor/dr-service/register/receive';
  static const refuseReceiveConsultApi = '/doctor/dr-service/register/unReceive';
  static const createRoomApi= '/doctor/dr-service/order-room/open';
  static const getToken = '/doctor/dr-service/order-room/getToken';
  static const signOutUrl = "/doctor/dr-service/ba-doctor-user/doExit"; //退出登录 登出
  static const getDoctorInfoUrl = "/doctor/dr-service/ba-doctor-user/getInfo"; //获取医生信息
  static const getDoctorCode = "/doctor/dr-service/ba-doctor-user/getQrCode"; //获取医生名片
  static const getMessageListApi = "/doctor/dr-service/push/getList"; //获取医生信息
  static const getMyPatientListApi = "/doctor/dr-service/patient/getList"; //获取患者列表
  static const finishTopicApi = "/doctor/dr-service/register/finish";
  static const cnDrugInventoryApi = "/doctor/dr-service/herbalMedicine/getStock";
  static const westernDrugInventoryApi = "/doctor/dr-service/medicine/getStock";
  static const eastDrugInventoryApi = "/doctor/dr-service/herbalMedicine/getStock";
  static const uploadImgApi = "/doctor/dr-service/order-room/cos/upload?key=ih";
  static const updateAvatar = "/doctor/dr-service/ba-doctor-user/uploadAvatar";
  static const saveChatRecordApi = "/doctor/dr-service/order-room/record/save";
  static const getRecordListApi = "/doctor/dr-service/order-room/record/list";
  static const getRpListApi = "/doctor/dr-service/recipe/getList";
  static const getRpDetailApi = "/doctor/dr-service/recipe/queryRecipe";
  static const  revokeRpApi = '/doctor/dr-service/recipe/cancel';
  static const  view360Api =Api.BASE_URL+'/360view/#/';
  static const  startRecordVideo ='/doctor/dr-service/order-room/startVideo';
  static const  stopRecordVideo ='/doctor/dr-service/order-room/stopVideo';
  static const  sendVerifyCode ='/doctor/dr-service/verificationCode/get';
  static const checkVerifyCode ='/doctor/dr-service/verificationCode/check';
  static const updatePwdApi ='/doctor/dr-service/ba-doctor-user/editPwd';
  static const exitLogin ='/doctor/dr-service/ba-doctor-user/doExit';
  static const verifyOldPwdApi ='/doctor/dr-service/ba-doctor-user/validOldPwd';
  static const getPatientIdApi ='/doctor/dr-service/patient/getPaId';


}
