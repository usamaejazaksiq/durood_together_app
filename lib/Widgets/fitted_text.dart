import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? padding;
  final TextAlign? alignment;
  const FittedText(this.text, {Key? key, this.style, this.padding, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: EdgeInsets.all(padding??0),
        child: Text(
          text,
          textAlign: alignment??TextAlign.center,
          style: style, // Index 0 Contains Name
        ),
      ),
    );
  }
}
