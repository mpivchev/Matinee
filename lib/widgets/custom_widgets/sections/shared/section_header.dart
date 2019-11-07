import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;

  SectionHeader(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Text(text, textAlign: TextAlign.left, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }
}