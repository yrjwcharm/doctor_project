
import 'package:doctor_project/pages/login/regist_success.dart';
import '../pages/login/login.dart';
import '../pages/login/register.dart';
import '../pages/tabs/main.dart';
import '../pages/home/chat_room.dart';


final routes={

  '/loginP':(context)=>LoginPage(),
  '/register':(context)=>RegisterContent(),
  // '/registerSuccess':(context)=> const RegisterSuccess(),
  '/TabHome':(context)=>const Main(),
  '/chatRoom':(context)=> const ChatRoom(),
};