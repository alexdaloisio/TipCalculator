import 'package:flutter/material.dart';
import 'package:tipcalculator/InfoInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'Diner.dart';
import 'Meal.dart';
import 'RowInfo.dart';
import 'popUpInput.dart';
import 'FirstInputScreen.dart';

//TODO: Decide if prices should update when the sum diners orders are wrong
//TODO: add fail safe to ensure that all of the orders were inputted

//TODO: go to dart color schemes (find the website from the lessons) to find one for this app
//TODO: make things look nice after functionality is done
/*
void main() {
  runApp(
    MaterialApp(
      //home: TipCalc(),
      home: TipCalc(),
    ),
  );
}
*/

void main() {
  runApp(
    MaterialApp(
      //home: TipCalc(),
      home: FirstInputScreen(),
    ),
  );
}

class TipCalc extends StatefulWidget {
  final Meal meal;

  TipCalc(this.meal);

  @override
  _TipCalcState createState() => _TipCalcState();
}

class _TipCalcState extends State<TipCalc> {
  // Two default Diners
  Meal meal;
  @override
  Widget build(BuildContext context) {
    meal = widget.meal;
    //meal.updateFunction(refresh);
    meal.updateDeleteFunction(deleteEntry);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Splitter'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: ListView(
                //padding: const EdgeInsets.all(0),
                children: dinersWithButton(),
              ),
            ),
            Text(
              differenceMsg(),
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              //Need this otherwise Listview and the row interacts strangely
              height: 0,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text(roundText()), //TODO: add rounding/unrounding
                  onPressed: () {
                    setState(() {
                      meal.isRounded = !meal.isRounded;
                      if (meal.isRounded) {
                        //Ask user what they want to do
                        meal.updateTotalPrice();
                      } else {
                        meal.updateTotalPrice();
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('Share Bill'),
                  onPressed: () {
                    //TODO: add an alert that prevents user from sharing if the diners meals are not equal to the subtotal
                    String shareText = this.buildShareText();
                    Share.share(shareText);
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('Total: \$' +
                    meal.fullTotal.toStringAsFixed(
                        2)), //TODO this total is not equal to diners' total
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> dinersWithButton() {
    var ans = meal.buildAllDiners();
    ans.add(addButton());
    return ans;
  }

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
              meal.addDiner();
              int i = meal.diners.length - 1;
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add Diner\'s name and Items"),
                      content: PopUpInput(meal.diners[i]),
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
                              meal.diners[i].updateSum();
                              meal.updateTotal();
                              // Updates finalPrice for the Diners
                              meal.updateTotalPrice();
                              Navigator.of(context).pop();
                              refresh.call();
                            });
                          },
                        )
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

  //This allows child widgets to update this state
  refresh() {
    setState(() {});
  }

  //Gets text for rounded/unrounded button
  String roundText() {
    if (meal.isRounded) {
      return 'Unround';
    }

    return 'Round';
  }

  //Will delete an entry from the list of diners
  deleteEntry(Diner i) {
    setState(() {
      meal.diners.remove(i);
    });
  }

  String buildShareText() {
    String res = "";
    int num = 1;

    for (Diner din in meal.diners) {
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

  String differenceMsg() {
    if ((meal.sumOfItems() - meal.subTotal).abs() < 0.00001 ||
        meal.subTotal == 0) {
      return "";
    } else {
      double dif = (meal.sumOfItems() - meal.subTotal).abs();
      if (meal.sumOfItems() > meal.subTotal) {
        return "Diner's meals are" +
            " \$" +
            dif.toStringAsFixed(2) +
            " more than the SubTotal!";
      } else {
        return "Diner's meals are" +
            " \$" +
            dif.toStringAsFixed(2) +
            " less than the SubTotal!";
      }
    }
  }
}

//TODO Tired of your friends making you pay for their expensive drinks?
// TODO Try app name!!!!
