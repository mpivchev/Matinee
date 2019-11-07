import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/movie_item_card_watchlist.dart';

class WatchlistGrid extends StatelessWidget {
  // final AsyncSnapshot<QuerySnapshot> snapshot;
  final List<WatchlistEntryInfo> watchlistInfo;

  WatchlistGrid({@required this.watchlistInfo});

  @override
  Widget build(BuildContext context) {
    if (watchlistInfo.isEmpty)
      return Center(child: Text("No movie/show has been added yet."));

    return GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 0.675),
        itemCount: watchlistInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return MovieItemCardWatchlist(
            watchlistInfo: watchlistInfo[index],
          );
        });
  }
}
