import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getWaitingDialog({required BuildContext context, bool? circular}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return circular ?? true
            ? Center(
                child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).indicatorColor),
              ))
            : Center(
                child: LinearProgressIndicator(
                  color: Theme.of(context).indicatorColor,
                ),
              );
      });
}

getDialog({
  required Widget title,
  required Widget content,
  required String closeText,
  String? okText,
  VoidCallback? okOnPressed,
  bool? barrierDismissible,
  required BuildContext context,
}) {
  if (Platform.isIOS) {
    getCupertinoDialog(
      closeWidget: TextButton(
        child: Text(closeText),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      context: context,
      content: content,
      title: title,
      okWidget: Visibility(
        visible: okText != null,
        child: TextButton(
          child: Text(okText ?? ""),
          onPressed: okOnPressed,
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  } else {
    getMaterialDialog(
      closeWidget: TextButton(
        child: Text(
          closeText,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      context: context,
      content: content,
      title: title,
      okWidget: Visibility(
        visible: okText != null,
        child: TextButton(
          child: Text(
            okText ?? "",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          onPressed: okOnPressed,
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}

getMaterialDialog({
  required Widget title,
  required Widget content,
  required Widget closeWidget,
  Widget? okWidget,
  bool? barrierDismissible,
  required BuildContext context,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: title,
          content: content,
          actions: <Widget>[
            closeWidget,
            Visibility(
              visible: okWidget != null,
              child: okWidget ?? Container(),
            ),
          ],
        );
      });
}

getCupertinoDialog({
  required Widget title,
  required Widget content,
  required Widget closeWidget,
  Widget? okWidget,
  bool? barrierDismissible,
  required BuildContext context,
}) {
  showDialog(
      barrierDismissible: barrierDismissible ?? true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            Visibility(
              visible: okWidget != null,
              child: okWidget ?? Container(),
            ),
            closeWidget,
          ],
        );
      });
}
