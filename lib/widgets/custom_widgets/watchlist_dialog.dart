import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/widgets/animations/slide_up_animation.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';

import 'icon_text.dart';

/// A dialog used for the player to add an entry to watchlist/likes
class WatchlistDialog extends StatelessWidget {
  final WatchlistEntryInfo watchlistInfo;

  // Whether the entry is to be released or not
  final bool upcoming;

  final _watchlistBloc = FirestoreWatchlistBloc();

  WatchlistDialog({this.watchlistInfo, this.upcoming});

  @override
  Widget build(BuildContext context) {
    final firestoreWatchlistCacheBloc =
        BlocProvider.of<LocalWatchlistIdsCacheBloc>(context);

    return BlocBuilder(
        bloc: firestoreWatchlistCacheBloc,
        builder: (context, LocalWatchlistIdsCacheState state) {
          if (state is WatchlistEntryIdsAvailable) {
            return SimpleDialog(
              title: const Text('Add to...'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    if (watchlistInfo.entryType == EntryType.movie) {
                      _watchlistBloc.dispatch(AddMovieToWatch(watchlistInfo));
                      firestoreWatchlistCacheBloc
                          .dispatch(AddMovieIdToWatch(watchlistInfo.id));
                    } else {
                      _watchlistBloc.dispatch(AddShowToWatch(watchlistInfo));
                      firestoreWatchlistCacheBloc
                          .dispatch(AddShowIdToWatch(watchlistInfo.id));
                    }

                    Navigator.pop(context, true);
                  },
                  child: IconText(
                      icon: Icons.watch_later,
                      text: "To watch",
                      color: _getToWatchColor(state)),
                ),
                upcoming
                    ? EmptyWidget()
                    : SimpleDialogOption(
                        onPressed: () {
                          if (watchlistInfo.entryType == EntryType.movie) {
                            _watchlistBloc
                                .dispatch(AddMovieToWatched(watchlistInfo));
                            firestoreWatchlistCacheBloc.dispatch(
                                AddMovieIdToWatched(watchlistInfo.id));
                          } else {
                            _watchlistBloc
                                .dispatch(AddShowToWatched(watchlistInfo));
                            firestoreWatchlistCacheBloc
                                .dispatch(AddShowIdToWatched(watchlistInfo.id));
                          }
                        },
                        child: IconText(
                            icon: Icons.remove_red_eye,
                            text: "Watched",
                            color: _getAlreadyWatchedColor(
                                state)),
                      ),
                _shouldShowDoYouLikeOption(state)
                    ? _showDoYouLikeOption(context, firestoreWatchlistCacheBloc, state)
                    : EmptyWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: Constants.spacingSmall),
                  child: SimpleDialogOption(
                    onPressed: () {
                      if (watchlistInfo.entryType == EntryType.movie) {
                        _watchlistBloc
                            .dispatch(RemoveMovieFromWatchlist(watchlistInfo));
                        firestoreWatchlistCacheBloc.dispatch(
                            RemoveMovieIdFromWatchlist(watchlistInfo.id));
                      } else {
                        _watchlistBloc
                            .dispatch(RemoveShowFromWatchlist(watchlistInfo));
                        firestoreWatchlistCacheBloc.dispatch(
                            RemoveShowIdFromWatchlist(watchlistInfo.id));
                      }

                      Navigator.pop(context, true);
                    },
                    child: IconText(
                        icon: Icons.delete_forever,
                        text: "Remove",
                        color: Colors.red),
                  ),
                ),
              ],
            );
          }

          throw StateError("Called watchlist dialog on unitialized id cache");
        });
  }

  Widget _showDoYouLikeOption(BuildContext context,
      LocalWatchlistIdsCacheBloc firestoreEntryIdsCacheBloc, WatchlistEntryIdsAvailable state) {
    return SlideUpAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Did you enjoy the movie?"),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    if (watchlistInfo.entryType == EntryType.movie) {
                      _watchlistBloc.dispatch(AddMovieToLiked(watchlistInfo));
                      firestoreEntryIdsCacheBloc
                          .dispatch(AddMovieIdToLiked(watchlistInfo.id));
                    } else {
                      _watchlistBloc.dispatch(AddShowToLiked(watchlistInfo));
                      firestoreEntryIdsCacheBloc
                          .dispatch(AddShowIdToLiked(watchlistInfo.id));
                    }

                    Navigator.pop(context, true);
                  },
                  child: IconText(
                      icon: Icons.thumb_up,
                      text: "Yes",
                      color: _getYesButtonColor(state)),
                ),
                FlatButton(
                    onPressed: () {
                      if (watchlistInfo.entryType == EntryType.movie) {
                        _watchlistBloc
                            .dispatch(AddMovieToWatched(watchlistInfo));
                        firestoreEntryIdsCacheBloc
                            .dispatch(AddMovieIdToWatched(watchlistInfo.id));
                      } else {
                        _watchlistBloc
                            .dispatch(AddShowToWatched(watchlistInfo));
                        firestoreEntryIdsCacheBloc
                            .dispatch(AddShowIdToWatched(watchlistInfo.id));
                      }
                      Navigator.pop(context, true);
                    },
                    child: IconText(
                        icon: Icons.thumb_down,
                        text: "No",
                        color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getToWatchColor(WatchlistEntryIdsAvailable state) {
    if (state.isEntryInToWatch(watchlistInfo)) {
      return Colors.blue;
    }

    return Colors.black;
  }

  Color _getAlreadyWatchedColor(WatchlistEntryIdsAvailable state) {
    if (state.isEntryInWatched(watchlistInfo) ||
        state.isEntryInLiked(watchlistInfo)) {
      return Colors.blue;
    }

    return Colors.black;
  }

  Color _getYesButtonColor(WatchlistEntryIdsAvailable state) {
    if (state.isEntryInLiked(watchlistInfo)) {
      return Colors.green;
    }

    return Colors.black;
  }

  bool _shouldShowDoYouLikeOption(WatchlistEntryIdsAvailable state) {
    return state.isEntryInWatched(watchlistInfo) ||
        state.isEntryInLiked(watchlistInfo);
  }
}
