import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'Meal.dart';
import "ItemInput.dart";
import 'popUpInput.dart';

// Options for the pop up menu
enum Options { Edit, Delete, Share }

// Class that creates the Diner rows on the 2nd page, (used for inputting diner
// values and viewing them before continuing to the final page
class DinerRowInput extends StatefulWidget {
  final Diner _diner;
  final Meal _meal;

  DinerRowInput(this._diner, this._meal);

  @override
  _DinerRowInputState createState() => _DinerRowInputState();
}

class _DinerRowInputState extends State<DinerRowInput> {
  // Creates an alert dialog that allows the editing of previous diner inputs
  void edit() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Diner\'s name and Items"),
            content: PopUpInput(widget._diner),
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
                    widget._diner.updateSum();
                    widget._meal.updateTotalPrice();
                    widget._meal.updateTotal();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  // Deletes the selected diner
  void delete() {
    widget._meal.diners.remove(widget._diner);
    widget._meal.updateParent.call();
  }

  // Builds the diner row input itself (on the 2nd page)
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text('Name: ' + widget._diner.name + '   '),
          Text('  Sum of Order:  ' +
              '\$' +
              widget._diner.sumOfItems.toStringAsFixed(2)),
          Spacer(),
          PopupMenuButton(
            onSelected: (Options choice) {
              if (choice == Options.Edit) {
                edit();
              } else if (choice == Options.Delete) {
                delete();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<Options>>[
                PopupMenuItem(
                  value: Options.Edit,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.edit),
                      VerticalDivider(),
                      Text('Edit')
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: Options.Delete,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      VerticalDivider(),
                      Text('Delete')
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

// Builds the diner row results on the third page
class DinerRowResult extends StatefulWidget {
  final Diner _diner;

  DinerRowResult(this._diner);

  @override
  _DinerRowResultState createState() => _DinerRowResultState();
}

class _DinerRowResultState extends State<DinerRowResult> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Center(
            child: Text(
              'Total owed by ' +
                  widget._diner.name +
                  ': ' +
                  '\$' +
                  widget._diner.totalPrice.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          Spacer(),
          PopupMenuButton(
            onSelected: (Options choice) {
            share();
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<Options>>[
                PopupMenuItem(
                  value: Options.Share,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.share),
                      VerticalDivider(),
                      Text('Share')
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  // Allows for the sharing of how much an individual diner owes
  void share() {
    double price = widget._diner.totalPrice;
    if (widget._diner.name.length == 0) {
      Share.share('You owe \$$price');
    } else {
      String name = widget._diner.name;
      Share.share(name + ', you owe \$$price');
    }
  }
}

// Class for one Diner (Horizontal row)
class Diner {
  String name;
  String items;
  double sumOfItems;
  double totalPrice;
  TextEditingController nameController = TextEditingController();

  List<ItemInput> listOfItems = <ItemInput>[];

  Diner(String name, String items, double sumOfItems, double totalPrice) {
    this.name = name;
    this.items = items;
    this.sumOfItems = sumOfItems;
    this.totalPrice = totalPrice;
  }

  // Creates a default Diner
  Diner.defaultDiner() {
    this.name = '';
    this.items = '';
    this.sumOfItems = 0;
    this.totalPrice = 0;
  }

  //Adds an Item to the list of items
  void addItem() {
    this.listOfItems.add(ItemInput(Item()));
  }

  void addItemThatExists(Item item) {
    this.listOfItems.add(ItemInput(item));
  }

  //Removes an Item from the list of items
  void removeItem() {
    if (this.listOfItems.length > 0) {
      this.listOfItems.removeLast();
    }
  }

  // Updates sum of Items for a Diner
  void updateSum() {
    this.sumOfItems = 0;
    for (ItemInput ite in listOfItems) {
      if (!(ite.getItem().controller.text == "")) {
        this.sumOfItems += double.parse(ite.getItem().controller.text);
      }
    }
  }
}
