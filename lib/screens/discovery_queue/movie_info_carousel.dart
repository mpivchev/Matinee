import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/firestore/local_watchlist_ids_cache_bloc.dart';
import 'package:movie_finder/bloc/firestore/local_watchlist_ids_cache_state.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_button.dart';

class MovieInfoCarousel extends StatefulWidget {
  final List<MovieEntry> movies;

  const MovieInfoCarousel({@required this.movies});

  @override
  _MovieInfoCarouselState createState() => _MovieInfoCarouselState();
}

class _MovieInfoCarouselState extends State<MovieInfoCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var movie = widget.movies[currentIndex];

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            size: 50,
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image(
                      height: 200,
                      image: new CachedNetworkImageProvider(
                          Constants.mediaUrlW500 + movie.posterPath)),
//              child: MovieItemCard.regular(movie: movieEntry),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movie.overview),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _showWatchlistButton(movie),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              currentIndex++;
            });
          },
          child: Icon(
            Icons.arrow_forward_ios,
            size: 50,
          ),
        ),
      ],
    );
  }

  //TODO: make it a separate WatchlistButton widget
  Widget _showWatchlistButton(MovieEntry movie) {
    final firestoreEntryIdsCacheBloc =
        BlocProvider.of<LocalWatchlistIdsCacheBloc>(context);

    return BlocBuilder(
        bloc: firestoreEntryIdsCacheBloc,
        builder: (context, LocalWatchlistIdsCacheState state) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: _getWatchlistButtonBorderColor(
                        state, movie.watchlistInfo))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                WatchlistButton(
                  watchlistInfo: movie.watchlistInfo,
                  upcoming: movie.upcoming,
                ),
                Text(_getWatchlistButtonText(state, movie.watchlistInfo))
              ],
            ),
          );
        });
  }

  String _getWatchlistButtonText(WatchlistEntryIdsAvailable state, WatchlistEntryInfo watchlistInfo) {
    String text = "Add to Watchlist";

    if (state is WatchlistEntryIdsAvailable) {
      if (state.isEntryInLiked(watchlistInfo)) {
        text = "Added to Liked";
      } else if (state.isEntryInWatched(watchlistInfo)) {
        text = "Added to Watched";
      } else if (state.isEntryInToWatch(watchlistInfo)) {
        text = "Added to To Watch";
      }
    }

    return text;
  }


  Color _getWatchlistButtonBorderColor(
      WatchlistEntryIdsAvailable state, WatchlistEntryInfo watchlistInfo) {
    Color color = Colors.grey;

    if (state is WatchlistEntryIdsAvailable) {
      if (state.isEntryInLiked(watchlistInfo)) {
        color = Colors.red;
      } else if (state.isEntryInWatched(watchlistInfo)) {
        color = Colors.yellow;
      } else if (state.isEntryInToWatch(watchlistInfo)) {
        color = Colors.green;
      }
    }

    return color;
  }
}
