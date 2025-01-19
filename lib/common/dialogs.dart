import 'dart:io';

import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  //for dialogs with one action
  static dialogInform(BuildContext buildContext, String dialogMessage,
      VoidCallback function, String? text,
      {IconData? icon, double? iconSize, Color? iconColor}) {
    return Platform.isAndroid
        ? showDialog(
            context: buildContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: icon != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: iconSize, color: iconColor),
                          const SizedBox(height: 16),
                          TextWidget(
                            text: dialogMessage,
                          ),
                        ],
                      )
                    : TextWidget(
                        text: dialogMessage,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                      ),
                actions: <Widget>[
                  TextButton(
                    child: Center(child: Text(text ?? Strings.ok)),
                    onPressed: () {
                      function.call();
                    },
                  ),
                ],
              );
            },
          )
        : showCupertinoDialog(
            context: buildContext,
            barrierDismissible: false,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  content: icon != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: iconSize, color: iconColor),
                            const SizedBox(height: 16),
                            TextWidget(text: dialogMessage),
                          ],
                        )
                      : TextWidget(text: dialogMessage),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      textStyle: const TextStyle(color: Colors.black),
                      onPressed: () {
                        function.call();
                      },
                      child: Text(text ?? Strings.ok),
                    ),
                  ],
                ));
  }

  static loading(BuildContext context) {
    return Platform.isAndroid
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return const Dialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.thatBrown,
                      ),
                    ],
                  ),
                ),
              );
            })
        : showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => const CupertinoActivityIndicator(
              color: Colors.white,
              radius: 20,
            ),
          );
  }

  static loadingWithMessage(BuildContext context, String message) {
    return Platform.isAndroid
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.thatBrown,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: message,
                      size: 16,
                    )
                  ],
                ),
              );
            })
        : showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CupertinoActivityIndicator(
                    color: AppColors.thatBrown,
                    radius: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: message,
                    size: 16,
                  )
                ],
              ),
            ),
          );
  }

  static Widget loadingInScreen() {
    return Platform.isAndroid
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.thatBrown,
              strokeCap: StrokeCap.round,
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.thatBrown,
              radius: 20,
            ),
          );
  }
}
