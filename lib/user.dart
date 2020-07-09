import 'package:flutter/material.dart';
import 'main.dart';

class UserScreen extends StatelessWidget{
  final String username;
  const UserScreen({
    Key key,
    @required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('User Info'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
            child: new FlatButton(
              child: new Text(
                "Log out",
                style: new TextStyle(color: Colors.grey, fontSize: 17),
              ),
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => new HomeScreen()
                    ), (route) => route == null);
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
                'Hi! ${this.username}',
                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
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