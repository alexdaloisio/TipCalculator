import 'package:flutter/material.dart';

// Button to progress to the next page
class ContinueButton extends StatelessWidget {
  final Widget destination;
  final String text;

  ContinueButton(this.destination, this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: ButtonTheme(
          minWidth: 220,
          height: 40,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Text(text),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => destination));
            },
          ),
        ),
      ),
    );
  }
}
