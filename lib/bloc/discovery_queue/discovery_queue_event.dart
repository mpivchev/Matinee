import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/api/tmdb_api.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class DiscoveryQueueEvent extends Equatable {}

class FetchDiscoveryEntries extends DiscoveryQueueEvent {
  /// Movie ids to take into consideration when creating the discovery queue
  final HashSet<int> watchlistMovieIds;

  /// Show ids to take into consideration when creating the discovery queue
  final HashSet<int> watchlistShowIds;

  final int entriesCount;

  FetchDiscoveryEntries(this.watchlistMovieIds, this.watchlistShowIds, this.entriesCount);
}