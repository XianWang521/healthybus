import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'server_util.dart';
import 'toast_util.dart';

class passengerInfo{
  String phone;
  String username;
  String password;
  double balance;
  int health;
  String id_pay;

  void get(context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("phone")&&prefs.containsKey("password")){
      this.phone = prefs.getString("phone");
      this.password = prefs.getString("password");

      var dio = Dio();
      dio.options.baseUrl = Server.base;
      var cookieJar = CookieJar();
      dio.interceptors..add(LogInterceptor())..add(CookieManager(cookieJar));
      try {
        Response response = await dio.post("/passenger_login", data: {"phone":this.phone, "password":this.password});
        if (response.data["msg"] == "login success"){
          response = await dio.get("/get_info");
          print(response.data["info"]);
        }
      } catch (e) {
        ToastUtil.toast(context, "网络连接错误");
      }
    }
  }
}