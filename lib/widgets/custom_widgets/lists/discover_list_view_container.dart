import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/screens/show_more/show_more_liked_movie_recommendations.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/shared/section_header.dart';

class DiscoverListViewContainer extends StatelessWidget {
  /// The text for the header title above the list
  final String headerTitle;

  /// This will trigger when the user presses the "show more" button
  final VoidCallback onShowMoreTap;

  /// The [ListView] shown inside this
  final ListView child;

  DiscoverListViewContainer(
      {@required this.headerTitle, this.onShowMoreTap, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Constants.spacingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: SectionHeader(headerTitle)),
              InkWell(
                onTap: () {
                  onShowMoreTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: onShowMoreTap != null ? Text("MORE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor)) : EmptyWidget(),
                ),
              )
            ],
          ),
          Container(
            height: Constants.entryCardHeight,
            child: child,
          ),
        ],
      ),
    );
  }
}
