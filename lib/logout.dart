import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/Sp_util.dart';
import 'main.dart';

class Logout {
  static void logout(context) async {
    SpUtil.preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new HomeScreen()
        ), (route) => route == null);
  }
}