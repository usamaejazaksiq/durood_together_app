import 'package:flutter/material.dart';

class MohrWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? home;
  final bool? splash;
  final Widget child;

  const MohrWidget(
      {Key? key,
      this.home,
      required this.child,
      this.height,
      this.width,
      this.splash})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = splash ?? false
        ? "images/islahenafs-logo-complete.png"
        : home ?? false
            ? "images/logo_islaenafs.png"
            : "images/logo-empty.png";
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            height: height ?? 200.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "images/light-background.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: width ?? 175.0,
            height: height ?? 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
