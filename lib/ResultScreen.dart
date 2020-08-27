import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'Diner.dart';
import 'Meal.dart';

// Final screen that shows how much diners owe
class ResultScreen extends StatefulWidget {
  final Meal _meal;

  ResultScreen(this._meal);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isRounded = false;
  double roundedDif = 0;
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
                width: 400,
                height: 370,
                child: ListView(
                  children: widget._meal.buildAllDinerResults(),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 240,
              child: roundedWidget(),
            ),
            RaisedButton(
              child: Text(isRounded? 'Unround' : 'Round'),
              onPressed: () {
                setState(() {
                  if (isRounded) {
                    widget._meal.updateTotalPrice();
                    roundedDif = 0;

                  }

                  else {
                    roundedDif = widget._meal.updateRoundedPrices();

                  }
                    isRounded = !isRounded;
                });
              },
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

  // This Widget will show a message in the case of rounding that will
  // describe how much over or under the total price the rounding has resulted in
  Widget roundedWidget() {
    String msg ='';
    String msg2= '';
    if (!isRounded || roundedDif == 0) {
      return SizedBox();
    }
    else {
      if (roundedDif < 0) {
        msg = 'ADD';
        msg2 = 'to';
      }

      else {
        msg = 'SUBTRACT';
        msg2 = 'from';
      }
  }
  double absDif = roundedDif.abs();
  return Card(
  child: Column(
  children: <Widget>[
  Text('In order to account for rounding '),
  Text(msg + ' $absDif'),
  Text(msg2 + ' one Diner\'s total ')
  ],
  ));
}


  // This function builds the share text for the entire meal
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

    if (isRounded) {
      String msg = '';
      String msg2 = '';
      if (roundedDif < 0) {
        msg = 'ADD';
        msg2 = 'to';
      }

      else {
        msg = 'SUBTRACT';
        msg2 = 'from';
      }
      double absDif = roundedDif.abs();
      res+= 'In order to account for rounding \n ' + msg + ' $absDif\n' + msg2 + ' one Diner\'s total \n';
    }
    res +=
        'Calculated by mealspliter'; //TODO add actual name of app and link to app (but ios or android?)
    return res;
  }
}
