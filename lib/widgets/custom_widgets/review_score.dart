import 'package:flutter/material.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

/// Shows the entry review score
class ReviewScore extends StatelessWidget {
  final double score;

  ReviewScore(this.score);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 33,
        padding: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
//        color: _getRatingColor(),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: _getRatingColor())),
//        radius: 15,
//        backgroundColor: _getRatingColor(),
        child: Text(
          score == 0.0 ? "tbd" : score.toString(),
          style: TextStyle(
            color: _getRatingColor(),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ));
  }

  Color _getRatingColor() {
    if (score > 7)
      return Colors.green;
    else if (score > 4)
      return Colors.amber;
    else if (score > 0) return Colors.red;

    return Colors.grey;
  }

  Color _getTextColor(BuildContext context) {
    var themeBrightness = Theme.of(context).brightness;
    return themeBrightness == Brightness.light ? Colors.black : Colors.white;
  }
}
