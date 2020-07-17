import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RowInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 11,
            child: Text('Diner\'s name:'),
          ),
          Expanded(
            flex: 20,
            child: Text('Price of Diner\'s Items:'),
          ),
          Expanded(
            flex: 8,
            child: Text('Subtotal:'),
          ),
          Expanded(
            flex: 8,
            child: Text('Total:'),
          )
        ],
      ),
    );
  }
}
