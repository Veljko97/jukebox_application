import 'package:flutter/material.dart';

class CustomProgressIndicator {

  static void showProgress(GlobalKey<State> progressKey, BuildContext context) {
    if(progressKey.currentContext != null){
      if (Navigator.of(progressKey.currentContext, rootNavigator: false).canPop()) {
        return;
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => Column(
        key: progressKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }

  static void removeProgress(GlobalKey<State> progressKey) {
    if(progressKey.currentContext != null) {
      Navigator.of(progressKey.currentContext, rootNavigator: false).pop();
    }
  }
}
