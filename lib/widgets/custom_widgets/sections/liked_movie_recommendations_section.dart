import 'package:flutter/material.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_event.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';
import 'package:movie_finder/screens/show_more/show_more_liked_movie_recommendations.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_list_view_container.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class LikedMovieRecommendationsSection extends StatefulWidget {
  /// The movie entry from which recommended movies will be picked
  final WatchlistEntryInfo watchlistEntry;

  LikedMovieRecommendationsSection({@required this.watchlistEntry});

  @override
  _LikedMovieRecommendationsSectionState createState() =>
      _LikedMovieRecommendationsSectionState();
}

class _LikedMovieRecommendationsSectionState
    extends State<LikedMovieRecommendationsSection> {
  final _recommendationsBloc = TmdbMovieBloc();

  @override
  void initState() {
    _recommendationsBloc.dispatch(
        FetchRecommendedFromMovie(id: widget.watchlistEntry.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocBuilder(
          bloc: _recommendationsBloc,
          builder: (BuildContext context, TmdbMovieState state) {
            if (state is RecommendedMoviesLoaded) {
              final _movies = state.list;

              if (_movies.entries.isEmpty) return EmptyWidget();

              return Container(
                  margin: EdgeInsets.only(bottom: Constants.spacingSmall),
//                  child: DiscoverMoviesListViewBuilder(
                  child: DiscoverListViewContainer(
                    headerTitle: "Because you liked ${widget.watchlistEntry
                        .title}",
//                    onShowMoreTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  ShowMoreLikedMovieRecommendations(
//                                    bloc: _recommendationsBloc,
//                                    movieId: widget.watchlistEntry.id,
//                                  )));
//                    },
                    child: DiscoverListViewBuilder(
                        itemCount: _movies.entries.length,
                        pageStorageKey: "movieRecommendationsSection",
                        itemBuilder: (context, index) {
                          return EntryItemCard.fromMovie(
                            movie: _movies.entries[index],
                          );
                        }),
                  ));
            }

            return LoadingIndicator(
              height: Constants.sectionHeight,
            );
          },
        ));
  }
}
