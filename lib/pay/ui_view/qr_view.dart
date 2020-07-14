import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../util/passengetInfo_util.dart';

class QRView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final String username;
  final int healthcode;

  const QRView({Key key, this.animationController, this.animation, this.username, this.healthcode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color health_color;
    if(this.healthcode == 2){
      health_color = Colors.red;
    }
    else if(this.healthcode == 1){
      health_color = Colors.amber;
    }
    else{
      health_color = Colors.green;
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 24, bottom: 24),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                              onTap: () {},
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 16, right: 16,bottom: 64, top: 64),
                                child:
                                Container(
                                  child: Center(
                                      child:
                                      passengerInfo().getBalance()>=2&&passengerInfo().getHealthcode()==0?
                                      QrImage(
                                        data: '${this.username},${this.healthcode}',
                                        size: 250,
                                        gapless: true,
                                        errorCorrectionLevel: QrErrorCorrectLevel.Q,
                                        foregroundColor: health_color,
                                      ):(
                                        passengerInfo().getHealthcode()!=0?
                                        SizedBox(
                                            width: 400,
                                            height: 100,
                                            child: healthcode==2?Text(
                                              "             Warning\n            Unhealthy!",
                                              style: new TextStyle(color: Color.fromARGB(255, 246, 82, 131), fontSize: 32, fontWeight: FontWeight.w800),
                                            ):Text(
                                              "        Health status\n       to be observed",
                                              style: new TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.w800),
                                            )
                                        ):
                                        SizedBox(
                                            width: 400,
                                            height: 100,
                                            child: Text(
                                              "           Insufficient\n             Balance!",
                                              style: new TextStyle(color: Color.fromARGB(255, 246, 82, 131), fontSize: 32, fontWeight: FontWeight.w800),
                                            )
                                        )
                                      ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -16,
                        left: 0,
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          //child: Image,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
