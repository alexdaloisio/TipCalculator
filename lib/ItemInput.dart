import 'Diner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ItemInput extends StatefulWidget {
  final Item _item;

  ItemInput(this._item);

  Item getItem() {
    return _item;
  }

  _ItemInputState createState() => _ItemInputState();
}

class _ItemInputState extends State<ItemInput> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextField(
          autofocus: false,
          decoration: InputDecoration.collapsed(hintText: "Price of item"),
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: false),
          controller: widget._item.controller,
          inputFormatters: [
            WhitelistingTextInputFormatter(
              RegExp("[0-9.]"),
            ),
          ],
          onChanged: (String val) {}),
    );
  }
}

class Item {
  TextEditingController controller = TextEditingController();
}
