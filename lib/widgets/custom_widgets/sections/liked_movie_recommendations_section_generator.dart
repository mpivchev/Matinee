import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/bloc/firestore/firestore_watchlist_bloc.dart';
import 'package:movie_finder/constants/constants.dart';

import '../empty_widget.dart';
import '../loading_indicator.dart';
import 'discovery_queue_section.dart';
import 'liked_movie_recommendations_section.dart';

/// Generates [LikedMovieRecommendationsSection]s based on previously liked movies by the user
class LikedMovieRecommendationsSectionGenerator extends StatefulWidget {
  /// How many max sections to generate.
  ///
  /// Generated sections might be less than the max if the number of liked movies is less.
  final int maxSections;

  LikedMovieRecommendationsSectionGenerator({@required this.maxSections});

  @override
  _LikedMovieRecommendationsSectionGeneratorState createState() =>
      _LikedMovieRecommendationsSectionGeneratorState();
}

class _LikedMovieRecommendationsSectionGeneratorState
    extends State<LikedMovieRecommendationsSectionGenerator> {
  final _firestoreMovieBloc = FirestoreWatchlistBloc();

  @override
  void initState() {
    _firestoreMovieBloc
        .dispatch(FetchRandomLikedMovies(limit: widget.maxSections));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _firestoreMovieBloc,
        builder: (context, FirestoreWatchlistState state) {
          if (state is FirestoreRandomLikedEntriesAvailable) {
            // if there are no liked entries, don't generate any sections
            if (state.entries.isEmpty) return EmptyWidget();

            final sections = List();

            state.entries.forEach(
                (movie) => sections.add(LikedMovieRecommendationsSection(
                      watchlistEntry: movie,
                    )));

            return Column(
              children: <Widget>[...sections],
            );
          }

          return LoadingIndicator(
            height: Constants.sectionHeight,
          );
        });
  }
}
