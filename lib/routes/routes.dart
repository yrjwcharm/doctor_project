
import '../pages/login/changePas.dart';
import '../pages/login/JumpToVideoList.dart';
import '../pages/login/login.dart';
import '../pages/login/register.dart';
import '../pages/login/register_success.dart';
import '../pages/tabs/main.dart';

final routes={

  '/loginP':(context)=>LoginPage(),
  '/register':(context)=>RegisterContent(),
  '/registerSuccess':(context)=>RegisterSuccessHomeConent(),
  '/changePas':(context)=>changePas(),
  '/JumpToVideoList':(context)=>const MyHomePage(title: ''),
  '/TabHome':(context)=>const Main(),

};