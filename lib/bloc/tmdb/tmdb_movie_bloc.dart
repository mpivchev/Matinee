import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/firestore/firestore_watchlist_event.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

import 'package:rxdart/rxdart.dart';
import 'tmdb_movie_event.dart';
import 'tmdb_movie_state.dart';

class TmdbMovieBloc extends Bloc<TmdbMovieEvent, TmdbMovieState> {
  final TmdbMovieRepository _tmdbRepository = TmdbMovieRepository();

  @override
  TmdbMovieState get initialState => TmdbUninitialized();

  @override
  Stream<TmdbMovieState> transform(
      Stream<TmdbMovieEvent> events,
      Stream<TmdbMovieState> Function(TmdbMovieEvent event) next,
      ) {
    return super.transform(
      (events as Observable<TmdbMovieEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<TmdbMovieState> mapEventToState(
    TmdbMovieEvent event,
  ) async* {
    if (event is FetchTrendingMovies) {
      yield* _mapFetchTrendingMoviesToState();
    } else if (event is FetchSimilarFromMovie) {
      yield* _mapFetchSimilarFromMovieToState(event.id);
    } else if (event is FetchRecommendedFromMovie) {
      yield* _mapFetchRecommendedFromMovieToState(event.id);
    } else if (event is FetchMoviesInTheaters) {
      yield* _mapFetchMoviesInTheatersToState();
    } else if (event is FetchUpcomingMovies) {
      yield* _mapFetchUpcomingMoviesToState();
    } else if (event is FetchMovieDetails) {
      yield* _mapFetchMovieDetailsToState(event.id);
    }
  }

  Stream<TmdbMovieState> _mapFetchTrendingMoviesToState() async* {
    try {
      if (currentState is TmdbUninitialized) {
        final MoviesDiscover moviesDiscover =
            await _tmdbRepository.fetchTrendingMovies(1);
        yield TrendingMoviesLoaded(
            list: moviesDiscover.entries,
            currentPage: moviesDiscover.page,
            maxPages: moviesDiscover.totalPages);

        return;
      }

      if (currentState is TrendingMoviesLoaded) {
        int newPage = (currentState as TrendingMoviesLoaded).currentPage + 1;
        final MoviesDiscover moviesDiscover =
            await _tmdbRepository.fetchTrendingMovies(newPage);
        yield TrendingMoviesLoaded(
            list: (currentState as TrendingMoviesLoaded).list +
                moviesDiscover.entries,
            currentPage: newPage,
            maxPages: moviesDiscover.totalPages);
      }
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbMovieState> _mapFetchSimilarFromMovieToState(int id) async* {
    try {
      final MoviesDiscover list =
          await _tmdbRepository.fetchSimilarFromMovie(id);
      yield SimilarMoviesLoaded(list: list);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbMovieState> _mapFetchRecommendedFromMovieToState(int id) async* {
    try {
      final MoviesDiscover list =
          await _tmdbRepository.fetchRecommendedForMovie(id);
      yield RecommendedMoviesLoaded(list: list);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbMovieState> _mapFetchMoviesInTheatersToState() async* {
    try {
      final MoviesDiscover list = await _tmdbRepository.fetchMoviesInTheaters();
      yield MoviesInTheatersLoaded(list: list);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbMovieState> _mapFetchUpcomingMoviesToState() async* {
    try {
      final MoviesDiscover list = await _tmdbRepository.fetchUpcomingMovies();
      yield UpcomingMoviesLoaded(list: list);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }

  Stream<TmdbMovieState> _mapFetchMovieDetailsToState(int id) async* {
    try {
      final MovieDetails movieDetails =
          await _tmdbRepository.fetchMovieDetails(id);
      yield MovieDetailsLoaded(movieDetails: movieDetails);
    } catch (e) {
      print(e);
      yield TmdbError();
    }
  }
}
