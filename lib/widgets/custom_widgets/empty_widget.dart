import 'package:flutter/material.dart';

/// A widget that shows absolutely nothing
/// 
/// Should be used as a placeholder widget
class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0,);
  }
}