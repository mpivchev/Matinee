import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/utils/month_util.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/shared/entry_card_panel.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_dialog.dart';

import '../icon_text.dart';
import '../review_score.dart';
import '../watchlist_button.dart';

class MovieItem extends StatelessWidget {
  final MovieEntry movie;

  MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StatusBar.setDarkTinted();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsPage(
                      id: movie.id,
                      posterUrl: Constants.mediaUrlW500 + movie.posterPath,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _showPoster(),
              _showInfo(),
              WatchlistButton(
                watchlistInfo: movie.watchlistInfo,
                upcoming: movie.upcoming,
                padding: EdgeInsets.all(8),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showPoster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
            image: movie.posterPath != null
                ? DecorationImage(
                    image: new CachedNetworkImageProvider(
                      Constants.mediaUrlW300 + movie.posterPath,
                    ),
                    fit: BoxFit.fitHeight,
                  )
                : AssetImage("assets/broken_picture.png")),
        width: 80,
      ),
    );
  }

  Widget _showInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              movie.title,
              style: TextStyle(fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: <Widget>[_showReleaseDate()],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ReviewScore(movie.voteAverage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showReleaseDate() {
    if (movie.upcoming) {
      return IconText(
        text: movie.releaseDate != null
            ? DateUtil.formatToShort(movie.releaseDate)
            : "Planned",
        color: Colors.blue,
        icon: Icons.date_range,
        iconSize: 20,
        iconPadding: 4,
      );
    } else {
      return Text(movie.releaseDate.year.toString());
    }
  }
}
