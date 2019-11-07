import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_show_event.dart';
import 'package:movie_finder/bloc/tmdb/tmdb_show_state.dart';
import 'package:movie_finder/models/shows_discover.dart';

import 'package:rxdart/rxdart.dart';

class TmdbShowBloc extends Bloc<TmdbShowEvent, TmdbShowState> {
  final _tmdbRepository = TmdbShowRepository();

  @override
  TmdbShowState get initialState => TmdbUninitialized();

  @override
  Stream<TmdbShowState> transform(
      Stream<TmdbShowEvent> events,
      Stream<TmdbShowState> Function(TmdbShowEvent event) next,
      ) {
    return super.transform(
      (events as Observable<TmdbShowEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<TmdbShowState> mapEventToState(
      TmdbShowEvent event,
  ) async* {
    if (event is FetchTrendingShows) {
      yield* _mapFetchTrendingShowsToState();
    } else if (event is FetchRecommendedFromShow) {
      yield* _mapFetchRecommendedFromShowToState(event.id);
    }
  }

  Stream<TmdbShowState> _mapFetchTrendingShowsToState() async* {
//    try {
//      final ShowsDiscover list = await _tmdbRepository.fetchTrendingShows();
//
//      yield TrendingShowsLoaded(list: list);
//    } catch (e) {
//      print(e);
//      yield TmdbError();
//    }

    try {
      if (currentState is TmdbUninitialized) {
        final ShowsDiscover showsDiscover =
        await _tmdbRepository.fetchTrendingShows(1);
        yield TrendingShowsLoaded(
            list: showsDiscover.entries,
            currentPage: showsDiscover.page,
            maxPages: showsDiscover.totalPages);

        return;
      }

      if (currentState is TrendingShowsLoaded) {
        int newPage = (currentState as TrendingShowsLoaded).currentPage + 1;
        final ShowsDiscover showsDiscover =
        await _tmdbRepository.fetchTrendingShows(newPage);
        yield TrendingShowsLoaded(
            list: (currentState as TrendingShowsLoaded).list +
                showsDiscover.entries,
            currentPage: newPage,
            maxPages: showsDiscover.totalPages);
      }
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbShowState> _mapFetchRecommendedFromShowToState(int id) async* {
    try {
      final ShowsDiscover list =
          await _tmdbRepository.fetchRecommendedForShow(id);
      yield RecommendedShowsLoaded(list: list);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }
}
