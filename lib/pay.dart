import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'main.dart';

class PayScreen extends StatelessWidget{
  final String username;
  final int healthcode;
  const PayScreen({
    Key key,
    @required this.username,
    @required this.healthcode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    Color c;
    if(this.healthcode == 2){
      c = Colors.red;
    }
    else if(this.healthcode == 1){
      c = Colors.yellow;
    }
    else{
      c = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Center(
            child:
              QrImage(
                data: '${this.username},${this.healthcode}',
                size: 250,
                gapless: true,
                errorCorrectionLevel: QrErrorCorrectLevel.Q,
                foregroundColor: c,
              )
          ),
        ),
      ),
    );
  }
}