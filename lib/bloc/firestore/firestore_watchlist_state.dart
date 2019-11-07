import 'package:equatable/equatable.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

abstract class FirestoreWatchlistState extends Equatable {
  FirestoreWatchlistState([List props = const []]) : super(props);
}

class FirestoreNothing extends FirestoreWatchlistState {}

class FirestoreError extends FirestoreWatchlistState {}

class FirestoreLastLikedMovieEntriesAvailable extends FirestoreWatchlistState {
  final List<WatchlistEntryInfo> entries;

  FirestoreLastLikedMovieEntriesAvailable(this.entries) : super([entries]);
}

class FirestoreLastLikedShowEntriesAvailable extends FirestoreWatchlistState {
  final List<WatchlistEntryInfo> entries;

  FirestoreLastLikedShowEntriesAvailable(this.entries) : super([entries]);
}

class FirestoreRandomLikedEntriesAvailable extends FirestoreWatchlistState {
  final List<WatchlistEntryInfo> entries;

  FirestoreRandomLikedEntriesAvailable(this.entries) : super([entries]);
}

class FirestoreMovieIdsAvailable extends FirestoreWatchlistState {
  final Map<String, List<int>> ids;

  FirestoreMovieIdsAvailable(this.ids) : super([ids]);
}

//class FirestoreMovieAddedToWatch extends FirestoreWatchlistState {
//  final int id;
//
//  FirestoreMovieAddedToWatch(this.id) : super([id]);
//}
//
//class FirestoreMovieAddedToAlreadyWatched extends FirestoreWatchlistState {
//  final int id;
//
//  FirestoreMovieAddedToAlreadyWatched(this.id) : super([id]);
//}
//
//class FirestoreMovieAddedToLiked extends FirestoreWatchlistState {
//  final int id;
//
//  FirestoreMovieAddedToLiked(this.id) : super([id]);
//}
//
//class FirestoreMovieRemovedFromWatchlist extends FirestoreWatchlistState {
//  final int id;
//
//  FirestoreMovieRemovedFromWatchlist(this.id) : super([id]);
//}
