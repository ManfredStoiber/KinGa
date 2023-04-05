import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(50),
        width: 75,
        child: const FittedBox(
            child: CircularProgressIndicator()
        ),
      ),
    );
  }
}
