import 'package:flutter/material.dart';
import 'user.dart';
import 'trip.dart';
import 'pay.dart';
import 'balance.dart';

class UserMain extends StatefulWidget {
  final String username;
  const UserMain({
    Key key,
    @required this.username,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<UserMain> {
  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    list
      ..add(UserScreen(username: widget.username))
      ..add(PayScreen(username: widget.username, healthcode: 2,))
      ..add(BalanceScreen())
      ..add(TripScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'User',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.payment,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'Pay',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'Balance',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.trip_origin,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'Trip',
                style: TextStyle(color: _bottomNavigationColor),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}