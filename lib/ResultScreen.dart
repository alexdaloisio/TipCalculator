import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tipcalculator/ContinueButton.dart';
import 'package:tipcalculator/InfoInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'Diner.dart';
import 'Meal.dart';
import 'RowInfo.dart';
import 'popUpInput.dart';
import 'main.dart';

class ResultScreen extends StatefulWidget {
  final Meal _meal;

  ResultScreen(this._meal);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results:'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: SizedBox(
                width: 300,
                height: 350,
                child: ListView(
                  children: widget._meal.buildAllDinerResults(),
                ),
              ),
            ),
            RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Share Total Bill'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.share),
                ],
              ),
              onPressed: () {
                String shareText = this.buildShareText();
                Share.share(shareText);
              },
            ),
          ],
        ),
      ),
    );
  }

  String buildShareText() {
    String res = "";
    int num = 1;

    for (Diner din in widget._meal.diners) {
      String name = din.name;
      if (din.name.compareTo('') == 0) {
        name = 'Diner ' + '$num';
        num++;
      }
      res += name + ': \$' + din.totalPrice.toStringAsFixed(2) + '\n';
    }
    res +=
        'Calculated by mealspliter'; //TODO add actual name of app and link to app (but ios or android?)
    return res;
  }
}
