import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/show_more_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class ShowMoreLikedMovieRecommendations extends StatelessWidget {
  final TmdbMovieBloc bloc;
  final int movieId;

  ShowMoreLikedMovieRecommendations(
      {@required this.bloc, @required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, TmdbMovieState state) {
          if (state is RecommendedMoviesLoaded) {
            final _movies = state.list;

            if (_movies.entries.isEmpty) return EmptyWidget();

            return Container(
                margin: EdgeInsets.only(bottom: Constants.spacingSmall),
//                  child: DiscoverMoviesListViewBuilder(
                child: ShowMoreListViewBuilder(
                  onEndScroll: () => bloc.dispatch(FetchRecommendedFromMovie(id: movieId)),
                ));
          }

          return LoadingIndicator(
            height: Constants.sectionHeight,
          );
        },
      )),
    );
  }
}
