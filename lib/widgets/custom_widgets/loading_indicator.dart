import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double height;

  LoadingIndicator({this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 60,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
    );
  }
}
