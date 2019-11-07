import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_bloc.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_event.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/lists/discover_shows_list_view_builder.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/shared/section_header.dart';

class LikedShowRecommendationsSection extends StatefulWidget {
  @override
  _LikedShowRecommendationsSectionState createState() =>
      _LikedShowRecommendationsSectionState();
}

class _LikedShowRecommendationsSectionState
    extends State<LikedShowRecommendationsSection> {
  final _recommendationsBloc = TmdbMovieBloc();
  FirestoreWatchlistBloc _lastLikedBloc;

  @override
  Widget build(BuildContext context) {
    final _watchlistBloc = BlocProvider.of<FirestoreWatchlistBloc>(context);
    _lastLikedBloc = BlocProvider.of<FirestoreWatchlistBloc>(context);

    return Container(
      child: BlocBuilder(
          bloc: _lastLikedBloc,
          builder: (context, FirestoreWatchlistState state) {
            if (state is FirestoreLastLikedShowEntriesAvailable) {
              // if there are no liked entries, don't show this section at all
              if (state.entries.isEmpty) return EmptyWidget();

              final _randomEntry = (state.entries..shuffle()).first;

              return BlocBuilder(
                bloc: _recommendationsBloc,
                builder: (BuildContext context, TmdbMovieState state) {
                  if (state is RecommendedShowsLoaded) {
                    final _shows = state.list;

                    return StreamBuilder<QuerySnapshot>(
                        stream: _watchlistBloc.fullWatchlistSnapshot,
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> watchlistSnapshot) {
                          if (watchlistSnapshot.connectionState ==
                              ConnectionState.waiting) return EmptyWidget();

                          return Container(
                            margin: EdgeInsets.only(bottom: Constants.spacingSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SectionHeader(
                                    "Because you liked ${_randomEntry.title}"),
                                Container(
                                    height: Constants.entryCardHeight,
                                    child: DiscoverShowsListViewBuilder(
                                      shows: _shows,
                                      watchlistSnapshot: watchlistSnapshot,
                                      pageStorageKey: "recommendationsSection",
                                    )),
                              ],
                            ),
                          );
                        });
                  }

                  return LoadingIndicator(
                    height: Constants.sectionHeight,
                  );
                },
              );
            }

            return LoadingIndicator(
              height: Constants.sectionHeight,
            );
          }),
    );
  }
}
