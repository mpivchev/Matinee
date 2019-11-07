import 'package:flutter/material.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/discovery_queue_section.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/liked_movie_recommendations_section_generator.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/movies_in_theaters_section.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/trending_movies_section.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/upcoming_movies_section.dart';

class HomePageMoviesTab extends StatefulWidget {
  @override
  _HomePageMoviesTabState createState() => _HomePageMoviesTabState();
}

class _HomePageMoviesTabState extends State<HomePageMoviesTab>
    with AutomaticKeepAliveClientMixin<HomePageMoviesTab> {
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
            LikedMovieRecommendationsSectionGenerator(maxSections: 3),
            TrendingMoviesSection(),
            MoviesInTheatersSection(),
            UpcomingMoviesSection()
          ],
        ),
      ),
    );
  }
}
