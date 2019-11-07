import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/screens/menu/watchlist_page/shared/watchlist_grid.dart';

import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/movie_item_card_watchlist.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class ToWatchTab extends StatefulWidget {
  @override
  _ToWatchTabState createState() => _ToWatchTabState();
}

class _ToWatchTabState extends State<ToWatchTab> {
  final _firestoreBloc = FirestoreWatchlistBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: Constants.spacingSmall),
        height: Constants.entryCardHeight,
        child: StreamBuilder<List<WatchlistEntryInfo>>(
            stream: _firestoreBloc.toWatchSnapshot,
            builder:
                (context, AsyncSnapshot<List<WatchlistEntryInfo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingIndicator();

              return WatchlistGrid(
                watchlistInfo: snapshot.data,
              );
            }));
  }
}
