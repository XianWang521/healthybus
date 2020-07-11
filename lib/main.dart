import 'package:flutter/material.dart';
import 'usermain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'util/toast_util.dart';
import 'util/server_util.dart';
import 'login.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      theme: new ThemeData(
        primaryColor: Colors.grey,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var phone;
  var autoLogin = 0;

  //判断自动登录
  Future _validLogin() async{
    Auto_login().then((value){
      if(value!=null){
        setState(() {
          autoLogin = 1;
          phone = value;
        });
      }else{
        setState(() {
          autoLogin = 2;
        });
      }
    });
  }

  //异步自动登录
  Future<dynamic> Auto_login() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("phone")&&prefs.containsKey("password")){
      String ph = prefs.getString("phone");
      String pwd = prefs.getString("password");
      if(ph!=null && pwd!=null){
        Dio dio = new Dio();
        dio.options.baseUrl = Server.base;
        try {
          Response response = await dio.post("/passenger_login", data: {"phone":ph, "password":pwd});
          print(response.data["msg"]);
          if (response.data["msg"] == "login success"){
            return ph;
          }
        } catch (e) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx and is also not 304.
          ToastUtil.toast(context, "网络连接错误");
          return null;
        }
      }
    }
    prefs.clear();
    return null;
  }



  @override
  void initState() {
    super.initState();
    _validLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (autoLogin==1){
      return UserMain(username: phone);//自动登录到用户界面
    }else if(autoLogin==2){//跳转登录界面
      return Login();
    }
    return Scaffold(//等待界面
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,);
  }

}