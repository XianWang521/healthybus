import '../../app_theme.dart';
import 'package:flutter/material.dart';

class NoticeView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final int healthcode;

  const NoticeView(
      {Key key,
        this.animationController,
        this.animation,
        this.healthcode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String notice = "";
    Color notice_color;
    double notice_size;
    if(this.healthcode == 2){
      notice = "Sorry, \nyou are not allowed to aboard.";
      notice_color = Colors.red;
      notice_size = 25;
    }
    else if(this.healthcode == 1){
      notice = "Sorry, \nyou are not allowed to aboard.";
      notice_color = Colors.amber;
      notice_size = 25;
    }
    else{
      notice = "Welcome aboard!";
      notice_color = AppTheme.lightText;
      notice_size = 30;
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        notice,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: notice_size,
                          letterSpacing: 0.5,
                          color: notice_color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
