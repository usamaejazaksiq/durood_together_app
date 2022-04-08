import 'package:flutter/material.dart';

class ScrollableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double width;
  final bool? reverse;

  const ScrollableText(this.text,
      {Key? key, this.style, required this.width, this.reverse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: width,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        reverse: reverse??false,
        child: Text(
          text,
          maxLines: 1,
          style: style,
        ),
      ),
    );
  }
}
