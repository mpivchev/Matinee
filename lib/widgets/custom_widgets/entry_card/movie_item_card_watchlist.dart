import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_dialog.dart';

class MovieItemCardWatchlist extends StatelessWidget {
  final WatchlistEntryInfo watchlistInfo;

  MovieItemCardWatchlist({this.watchlistInfo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StatusBar.setDarkTinted();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MovieDetailsPage(
                      id: watchlistInfo.id,
                      posterUrl: Constants.mediaUrlW500 + watchlistInfo.posterPath,
                    )));
      },      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.black87,
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: new CachedNetworkImageProvider(
                  Constants.mediaUrlW500 + watchlistInfo.posterPath,
                ),
                fit: BoxFit.cover,
              )),
              child: _showAddToWatchButton(context)),
        ),
      ),
    );
  }

  Widget _showAddToWatchButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WatchlistDialog(
                    watchlistInfo: watchlistInfo, upcoming: false);
              });
        },
        child: Container(
            color: Colors.black.withOpacity(.8),
            height: 30,
            width: 25,
            child: Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
