import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kinga/constants/strings.dart';

class Error extends StatelessWidget {
  const Error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child:
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: const EdgeInsets.all(30), width: 200, child: Opacity(opacity: 0.7, child: Image.asset('assets/images/error.png'.replaceAll("/", Platform.pathSeparator)))),
          Text(Strings.errorOccurred, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54), textAlign: TextAlign.center,),
          Container(margin: const EdgeInsets.all(20), child: Text(Strings.errorOccurredDescription, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54), textAlign: TextAlign.center,)),
        ],
      )
    );
  }
}
