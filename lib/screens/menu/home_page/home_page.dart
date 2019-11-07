import 'package:flutter/material.dart';

import 'home_page_movies_tab.dart';
import 'home_page_shows_tab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(tabs: [
          Tab(
            text: "Movies",
          ),
          Tab(
            text: "TV Shows",
          ),
        ]),
        //FIXME: Flutter rebuilds all tabs during navigator pushes
        body: TabBarView(
          children: [HomePageMoviesTab(), HomePageShowsTab()],
        ),
      ),
    );
  }
}