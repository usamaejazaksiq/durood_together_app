import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final Widget? head1;
  final Widget? head2;
  final double? head2Padding;
  final double? topHeight;
  final bool? background;
  final Widget? lowerBody;
  final bool? homeResize;

  const MyScaffold({
    Key? key,
    this.backgroundColor,
    required this.body,
    this.floatingActionButton,
    this.head1,
    this.head2,
    this.head2Padding,
    this.topHeight,
    this.background,
    this.lowerBody,
    this.homeResize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBackgroundGradient(context),
        Visibility(
          visible: background ?? false,
          child: buildBackgroundImage(),
        ),
        buildScaffold(),
      ],
    );
  }

  Column buildScaffold() {
    return Column(
      children: [
        SizedBox(
          height: topHeight ?? 10,
        ),
        Expanded(
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: homeResize,
              backgroundColor: backgroundColor ?? Constants.appTransparent,
              body: Column(
                children: [
                  head1 ?? Container(),
                  buildHeaderWidget(),
                  body,
                ],
              ),
              floatingActionButton: floatingActionButton,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeaderWidget() {
    return Visibility(
      visible: head2 != null,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Constants.appPrimaryColor.withOpacity(0.2),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(head2Padding ?? 0),
                  child: head2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        "images/header-image.png",
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      ),
    );
  }

  ShaderMask buildBackgroundGradient(context) {
    return ShaderMask(
      blendMode: BlendMode.darken,
      shaderCallback: (Rect bounds) => const LinearGradient(
        colors: [
          Constants.appPrimaryContrastColorLight,
          Constants.appPrimaryContrastColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.3, 1.0],
      ).createShader(bounds),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
