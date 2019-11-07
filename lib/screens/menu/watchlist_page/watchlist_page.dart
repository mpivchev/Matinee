import 'package:flutter/material.dart';
import 'package:movie_finder/screens/menu/watchlist_page/to_watch_tab.dart';

import 'already_watched_tab.dart';

class WatchListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(tabs: [
          Tab(
            text: "To watch",
          ),
          Tab(
            text: "Watched",
          )
        ]),
        body: TabBarView(
          children: [
            ToWatchTab(),
            AlreadyWatchedTab()
          ],
        ),
      ),
    );
  }
}
