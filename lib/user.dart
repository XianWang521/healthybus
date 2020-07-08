import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserMain extends StatefulWidget {
  @override
  _UserMain createState() => _UserMain();
}

class _UserMain extends State<UserMain> {
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
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        ),
      ),
    );
  }
}