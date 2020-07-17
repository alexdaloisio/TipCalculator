import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'Meal.dart';
import "ItemInput.dart";
import 'popUpInput.dart';

enum Options { Edit, Delete, Share }

class DinerRowInput extends StatefulWidget {
  final Diner _diner;
  final Meal _meal;

  DinerRowInput(this._diner, this._meal);

  @override
  _DinerRowInputState createState() => _DinerRowInputState();
}

class _DinerRowInputState extends State<DinerRowInput> {
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

  void delete() {
    //widget._deleteDiner.call(widget._diner);

    widget._meal.diners.remove(widget._diner);
    widget._meal.updateParent.call();
  }

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
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              share();
            },
          )
        ],
      ),
    );
  }

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

class DinerRow extends StatefulWidget {
  final Diner _diner;
  final Meal _meal;
  final Function _updateParent;
  final Function _deleteDiner;

  DinerRow(this._diner, this._meal, this._updateParent, this._deleteDiner);
  //TODO: Need to adjust sizes of fields, on phone does not appear correctly

  @override
  _DinerRowState createState() => _DinerRowState();
}

//TODO I really  need to make the input fields nicer
class _DinerRowState extends State<DinerRow> {
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
                    widget._updateParent.call();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  void delete() {
    //widget._deleteDiner.call(widget._diner);
    widget._meal.diners.remove(widget._diner);
    widget._updateParent.call();
  }

  void share() {
    double price = widget._diner.totalPrice;
    if (widget._diner.name.length == 0) {
      Share.share('You owe \$$price');
    } else {
      String name = widget._diner.name;
      Share.share(name + ', you owe \$$price');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text(widget._diner.name),
          Text('  Sum of Order:  ' +
              '\$' +
              widget._diner.sumOfItems.toStringAsFixed(2)),
          Text('  Total Owed:  ' +
              '\$' +
              widget._diner.totalPrice.toStringAsFixed(2)),
          Spacer(),
          PopupMenuButton(
            onSelected: (Options choice) {
              if (choice == Options.Edit) {
                edit();
              } else if (choice == Options.Delete) {
                delete();
              } else if (choice == Options.Share) {
                share();
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
}

// Class for one Diner (Horizontal row)
class Diner {
  String name;
  String items;
  double sumOfItems;
  double totalPrice;
  TextEditingController nameController = TextEditingController();

  List<ItemInput> listOfItems = <ItemInput>[ItemInput(Item())];

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

  //Removes an Item from the list of items
  void removeItem() {
    if (this.listOfItems.length > 1) {
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
