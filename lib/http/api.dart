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
  static const getPatientDetailApi = "/doctor/dr-service/patient/getDetail";//获取患者详情
  static const finishTopicApi = "/doctor/dr-service/register/finish";
  static const cnDrugInventoryApi = "/doctor/dr-service/herbalMedicine/getStock";
  static const westernDrugInventoryApi = "/doctor/dr-service/medicine/getStock";
  static const eastDrugInventoryApi = "/doctor/dr-service/herbalMedicine/getStock";
  static const uploadImgApi = "/doctor/dr-service/order-room/cos/upload?key=ih";
  static const updateAvatar = "/doctor/dr-service/ba-doctor-user/uploadAvatar";
  static const saveChatRecordApi = "/doctor/dr-service/order-room/record/save";
  static const getRecordListApi = "/doctor/dr-service/order-room/record/list";
  static const getRpListApi = "/doctor/dr-service/recipe/getList";
  static const getDictListApi = "/doctor/dr-service/register/getList";//接诊列表
  static const getRegisterOrderInfoDetail = "/doctor/dr-service/register/getRegisterOrderInfoDetail";//问诊订单详情
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
  static const getCommonWordsTemplateApi ='/doctor/dr-service/template/getCommonWords';
  static const getCommonDiagnosisTemplateApi ='/doctor/dr-service/template/getDiagnoses';
  static const  addCommonWordsListApi='/doctor/dr-service/template/addCommonWord';
  static const updateCommonWordsApi='/doctor/dr-service/template/editCommonWord';
  static const delTemplateApi = '/doctor/dr-service/template/delete';
  static const insertDoctorTimeService = '/doctor/dr-service/baDoctorTime/insertDoctorTimeService';
  static const serviceByDocIdAndState = '/doctor/dr-service/baDoctorTime/selectDoctorTimeServiceByDocIdAndState';
  static const updateDoctorTimeService = '/doctor/dr-service/baDoctorTime/updateDoctorTimeService';
  static const checkDetailByTreatId = '/doctor/dr-service/baDoctorTime/checkDetailByTreatId';
  static const checkUpdateDetail= '/doctor/dr-service/baDoctorTime/updateDetail';
  static const checkInsertDetail= '/doctor/dr-service/baDoctorTime/insertDetail';
  static const getNoticeByPlatform = '/patient/pt-service/baNotice/getNoticeByPlatform';
  static const getRecipes = '/doctor/dr-service/template/getRecipes';//查询处方模版
  static const addOrEditRecipe ='/dr-service/template/addOrEditRecipe';//新增修改处方模版
  static const deleteTemplate = '/doctor/dr-service/template/delete';//删除模板
  static const getAllDepartment = '/doctor/dr-service/baDepartment/getAllDepartment';//显示医院所有科室基本信息

}
