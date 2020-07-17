import 'package:flutter/cupertino.dart';

import 'Diner.dart';
import 'package:flutter/material.dart';

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
            flex: 2,
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    child: Text("Add Item"),
                    onPressed: () {
                      setState(() {
                        if (widget._diner.listOfItems.last
                                .getItem()
                                .controller
                                .text !=
                            "") {
                          widget._diner.addItem();
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    child: Text("Remove Item"),
                    onPressed: () {
                      setState(() {
                        widget._diner.removeItem();
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
