import 'package:challange_nextar/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NativeDialog {
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmButtonText,
    VoidCallback? onConfirm,
  }) async {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmButtonText),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmButtonText),
                  ),
                ],
              );
      },
    );
  }

  static Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmButtonText,
    required String cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel();
                    },
                    child: Text(cancelButtonText),
                  ),
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmButtonText),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel();
                    },
                    child: Text(
                      cancelButtonText,
                      style: const TextStyle(color: AppColors.vermelhoPadrao),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(confirmButtonText),
                  ),
                ],
              );
      },
    );
  }
}
