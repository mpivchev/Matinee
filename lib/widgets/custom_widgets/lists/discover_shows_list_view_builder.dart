import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';

//TODO: REMOVE THIS
class DiscoverShowsListViewBuilder extends StatelessWidget {
  final ShowsDiscover shows;
  final AsyncSnapshot<QuerySnapshot> watchlistSnapshot;
  final String pageStorageKey;

  DiscoverShowsListViewBuilder({@required this.shows, @required this.watchlistSnapshot, @required this.pageStorageKey});

  @override
  Widget build(BuildContext context) {
  //   return ListView.builder(
  //       padding: const EdgeInsets.symmetric(horizontal: 6),
  //       key: PageStorageKey("list"),
  //       scrollDirection: Axis.horizontal,
  //       physics: BouncingScrollPhysics(),
  //       itemCount: shows.results.length,
  //       itemBuilder: (context, index) {
  //         final _movie = shows.results[index];
  //         final _pos = index + 1;

  //         return GestureDetector(
  //             onTap: () {
  //               Statusbar.setDarkTinted();

  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => MovieDetailsPage(
  //                             id: _movie.id,
  //                             posterUrl: URL.mediaUrlW185 + _movie.posterPath,
  //                           )));
  //             },
  //             child: EntryCard(
  //               _movie,
  //               pos: _pos,
  //             ));
  //       });
  }
}
