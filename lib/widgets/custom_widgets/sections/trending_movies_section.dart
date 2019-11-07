import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/api/repositories/tmdb_movie_repository.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_event.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/screens/show_more/show_more_trending_movies.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_container.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class TrendingMoviesSection extends StatefulWidget {
  @override
  _TrendingMoviesSectionState createState() => _TrendingMoviesSectionState();
}

class _TrendingMoviesSectionState extends State<TrendingMoviesSection> {
  final _blocMovies = TmdbMovieBloc();

  @override
  void initState() {
    _blocMovies.dispatch(FetchTrendingMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder(
        bloc: _blocMovies,
        builder: (BuildContext context, TmdbMovieState state) {
          if (state is TrendingMoviesLoaded) {
            final _movies = state.list;

            return Container(
                margin: EdgeInsets.only(bottom: Constants.spacingSmall),
                child: DiscoverListViewContainer(
                  headerTitle: "Trending today",
                  onShowMoreTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowMoreTrendingMovies(
                              tmdbBloc: _blocMovies,
                            )));
                  },
                  child: DiscoverListViewBuilder(
                      itemCount: _movies.length,
                      pageStorageKey: "trendingMoviesSection",
                      itemBuilder: (context, index) {
                        return EntryItemCard.fromMovie(
                          movie: _movies[index],
                        );
                      }),
                ));
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}

