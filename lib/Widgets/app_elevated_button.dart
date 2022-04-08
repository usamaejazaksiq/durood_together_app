import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonText;
  final double? textSize;
  final IconData? icon;
  final Color? buttonColor;
  final Color? textColor;
  final Widget? image;
  final bool? enabled;
  final double? padding;

  const AppElevatedButton({
    Key? key,
    required this.onPressed,
    this.buttonText,
    this.icon,
    this.textSize,
    this.buttonColor,
    this.textColor,
    this.image,
    this.enabled,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: image != null
          ? buildButtonWithImage(context)
          : icon != null && buttonText == null
              ? buildButtonWithIconWithoutText(context)
              : icon != null && buttonText != null
                  ? buildButtonWithIcon(context)
                  : buildButtonWithoutIcon(context),
    );
  }

  Widget buildButtonWithoutIcon(context) {
    return ElevatedButton(
      onPressed: enabled ?? true ? onPressed : null,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
            Constants.appHighlightColor.withOpacity(0.6)),
        alignment: Alignment.center,
        elevation: MaterialStateProperty.all<double>(5.0),
        backgroundColor: MaterialStateProperty.all(
            buttonColor ?? Theme.of(context).primaryColor),
        foregroundColor: MaterialStateProperty.all(
            textColor ?? Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            // side: BorderSide(
            //   color: Theme.of(context).primaryColorDark,
            // ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: Text(
          buttonText ?? "",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: textSize ?? Constants.appHeading4Size,
          ),
        ),
      ),
    );
  }

  Widget buildButtonWithIcon(context) {
    return ElevatedButton.icon(
      onPressed: enabled ?? true ? onPressed : null,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
            Constants.appHighlightColor.withOpacity(0.6)),
        alignment: Alignment.center,
        elevation: MaterialStateProperty.all<double>(5.0),
        backgroundColor: MaterialStateProperty.all(
            buttonColor ?? Theme.of(context).primaryColor),
        foregroundColor: MaterialStateProperty.all(
            textColor ?? Theme.of(context).primaryColorDark),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            // side: BorderSide(
            //   color: Theme.of(context).primaryColorDark,
            // ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      icon: Icon(icon),
      label: buttonText != null || buttonText == ""
          ? Padding(
              padding: EdgeInsets.all(padding ?? 0),
              child: Text(
                buttonText ?? "",
                style: const TextStyle(
                  fontSize: Constants.appHeading4Size,
                ),
              ),
            )
          : Container(),
    );
  }

  Widget buildButtonWithIconWithoutText(context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: enabled ?? true ? onPressed : null,
      overlayColor: MaterialStateProperty.all<Color>(
          Constants.appHighlightColor.withOpacity(0.6)),
      splashColor: Theme.of(context).highlightColor,
      child: Container(
        height: 40,
        width: 40,
        child: Icon(
          icon,
          color: textColor ?? Theme.of(context).primaryColorDark,
        ),
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).primaryColor,
          // border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget buildButtonWithImage(context) {
    return ElevatedButton(
      onPressed: enabled ?? true ? onPressed : null,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
            Constants.appHighlightColor.withOpacity(0.6)),
        alignment: Alignment.center,
        elevation: MaterialStateProperty.all<double>(5.0),
        backgroundColor: MaterialStateProperty.all(
            buttonColor ?? Theme.of(context).primaryColor),
        foregroundColor:
            MaterialStateProperty.all(textColor ?? Constants.appTextGreenColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            // side: BorderSide(
            //   color: Theme.of(context).primaryColorDark,
            // ),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: image,
      ),
    );
  }
}
