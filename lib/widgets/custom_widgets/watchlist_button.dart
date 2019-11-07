import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_dialog.dart';

/// The button responsible for opening the [WatchlistDialog]
class WatchlistButton extends StatelessWidget {
  final WatchlistEntryInfo watchlistInfo;

  /// Whether the entry is to be released or not
  final bool upcoming;

  /// The empty space inside the button
  final EdgeInsetsGeometry padding;

  final defaultBackgroundColor = Colors.black.withOpacity(.8);
  final defaultIconColor = Colors.black.withOpacity(.8);

  WatchlistButton(
      {@required this.watchlistInfo,
      @required this.upcoming,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => WatchlistDialog(
                  watchlistInfo: watchlistInfo,
                  upcoming: upcoming,
                ));
      },
      child: Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Container(
            height: 40,
            width: 30,
            child: Center(child: _getAddToWatchButtonIcon(context))),
      ),
    );
  }

  Widget _getAddToWatchButtonIcon(context) {
    final firestoreEntryIdsCacheBloc =
        BlocProvider.of<LocalWatchlistIdsCacheBloc>(context);

    return BlocBuilder(
        bloc: firestoreEntryIdsCacheBloc,
//        condition: (_, currentState) {
//          if (currentState is WatchlistEntryIdsAvailable) return true;
//          return false;
//        },
        builder: (context, LocalWatchlistIdsCacheState state) {
          if (state is WatchlistEntryIdsAvailable) {

            if (state.isEntryInLiked(watchlistInfo)) {
              return Icon(
                Icons.favorite,
                color: Colors.red,
              );
            } else if (state.isEntryInWatched(watchlistInfo)) {
              return Icon(
                Icons.remove_red_eye,
                color: Colors.yellow,
              );
            } else if (state.isEntryInToWatch(watchlistInfo)) {
              return Icon(
                Icons.done,
                color: Colors.green,
              );
            }
          }

          return Icon(
            Icons.add,
            color: Colors.grey,
          );
        });
  }
}
