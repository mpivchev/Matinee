import 'package:flutter/material.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';
import 'package:movie_finder/utils/month_util.dart';
import 'package:movie_finder/widgets/custom_widgets/review_score.dart';

import '../../icon_text.dart';

class EntryCardPanel extends StatelessWidget {
//  final MovieEntry movie;
  final String title;
  final bool upcoming;
  final DateTime releaseDate;
  final double voteAverage;

  EntryCardPanel.fromMovie({@required MovieEntry movie})
      : title = movie.title,
        upcoming = movie.upcoming,
        releaseDate = movie.releaseDate,
        voteAverage = movie.voteAverage;

  EntryCardPanel.fromShow({@required ShowEntry show})
      : title = show.title,
        upcoming = show.upcoming,
        releaseDate = show.releaseDate,
        voteAverage = show.voteAverage;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _showTitle(),
              upcoming ? _showUpcomingText() : _showInfo(),
            ]));
//        child: upcoming ? _showUpcomingText() : _showInfo());
  }

  Widget _showTitle() {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _showUpcomingText() {
    return IconText(
      text: releaseDate != null
          ? DateUtil.formatToShort(releaseDate)
          : "Planned",
      color: Colors.blue,
      icon: Icons.date_range,
      iconSize: 20,
      iconPadding: 4,
    );
  }

  Widget _showInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(releaseDate.year.toString(),
            style: TextStyle(color: Colors.white)),
        ReviewScore(voteAverage)
      ],
    );
  }
}
