import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/movie_item.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/show_more_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class ShowMoreTrendingMovies extends StatelessWidget {
  final TmdbMovieBloc tmdbBloc;

  ShowMoreTrendingMovies({@required this.tmdbBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text("Trending today"),
      ),
      body: Container(
          child: BlocBuilder(
        bloc: tmdbBloc,
        builder: (BuildContext context, TmdbMovieState state) {
          if (state is TrendingMoviesLoaded) {
            final _movies = state.list;

            if (_movies.isEmpty) return EmptyWidget();

            return Container(
                child: ShowMoreListViewBuilder(
                  itemCount: _movies.length,
                  hasReachedMax: state.currentPage == state.maxPages,
                  onEndScroll: () {
                    // on end scroll we fetch more entries
                    tmdbBloc.dispatch(FetchTrendingMovies());
                  },
                  itemBuilder: (context, index) {
                    return MovieItem(
                      _movies[index],
                    );
                  },
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
