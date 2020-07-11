/*
import 'package:flutter/material.dart';
import 'user.dart';
import 'trip.dart';
import 'pay.dart';
import 'balance.dart';
import 'util/passengerInfo_util.dart';

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
      ..add(UserScreen())
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

 */
import 'package:flutter/material.dart';
import 'user.dart';
import 'trip.dart';
import 'pay.dart';
import 'balance.dart';
import 'util/passengerInfo_util.dart';

class UserMain extends StatefulWidget {
  final String username;
  const UserMain({
    Key key,
    @required this.username,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<UserMain> with TickerProviderStateMixin{
  AnimationController animationController;
  final _bottomNavigationColor = Color.fromARGB(255, 78, 70, 216);
  int _currentIndex = 0;
  List<int> list = List();
  Widget tabBody = Container(
    color: Colors.white,
  );

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    tabBody = UserScreen(animationController: animationController);
    list = [0,1,2,3];
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Stack(
              children: <Widget>[
                tabBody,
              ],
            );
          }
        },
      ),
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
          animationController.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              _currentIndex = index;
              if (index == 0){
                tabBody = UserScreen(animationController: animationController);
              }else if(index == 1){
                tabBody = PayScreen(username: widget.username, healthcode: 2,);
              }else if(index == 2){
                tabBody = BalanceScreen();
              }else{
                tabBody = TripScreen();
              }
            });
          });
        },
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 600));
    return true;
  }
}