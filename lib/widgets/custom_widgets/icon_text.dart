import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

/// Shows the entry review score
class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double iconSize;
  final double iconPadding;

  IconText(
      {@required this.icon,
      @required this.text,
      @required this.color,
      this.iconSize = 25,
      this.iconPadding = Constants.spacingSmall});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: iconSize,
        ),
        Padding(
          padding: EdgeInsets.only(left: iconPadding),
          child: Text(text, style: TextStyle(color: color)),
        ),
      ],
    );
  }
}
