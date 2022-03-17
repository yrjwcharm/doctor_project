
import '../pages/login/changePas.dart';
import '../pages/login/setPassword.dart';
import '../pages/login/JumpToVideoList.dart';
import '../pages/login/login.dart';
import '../pages/login/register.dart';
import '../pages/login/register_success.dart';
import '../pages/tabs/main.dart';

final routes={

  '/loginP':(context)=>HomeContent(),
  '/register':(context)=>RegisterContent(),
  '/registerSuccess':(context)=>RegisterSuccessHomeConent(),
  '/setPassword':(context)=>settingContent(),
  '/changePas':(context)=>changePas(),
  '/JumpToVideoList':(context)=>MyHomePage(title: ''),
  '/TabHome':(context)=>Main(),

};