import 'package:flutter/material.dart';
import 'package:tipcalculator/ContinueButton.dart';
import 'package:tipcalculator/InfoInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'Diner.dart';
import 'Meal.dart';

import 'popUpInput.dart';
import 'main.dart';
import 'SecondInputScreen.dart';

void main() {
  runApp(
    MaterialApp(
      //home: TipCalc(),
      home: FirstInputScreen(),
    ),
  );
}

// First input screen that allows for the input of subtotal, tax and tip rate
class FirstInputScreen extends StatefulWidget {
  @override
  _FirstInputScreenState createState() => _FirstInputScreenState();
}

class _FirstInputScreenState extends State<FirstInputScreen> {
  Meal meal = Meal.fresh(<Diner>[]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First, enter the following"),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 200,
              child: Column(
                children: <Widget>[
                  InfoInput('Subtotal', meal.subTotalController, meal, refresh),
                  InfoInput('Tax', meal.taxController, meal, refresh),
                  InfoInput('Tip Rate (ex: 20%)', meal.tipRateController, meal,
                      refresh),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Total: \$' + meal.fullTotal.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ContinueButton(SecondInputScreen(meal), 'Continue')
          ],
        ),
      ),
    );
  }

  // Redraws the first input screen
  void refresh() {
    setState(() {});
  }
}
