import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/screens/entry_details/movie_details_page.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/movie_item.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';

import '../loading_indicator.dart';

class ShowMoreListViewBuilder extends StatefulWidget {
//  final List<MovieTmdbEntry> movies;
  final bool hasReachedMax;

  final int itemCount;

  /// The [Widget] item shown inside this
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// This function will trigger when the list scrolls to the very bottom
  final VoidCallback onEndScroll;

  ShowMoreListViewBuilder(
      {@required this.itemCount,
      @required this.hasReachedMax,
      @required this.onEndScroll,
      @required this.itemBuilder});

  @override
  _ShowMoreListViewBuilderState createState() =>
      _ShowMoreListViewBuilderState();
}

class _ShowMoreListViewBuilderState extends State<ShowMoreListViewBuilder> {
  final ScrollController _scrollController = ScrollController();

  static const _scrollThreshold = 300;

  @override
  void initState() {
    _scrollController.addListener(_triggerOnEndScrollCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            itemCount: widget.itemCount,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index >= widget.itemCount - 1 && !widget.hasReachedMax) {
                return LoadingIndicator();
              }

              return widget.itemBuilder(context, index);
            }),
      ),
    );
  }

  _triggerOnEndScrollCallback() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget.onEndScroll();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
