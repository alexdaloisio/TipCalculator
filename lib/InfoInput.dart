import 'package:flutter/material.dart';
import 'package:tipcalculator/Meal.dart';
import 'Diner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Widgets for the input fields for subtotal tax and tip
class InfoInput extends StatefulWidget {
  final String _hint;
  final TextEditingController _controller;
  final Meal _meal;
  final Function _updateParent;

  InfoInput(this._hint, this._controller, this._meal, this._updateParent);

  @override
  _InfoInputState createState() => _InfoInputState();
}

// Uses the "hint" to make the change in the correct field in the meal object
class _InfoInputState extends State<InfoInput> {
  @override
  Widget build(BuildContext context) {
    String label = widget._hint + ': \$';
    String prefix = '\$ ';
    String suffix = '';
    // Special case for tiprate
    if (widget._hint.compareTo('Tip Rate (ex: 20%)') == 0) {
      label = 'Tip Rate :  ';
      prefix = '';
      suffix = '%';
    }

    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: widget._controller,
              decoration: InputDecoration(
                hintText: '  ' + widget._hint,
                prefixText: prefix,
                suffixText: suffix,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: label.substring(0, label.length - 1),
                labelStyle: TextStyle(
                  fontSize: 17,
                ),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter(
                  RegExp("[0-9.]"),
                ),
              ],
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              onChanged: (String val) {
                setState(() {
                  //Make the proper field 0 if it should be
                  if (widget._controller.text == "") {
                    widget._meal.updateOneOfThree(widget._hint, 0);
                  } else {
                    // Update the correct field of meal
                    widget._meal.updateOneOfThree(
                        widget._hint, double.parse(widget._controller.text));
                  }
                  widget._meal.updateTotal();

                  // make sure that parent is rebuilt
                  widget._updateParent.call();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
