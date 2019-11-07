import 'dart:collection';
import 'dart:math';

import 'package:movie_finder/models/watchlist_entry_info.dart';

abstract class FirestoreBaseRepository {
  Future<Null> addToWatch(
      String userId, int entryId, String title, String posterPath);

  Future<Null> addToAlreadyWatched(
      String userId, int entryId, String title, String posterPath);

  Future<Null> addToLiked(
      String userId, int entryId, String title, String posterPath);

  Future<Null> removeFromWatchList(
      String userId, int entryId, String title, String posterPath);

  Future<Map<String, HashSet<int>>> fetchIds(String userId);

  Future<List<WatchlistEntryInfo>> fetchRandomLiked(String userId, int limit);

  int generate64BitRandom() {
    var r = new Random();
    var random1 = r.nextInt(pow(2, 32));
    var random2 = r.nextInt(pow(2, 32));
    var bigRandom = (random1 << 32) | random2;
    return bigRandom;
  }
}
