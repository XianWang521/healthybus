import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'usermain.dart';
import 'package:dio/dio.dart';
import 'util/toast_util.dart';
import 'util/server_util.dart';

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

  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

  // 加载进度条
  Container loadingDialog;

  // 显示加载进度条
  showLoadingDialog() {
    setState(() {
      loadingDialog = new Container(
          constraints: BoxConstraints.expand(),
          color: Color(0x80000000),
          child: new Center(
            child: new CircularProgressIndicator(),
          ));
    });
  }

  // 隐藏加载进度条
  hideLoadingDialog() {
    setState(() {
      loadingDialog = new Container();
    });
  }

  void login() async {
    if (phoneController.text.length != 11) {
      ToastUtil.toast(context, "请输入11位手机号码");
    } else if (passController.text.length == 0) {
      ToastUtil.toast(context, "密码不能为空");
    } else {
      showLoadingDialog();
      Dio dio = new Dio();
      dio.options.baseUrl = Server.base;
      try {
        print(phoneController.text);
        print(passController.text);
        Response response = await dio.post("/passenger_login", data: {"phone":phoneController.text, "password":passController.text});
        print(response.data.toString());
        if (response.data["status"] == "ok") {
          String msg = response.data["msg"];
          print(msg);
          if (msg == "login success") {
            //SharedPreferences sp = await SharedPreferences.getInstance();
            //sp.setString("token", token);
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new UserMain(username: phoneController.text)
                ), (route) => route == null);
          }else{
            ToastUtil.toast(context, "登录失败");
          }
        } else {
          ToastUtil.toast(context, "账号或密码错误");
        }
      } catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        ToastUtil.toast(context, "网络连接错误");
      } finally {
        hideLoadingDialog();
      }
//      phoneController.clear();
//      passController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    hideLoadingDialog();
  }

  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
            child: new FlatButton(
              child: new Text(
                "Sign up",
                style: new TextStyle(color: Colors.grey, fontSize: 17),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              highlightColor: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(
                "Log in",
                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              new SizedBox(
                height: 70,
              ),
              new TextField(
                controller: phoneController,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,//只能输入数字
                  LengthLimitingTextInputFormatter(11)//11位
                ],
                keyboardType: TextInputType.number,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
              new SizedBox(
                height: 30,
              ),
              new TextField(
                controller: passController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Password",
                  suffixIcon: new GestureDetector(
                    child: new Icon(
                      Icons.remove_red_eye,
                    ),
                    onTap: _toggle,
                  ),
                ),
                obscureText: eye,
              ),
              new SizedBox(
                height: 30,
              ),
              new SizedBox(
                height: 50,
                child: new RaisedButton(
                  child: new Text("Log in",
                      style: new TextStyle(color: Colors.white)),
                  color: Colors.black,
                  elevation: 15.0,
                  shape: StadiumBorder(),
                  splashColor: Colors.white54,
                  onPressed: () {
                    login();
                  },
                ),
              ),
              new SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

}