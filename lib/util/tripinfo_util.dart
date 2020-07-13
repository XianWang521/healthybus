import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'Sp_util.dart';
import 'server_util.dart';
import 'toast_util.dart';
class Post {
  final String id_car;
  final int turn;
  final DateTime date;

  const Post({this.id_car, this.turn, this.date});
}

class tripInfo{
  String id_car;
  DateTime date;
  int turn;
  String phone;
  String password;
  List<Post> posts= [];

  void initget(context) async{
    if (SpUtil.preferences.containsKey("phone")&&SpUtil.preferences.containsKey("password")){
      this.phone = SpUtil.preferences.getString("phone");
      this.password = SpUtil.preferences.getString("password");

        var dio = Dio();
      dio.options.baseUrl = Server.base;
      var cookieJar = CookieJar();
      dio.interceptors..add(LogInterceptor())..add(CookieManager(cookieJar));

      try {
        Response response = await dio.post("/passenger_login", data: {"phone":this.phone, "password":this.password});
        if (response.data["msg"] == "login success"){
          response = await dio.get("/get_trip");
          if(response.data['info'].length != 0) {
            for (int i = 0; i < response.data['info'].length; i++) {
              posts.add(Post(id_car: response.data['info'][i].id_car,
                  turn: response.data['info'][i].turn,
                  date: response.data['info'][i].date));
            }
            print(response);
          }
        }
      } catch (e) {
        ToastUtil.toast(context, "网络连接错误");
      }
    }
  }

  List<Post> getPosts() {
    return this.posts;
  }
}