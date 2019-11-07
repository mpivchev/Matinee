import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/discovery_queue_section.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/trending_shows_section.dart';

class HomePageShowsTab extends StatefulWidget {
  @override
  _HomePageShowsTabState createState() => _HomePageShowsTabState();
}

class _HomePageShowsTabState extends State<HomePageShowsTab>
    with AutomaticKeepAliveClientMixin<HomePageShowsTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Constants.spacingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DiscoveryQueueSection(),
            TrendingShowsSection()
          ],
        ),
      ),
    );
  }
}
