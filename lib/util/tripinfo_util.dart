import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'Sp_util.dart';
import 'server_util.dart';
import 'toast_util.dart';
class Post {
  final String id_car;
  final String turn;
  final String date;

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
          print(response);
          if(response.data['info'].length != 0 && response.data['msg'] != "bad request") {
            for (int i = 0; i < response.data['info'].length; i++) {
              posts.add(Post(id_car: response.data['info'][i].id_car,
                  turn: response.data['info'][i].turn.toString(),
                  date: response.data['info'].date.year.toString()+'年'+response.data['info'].date.month.toString()+'月'+
                      response.data['info'].date.day.toString()+'日' +response.data['info'].date.hour.toString()+'点'+
                      response.data['info'].date.minute.toString()+'分'+response.data['info'].date.second.toString()+'秒'));
            }
            print(response);
          }
          else{
            posts.add(Post(id_car: 'N/A',
                turn: 'N/A',
                date: 'N/A'));
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