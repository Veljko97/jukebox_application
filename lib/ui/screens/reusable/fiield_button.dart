import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  final Function() onCLick;
  final Widget centerWidget;
  final String text;
  final Color colorFill;

  FilledButton({this.onCLick, this.centerWidget, this.text, this.colorFill});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        onCLick();
      },
      color: colorFill,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: centerWidget != null ? centerWidget : Text(text),
      ),
    );
  }
}
