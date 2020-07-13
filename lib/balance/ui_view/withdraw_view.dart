import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthybus/app_theme.dart';
import 'package:flutter/services.dart';
import '../moneyinput.dart';


class WithDrawScreen extends StatefulWidget {
  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDrawScreen> {

  double distValue = 50.0;

  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new SingleChildScrollView(
                      child: new Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Withdraw here   ",
                                    style: new TextStyle(color: AppTheme.nearlyDarkBlue
                                        .withOpacity(0.8), fontSize: 40, fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Icon(
                                      Icons.account_balance,
                                      color: AppTheme.nearlyDarkBlue
                                          .withOpacity(0.8),
                                      size: 50,
                                    ),
                                  ),
                                ]),
                            new SizedBox(
                              height: 40,
                            ),
                            new TextField(
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                LengthLimitingTextInputFormatter(9),
                                MoneyTextInputFormatter()
                              ],
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              decoration: new InputDecoration(
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: AppTheme.nearlyDarkBlue
                                        .withOpacity(0.5)),
                                labelText: "Price Amount\n",
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                  color: AppTheme.grey),
                            ),
                            new SizedBox(
                              height: 30,
                            ),
                            new TextField(
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              decoration: new InputDecoration(
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: AppTheme.nearlyDarkBlue
                                        .withOpacity(0.5)),
                                labelText: "Payment Password\n",
                                suffixIcon: new GestureDetector(
                                  child: new Icon(
                                    Icons.remove_red_eye,
                                  ),
                                  onTap: _toggle,
                                ),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                  color: AppTheme.grey),
                              obscureText: eye,
                            ),
                            new SizedBox(
                              height: 250,
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*const Divider(
                      height: 1,
                    ),
                    //popularFilter(),
                    const Divider(
                      height: 1,
                    ),
                    //distanceViewUI(),
                    const Divider(
                      height: 1,
                    ),*/
                    //allAccommodationUI()
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.nearlyDarkBlue
                      .withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Withdraw',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
