import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_finder/api/repositories/tmdb_movie_repository.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_event.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';

import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_container.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class MoviesInTheatersSection extends StatefulWidget{
  @override
  _MoviesInTheatersSectionState createState() => _MoviesInTheatersSectionState();
}

class _MoviesInTheatersSectionState extends State<MoviesInTheatersSection> {
  final _blocMovies = TmdbMovieBloc();

  @override
  void initState() {
    _blocMovies.dispatch(FetchMoviesInTheaters());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder(
        bloc: _blocMovies,
        builder: (BuildContext context, TmdbMovieState state) {
          if (state is MoviesInTheatersLoaded) {
            final _movies = state.list;

            return Container(
                margin: EdgeInsets.only(bottom: Constants.spacingSmall),
                child: DiscoverListViewContainer(
                  headerTitle: "In theathers",
                  child: DiscoverListViewBuilder(
                      itemCount: _movies.entries.length,
                      pageStorageKey: "moviesInTheathersSection",
                      itemBuilder: (context, index) {
                        return EntryItemCard.fromMovie(
                          movie: _movies.entries[index],
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
