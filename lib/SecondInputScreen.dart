import 'package:flutter/material.dart';
import 'package:tipcalculator/ContinueButton.dart';
import 'package:tipcalculator/InfoInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'Diner.dart';
import 'Meal.dart';
import 'popUpInput.dart';
import 'main.dart';
import 'ResultScreen.dart';

// The 2nd input screen
class SecondInputScreen extends StatefulWidget {
  final Meal _meal;

  SecondInputScreen(this._meal);
  @override
  _SecondInputScreenState createState() => _SecondInputScreenState();
}

class _SecondInputScreenState extends State<SecondInputScreen> {
  @override
  Widget build(BuildContext context) {
    widget._meal.updateFunction(refresh);
    return Scaffold(
      appBar: AppBar(
        title: Text('Next, add the diner\'s info'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: ListView(
                children: dinersWithButton(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ButtonTheme(
                  minWidth: 220,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Text('Calculate!'),
                    onPressed: () {
                      if (differenceMsg().length == 0) {
                        // Checks to make sure diners' prices add up to full total of meal
                        widget._meal.checkTotalPrices(widget._meal.sumOfTotalPrices());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ResultScreen(widget._meal)));
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Prices do not match"),
                                content: Text(differenceMsg() +
                                    '\n\nCheck to that the subtotal and prices for diner\'s items are correct.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Content for the alert dialog that will pop up when the subtotal of a meal
  // does not match the sum of the diners' orders
  String differenceMsg() {
    if ((widget._meal.sumOfItems() - widget._meal.subTotal).abs() < 0.00001) {
      return "";
    } else {
      double dif = (widget._meal.sumOfItems() - widget._meal.subTotal).abs();
      if (widget._meal.sumOfItems() > widget._meal.subTotal) {
        return "The sum of all diners' meals are" +
            " \$" +
            dif.toStringAsFixed(2) +
            " more than the SubTotal!";
      } else {
        return "The sum of all diners' meals are" +
            " \$" +
            dif.toStringAsFixed(2) +
            " less than the SubTotal!";
      }
    }
  }

  // adds an addButton widget to the list of diner widgets
  List<Widget> dinersWithButton() {
    List<Widget> ans = widget._meal.buildAllDinerInputs();
    ans.add(addButton());
    return ans;
  }

  // upon press triggers an alert dialog to allow the adding of a diner's info
  Widget addButton() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: SizedBox(),
        ),
        Expanded(
          flex: 10,
          child: RaisedButton(
            child: Text('Add Diner'),
            onPressed: () {
              widget._meal.addDiner();
              int i = widget._meal.diners.length - 1;
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add Diner\'s name and Items"),
                      content: PopUpInput(widget._meal.diners[i]),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                            widget._meal.diners.removeLast();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              widget._meal.diners[i].updateSum();
                              widget._meal.updateTotal();
                              // Updates finalPrice for the Diners
                              widget._meal.updateTotalPrice();
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: SizedBox(),
        ),
      ],
    );
  }

  // Allows for the redrawing of this page upon modification of child elements,
  // like deleting
  void refresh() {
    setState(() {});
  }
}
