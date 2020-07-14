import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_plugin_qrcode/flutter_plugin_qrcode.dart';

import '../../main.dart';

class QRView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final String username;
  final int healthcode;

  const QRView({Key key, this.animationController, this.animation, this.username, this.healthcode})
      : super(key: key);

  Future<void> getQrcodeState() async {
    String qrcode;
    try {
      qrcode = await FlutterPluginQrcode.getQRCode;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }
    print(qrcode);
  }

//  @override
//  Widget build(BuildContext context) {
//
//    Color health_color;
//    if(this.healthcode == 2){
//      health_color = Colors.red;
//    }
//    else if(this.healthcode == 1){
//      health_color = Colors.amber;
//    }
//    else{
//      health_color = Colors.green;
//    }
//
//    return AnimatedBuilder(
//      animation: animationController,
//      builder: (BuildContext context, Widget child) {
//        return FadeTransition(
//          opacity: animation,
//          child: new Transform(
//            transform: new Matrix4.translationValues(
//                0.0, 30 * (1.0 - animation.value), 0.0),
//            child: Column(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(
//                      left: 24, right: 24, top: 24, bottom: 24),
//                  child: Stack(
//                    overflow: Overflow.visible,
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.only(top: 16, bottom: 16),
//                        child: Container(
//                          decoration: BoxDecoration(
//                            color: AppTheme.white,
//                            borderRadius: BorderRadius.only(
//                                topLeft: Radius.circular(8.0),
//                                bottomLeft: Radius.circular(8.0),
//                                bottomRight: Radius.circular(8.0),
//                                topRight: Radius.circular(8.0)),
//                            boxShadow: <BoxShadow>[
//                              BoxShadow(
//                                  color: AppTheme.grey.withOpacity(0.4),
//                                  offset: Offset(1.1, 1.1),
//                                  blurRadius: 10.0),
//                            ],
//                          ),
//                          child: Material(
//                            color: Colors.transparent,
//                            child: InkWell(
//                              focusColor: Colors.transparent,
//                              highlightColor: Colors.transparent,
//                              hoverColor: Colors.transparent,
//                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//                              splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
//                              onTap: () {},
//                              child: Padding(
//                                padding:
//                                const EdgeInsets.only(left: 16, right: 16,bottom: 64, top: 64),
//                                child:
//                                Container(
//                                  child: Center(
//                                      child:
//                                      QrImage(
//                                        data: '${this.username},${this.healthcode}',
//                                        size: 250,
//                                        gapless: true,
//                                        errorCorrectionLevel: QrErrorCorrectLevel.Q,
//                                        foregroundColor: health_color,
//                                      )
//
//                                  ),
//
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                      Positioned(
//                        top: -16,
//                        left: 0,
//                        child: SizedBox(
//                          width: 110,
//                          height: 110,
//                          //child: Image,
//                        ),
//
//                      )
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }

  @override
  Widget build(BuildContext context){
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Payee'),
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
      body: new Container(
          alignment: Alignment.center,
          child: new Container(
            child: new RaisedButton(
                padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), //padding
                child: new Text(
                  'Start to scan',
                  style: new TextStyle(
                    fontSize: 18.0, //textsize
                    color: Colors.white,// textcolor
                  ),
                ),
                color: Theme.of(context).accentColor,
                elevation: 4.0,  //shadow
                splashColor: Colors.blueGrey,
                onPressed: () {
                  //click event: start to scan
                  getQrcodeState();
                }
            ),
          )),
    );
  }
}



