import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/shared/entry_card_panel.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/shared/entry_card_panel_upcoming.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_dialog.dart';

import '../watchlist_button.dart';

/// A card version of [EntryItem] used in the [HomePage]
class EntryItemCard extends StatelessWidget {
//  final MovieEntry movie;
  final int id;
  final String title;
  final String posterPath;
  final bool upcoming;
  final WatchlistEntryInfo watchlistInfo;

  final Widget cardPanel;

//  static const double cardHeight = 259;
//  static const double cardWidth = 115;

  EntryItemCard.fromMovie({@required MovieEntry movie})
      : id = movie.id,
        title = movie.title,
        posterPath = movie.posterPath,
        upcoming = movie.upcoming,
        watchlistInfo = movie.watchlistInfo,
        cardPanel = EntryCardPanel.fromMovie(
          movie: movie,
        );

  EntryItemCard.fromShow({@required ShowEntry show})
      : id = show.id,
        title = show.title,
        posterPath = show.posterPath,
        upcoming = show.upcoming,
        watchlistInfo = show.watchlistInfo,
        cardPanel = EntryCardPanel.fromShow(
          show: show,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StatusBar.setDarkTinted();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsPage(
                      id: id,
                      posterUrl: Constants.mediaUrlW500 + posterPath,
                    )));
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.spacingVerySmall),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            color: Colors.black87,
            child: Column(
              children: <Widget>[_showPoster(), _showBottomBar()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showPoster() {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: posterPath != null
                ? CachedNetworkImageProvider(
                    Constants.mediaUrlW500 + posterPath,
                  )
                : AssetImage("assets/broken_picture.png"),
            fit: BoxFit.cover,
          )),
          width: Constants.entryCardWidth,
          height: 173,
        ),
        Container(
          color: Colors.black87,
          child: WatchlistButton(
            watchlistInfo: watchlistInfo,
            upcoming: upcoming,
          ),
        )
      ],
    );
  }

  Widget _showBottomBar() {
    return Container(
        width: 114,
        height: 86,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: cardPanel);
  }
}
