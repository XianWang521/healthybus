import 'package:flutter/services.dart';

import 'ui_view/qr_view.dart';
import 'package:flutter/material.dart';
import '../logout.dart';
import '../app_theme.dart';
import 'ui_view/notice_view.dart';
import 'package:barcode_scan/barcode_scan.dart';


class PayScreen extends StatefulWidget {
  const PayScreen({Key key, this.animationController, this.username, this.healthcode}) : super(key: key);

  final String username;
  final int healthcode;
  final AnimationController animationController;
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  String barcode = "";

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }



  void addAllListData() {
    const int count = 3;

    listViews.add(
      NoticeView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        healthcode: widget.healthcode,
      ),
    );

    listViews.add(
      QRView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        username: widget.username,
        healthcode: widget.healthcode,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
//  String barcode = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
//    return FutureBuilder<bool>(
//      future: getData(),
//      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//        if (!snapshot.hasData) {
//          return const SizedBox();
//        } else {
//          return ListView.builder(
//            controller: scrollController,
//            padding: EdgeInsets.only(
//              top: AppBar().preferredSize.height +
//                  MediaQuery.of(context).padding.top +
//                  24,
//              bottom: 62 + MediaQuery.of(context).padding.bottom,
//            ),
//            itemCount: listViews.length,
//            scrollDirection: Axis.vertical,
//            itemBuilder: (BuildContext context, int index) {
//              widget.animationController.forward();
//              return listViews[index];
//            },
//          );
//        }
//      },
//    );
    return Scaffold(
        appBar: new AppBar(
          title: new Text('QR Code Scanner'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')
                ),
              )
              ,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center,),
              )
              ,
            ],
          ),
        ));

  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }


  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Scan',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              //height: 50,
                              //width: 50,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    Logout.logout(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 38,
                                          width: 26,
                                        ),
                                        Text(
                                          "Log out",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                            color: AppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 38,
                                          width: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
