import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/firestore/firestore_watchlist_event.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

import 'package:rxdart/rxdart.dart';
import 'discovery_queue_event.dart';
import 'discovery_queue_state.dart';

class DiscoveryQueueBloc
    extends Bloc<DiscoveryQueueEvent, DiscoveryQueueState> {
  final TmdbMovieRepository _tmdbRepository = TmdbMovieRepository();
  final FirestoreMovieRepository _firestoreMovieRepository =
      FirestoreMovieRepository();
  final AuthRepository _authRepository = AuthRepository();

  /// the maximum page number that is going to be looked through to get trending entries
//  static const maxTrendingPage = 20;
  static const maxPopularPage = 20;

  DiscoveryQueueError previousEvent;

  @override
  DiscoveryQueueState get initialState => DiscoveryQueueUninitialized();

  @override
  Stream<DiscoveryQueueState> transform(
    Stream<DiscoveryQueueEvent> events,
    Stream<DiscoveryQueueState> Function(DiscoveryQueueEvent event) next,
  ) {
    return super.transform(
      (events as Observable<DiscoveryQueueEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<DiscoveryQueueState> mapEventToState(
    DiscoveryQueueEvent event,
  ) async* {
    if (event is FetchDiscoveryEntries) {
      yield* _mapFetchDiscoveryEntries(
          event.watchlistMovieIds, event.watchlistShowIds, event.entriesCount);
    }
  }

  Stream<DiscoveryQueueState> _mapFetchDiscoveryEntries(
      HashSet<int> watchlistMovieIds, HashSet<int> watchlistShowIds,  int entriesCount) async* {
    try {
      /* Since we don't need to know how specifically the movie/show entries were acquired (be it from Trending movies/shows or Recommendations based on user data etc.)
        we can simply combine them into 2 lists of movie and show entries
      */
      final movies = await _fetchMovieEntries(entriesCount);


      // remove entries that are already in the user's watchlist
      movies.removeWhere((movie) {
        return watchlistMovieIds.contains(movie.id);
      });

      yield DiscoveryEntriesLoaded(movies: movies);
    } catch (e) {
      print(e);
      yield DiscoveryQueueError();
    }
  }

  /// Fetches multiple [MovieDiscover]s the results of which are combined into a single list
  Future<List<MovieEntry>> _fetchMovieEntries(int entriesCount) async {
    final recommendedMoviesFutures = await _createRecommendedMoviesFutures();

    final movieTmdbEntries = List<MovieEntry>();

    // the result of all futures is a list of [MoviesDiscover]
    final moviesDiscoverList = await Future.wait([
      ...recommendedMoviesFutures,
      _tmdbRepository.fetchTrendingMovies(Random().nextInt(10)),
      _tmdbRepository.fetchUpcomingMovies()
    ]);

    // the movie entries from the [MoviesDiscover]s are then combined into a single list
    moviesDiscoverList.forEach((moviesDiscover) {
      movieTmdbEntries.addAll(moviesDiscover.entries);
    });

    return movieTmdbEntries.toSet().toList()
      ..shuffle()
      ..take(entriesCount);
  }

  /// Creates multiple recommended movies futures for later use
  Future<List<Future<MoviesDiscover>>> _createRecommendedMoviesFutures() async {
    final user = await _authRepository.getUser();
    final randomLikedMovies =
        await _firestoreMovieRepository.fetchRandomLiked(user.uid, 3);

    final List<Future<MoviesDiscover>> recommendFromMovieFutures = List();

    randomLikedMovies.forEach((movie) {
      recommendFromMovieFutures
          .add(_tmdbRepository.fetchRecommendedForMovie(movie.id));
    });

    return recommendFromMovieFutures;
  }
}
