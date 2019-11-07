import 'package:flutter/material.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/utils/month_util.dart';
import 'package:movie_finder/widgets/custom_widgets/review_score.dart';

import '../../icon_text.dart';

class EntryCardPanelUpcoming extends StatelessWidget {
  final MovieEntry movie;

  EntryCardPanelUpcoming({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, ),
        child: IconText(
            text: movie.releaseDate != null ? DateUtil.formatToShort(movie.releaseDate) : "Planned",
          color: Colors.blue,
          icon: Icons.date_range,
          iconSize: 20,
          iconPadding: 4,
        ));
  }
}
