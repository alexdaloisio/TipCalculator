import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'ItemInput.dart';
import 'Diner.dart';

// Choices for the Options button
enum Options {Add,Duplicate,Remove}

// This is will be the contents of the alert dialogs that are used for
// adding diners or editing diners
class PopUpInput extends StatefulWidget {
  final Diner _diner;

  PopUpInput(this._diner);

  @override
  _PopUpInputState createState() => _PopUpInputState();
}

class _PopUpInputState extends State<PopUpInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
              controller: widget._diner.nameController,
              onChanged: (String val) {
                widget._diner.name = widget._diner.nameController.text;
              },
            ),
          ),
          SizedBox(
            width: 2,
            height: 10,
          ),
          SizedBox(
            width: 300,
            height: 100,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 200,
                // Need to use a lambda function to dynamically change the size of this box
                height: () {
                  return widget._diner.listOfItems.length * 50.0;
                }.call(),
                child: Column(
                  children: widget._diner.listOfItems,
                ),
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: PopupMenuButton(
                child: Row(
                 children: <Widget>[
                   DecoratedBox(child: Padding(
                     padding: EdgeInsets.all(6),
                       child: Text('Options',
                       style: TextStyle(
                         fontSize: 16,
                       ),)),
                     decoration: BoxDecoration(
                       color: Colors.grey,
                     ),
                   ),
                 ],
                ),
                onSelected: (Options choice) {
                  if (choice == Options.Add) {
                    add();
                  } else if (choice == Options.Remove) {
                    remove();
                  }
                  else {
                    duplicateItemPopUp(widget._diner,context);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<Options>>[
                    PopupMenuItem(
                      value: Options.Add,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add),
                          VerticalDivider(),
                          Text('Add Item')
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Options.Duplicate,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add),
                          VerticalDivider(),
                          Text('Add Duplicate Item')
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Options.Remove,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete),
                          VerticalDivider(),
                          Text('Remove Item')
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Adds a new item field if the latest one has content entered in it
  void add() {
    setState(() {
      if(widget._diner.listOfItems.length > 0) {
        if (widget._diner.listOfItems.last
            .getItem()
            .controller
            .text !=
            "") {
          widget._diner.addItem();
        }
      }
      else {
        widget._diner.addItem();
      }
    });
  }

  // remove the most recently added item
  void remove() {
      setState(() {
        widget._diner.removeItem();
      });
  }

  // Creates a pop up to add duplicate items
  void duplicateItemPopUp(Diner diner, BuildContext context) {
    TextEditingController numController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Repeated Item"),
            content: duplicateItemBody(numController,priceController),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
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
                    if(numController.text != null && priceController.text != null) {
                      double num = double.tryParse(numController.text);
                      double price = double.tryParse(priceController.text);
                      if (num != null && price != null) {
                        double share = price / num;
                        TextEditingController controller = TextEditingController();
                        controller.text = share.toStringAsFixed(2);
                        widget._diner.addItemThatExists(Item.extra(controller));
                      }
                    }
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  // This function handles the body of the duplicate item Pop up
  Widget duplicateItemBody(TextEditingController numController, TextEditingController priceController) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: <Widget>[
          Text('Many receipts put duplicate entries on the same line, use this to add them without needed to do math'),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Text('Quantity of Item:'),
                SizedBox(
                  width: 4,
                ),
                Flexible(
                  flex: 1,
                  child: TextField(
                      autofocus: false,
                      decoration: InputDecoration.collapsed(hintText: "Quantity"),
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true, signed: false),
                      controller: numController,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                          RegExp("[0-9.]"),
                        ),
                      ],
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Text('Price of all Items of this kind:'),
                SizedBox(
                  width: 4,
                ),
                Flexible(
                  flex: 1,
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration.collapsed(hintText: "Price"),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true, signed: false),
                    controller: priceController,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp("[0-9.]"),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
