import 'package:durood_together_app/AppReserved/helpers.dart';
import 'package:flutter/material.dart';

class FittedRichText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle rankStyle;
  final double? padding;

  const FittedRichText(this.text,
      {Key? key, required this.style, this.padding, required this.rankStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: RichText(
          text: TextSpan(
            text: text,
            style: style,
            children: <TextSpan>[
              TextSpan(
                text: " ${getRankSuffix(text)}",
                style: rankStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
