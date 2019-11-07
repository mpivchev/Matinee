import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class DiscoveryQueueState extends Equatable {
  DiscoveryQueueState([List props = const []]) : super(props);
}

class DiscoveryQueueUninitialized extends DiscoveryQueueState {}

class DiscoveryQueueError extends DiscoveryQueueState {}

class DiscoveryEntriesLoaded extends DiscoveryQueueState {
  final List<MovieEntry> movies;

  DiscoveryEntriesLoaded(
      {@required this.movies})
      : super([movies]);
}
