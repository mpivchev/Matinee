import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/screens/show_more/show_more_liked_movie_recommendations.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';

class DiscoverListViewBuilder extends ListView {
  // A unique list key string. Used to preserve scroll location for this list
  final String pageStorageKey;

  final int itemCount;

  /// The [Widget] item shown inside this
  final Widget Function(BuildContext context, int index) itemBuilder;

  DiscoverListViewBuilder({@required this.pageStorageKey, @required this.itemCount, @required this.itemBuilder});

  @override
  ListView build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        key: PageStorageKey(pageStorageKey),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(context, index));
  }
}
