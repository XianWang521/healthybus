import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'dart:math';
import 'package:dio/dio.dart';
import 'util/toast_util.dart';
import 'util/server_util.dart';
import 'util/Sp_util.dart';
import 'usermain.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {

  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //验证码的控制器
  TextEditingController vericodeController = TextEditingController();

  //用户名的控制器
  TextEditingController usernameController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

  //二次密码的控制器
  TextEditingController passagainController = TextEditingController();

  // 加载进度条
  Container loadingDialog;

  // 显示加载进度条
  showLoadingDialog() {
    setState(() {
      loadingDialog = new Container(
          constraints: BoxConstraints.expand(),
          color: AppTheme.background,
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

  int nonce;

  //获取随机N位数
  int _randomBit(int len) {
    String scopeF = "123456789";//首位
    String scopeC = "0123456789";//中间
    String result = "";
    for (int i = 0; i < len; i++) {
      if (i == 1) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return int.parse(result);
  }

  //发送验证码
  void getcode() async {
    if (phoneController.text.length != 11) {
      ToastUtil.toast(context, "请输入11位手机号码");
    } else {
      if (countdownTime==0){
        startCountdown();
      }
      Dio dio = new Dio();
      dio.options.baseUrl = Server.base;
      try {
        print(phoneController.text);
        nonce = _randomBit(10);
        Response response = await dio.post("/get_code", data: {"phone":phoneController.text, "nonce":nonce});
        print(response.data.toString());
        if (response.data["status"] == "ok") {
          String msg = response.data["msg"];
          print(msg);
          if (msg == "code is sent") {
            print(response.data["code"]);
          }else{
            ToastUtil.toast(context, "发送验证码错误");
          }
        } else {
          ToastUtil.toast(context, "发送验证码错误");
        }
      } catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        ToastUtil.toast(context, "网络连接错误");
      } finally {
      }
    }
  }

  //注册
  void _register() async {
    if (phoneController.text.length != 11) {
      ToastUtil.toast(context, "请输入11位手机号码");
    } else if (vericodeController.text.length == 0) {
      ToastUtil.toast(context, "验证码不能为空");
    } else if (usernameController.text.length == 0) {
      ToastUtil.toast(context, "用户名不能为空");
    } else if (passController.text.length == 0) {
      ToastUtil.toast(context, "密码不能为空");
    } else if (passagainController.text.length == 0) {
      ToastUtil.toast(context, "请再次输入密码");
    } else if (passagainController.text != passController.text) {
      ToastUtil.toast(context, "请保证两次密码相同");
    } else {
      showLoadingDialog();
      Dio dio = new Dio();
      dio.options.baseUrl = Server.base;
      var cookieJar = CookieJar();
      dio.interceptors..add(LogInterceptor())..add(CookieManager(cookieJar));
      try {
        print(phoneController.text);
        print(vericodeController.text);
        print(usernameController.text);
        print(passController.text);
        Response response = await dio.post("/passenger_register", data: {"phone":phoneController.text, "username":usernameController.text,"password":passController.text,"nonce":nonce,"health":0,"code":vericodeController.text});
        print(response.data.toString());
        if (response.data["status"] == "ok") {
          String msg = response.data["msg"];
          print(msg);
          if (msg == "register success") {
            response = await dio.post("/passenger_login", data: {"phone":phoneController.text, "password":passController.text});
            if (response.data["msg"] == "login success"){
              response = await dio.get("/get_info");
              SpUtil.preferences.setString("phone", phoneController.text);
              SpUtil.preferences.setString("password", passController.text);
              SpUtil.preferences.setString("username", usernameController.text);
              SpUtil.preferences.setDouble("balance", response.data["info"][2]);
              SpUtil.preferences.setInt("healthcode", response.data["info"][3]);
              SpUtil.preferences.setString("id_pay", response.data["info"][4]);
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => new UserMain(username: SpUtil.preferences.getString("username"))
                  ), (route) => route == null);
            }
            else {
              ToastUtil.toast(context, "登录错误");
            }
          }else{
            ToastUtil.toast(context, "未知错误");
          }
        } else {
          String msg = response.data["msg"];
          print(msg);
          if (msg == "database error") {
            ToastUtil.toast(context, "账号已注册");
          } else if (msg == "wrong code") {
            ToastUtil.toast(context, "验证码错误");
          }
          else{
            ToastUtil.toast(context, "未知错误");
          }
        }
      } catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        ToastUtil.toast(context, "网络连接错误");
      } finally {
        hideLoadingDialog();
      }
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

  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 0;

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
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
              child: new Text("Log In",
                style: new TextStyle(color: Colors.grey, fontSize: 17),),
              onPressed: (){
                Navigator.pop(context);
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
                "Sign up",
                style: new TextStyle(color:AppTheme.nearlyDarkBlue
                    .withOpacity(0.8),fontSize: 25, fontWeight: FontWeight.w800),
              ),
              new SizedBox(
                height: 40,
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
                controller: vericodeController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Verification Code",
                  suffix: new GestureDetector(
                    onTap: (){
                      getcode();
                    },
                    child: Text(
                      countdownTime>0?"Try again in ${countdownTime}s":"Send",
                      style: TextStyle(
                          color: Colors.grey//Color.fromRGBO(21, 201, 187, 1)
                      ),
                    ),
                  )
                ),
              ),
              new SizedBox(
                height: 30,
              ),
              new TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Username",
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
              new TextField(
                controller: passagainController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Password again",
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
                  child: new Text("Sign up",
                      style: new TextStyle(color: Colors.white)),
                  color: AppTheme.nearlyDarkBlue
                      .withOpacity(0.6),
                  elevation: 15.0,
                  shape: StadiumBorder(),
                  splashColor: Colors.white54,
                  onPressed: () {
                    _register();
                  },
                ),
              ),
              new SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

}

