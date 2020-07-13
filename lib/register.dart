import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
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
                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              new SizedBox(
                height: 70,
              ),
              new TextField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
              new SizedBox(
                height: 30,
              ),
              new TextField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: new InputDecoration(
                  labelText: "Verification Code",
                  suffix: new GestureDetector(
                    onTap: (){
                      if (countdownTime==0){
                        startCountdown();
                      }
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
                  child: new Text("Sign up",
                      style: new TextStyle(color: Colors.white)),
                  color: Colors.black,
                  elevation: 15.0,
                  shape: StadiumBorder(),
                  splashColor: Colors.white54,
                  onPressed: () {},
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

