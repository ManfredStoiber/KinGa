import 'package:flutter/material.dart';
import 'package:kinga/constants/strings.dart';

class LoadingIndicatorDialog {

  static void show(context, [title]) {
    showDialog( barrierDismissible: false, context: context, builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: SizedBox(
          height: 100,
          width: 200,
          child: Center(child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CircularProgressIndicator(),
              title == null ? const Text(Strings.loading) : Text(title),
            ],
          ))
        ),
      ),
    ),);
  }
}
