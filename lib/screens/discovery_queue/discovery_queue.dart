import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/screens/discovery_queue/movie_info_carousel.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class DiscoveryQueue extends StatelessWidget {
  static const queueSize = 12;
  final _discoveryQueueBloc = DiscoveryQueueBloc();

//  @override
//  _DiscoveryQueueState createState() => _DiscoveryQueueState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Queue'),
        elevation: 0,
      ),
      body: _buildQueue(context),
    );
  }

  Widget _buildQueue(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<LocalWatchlistIdsCacheBloc>(context),
        condition: (previous, current) {
          if (previous is WatchlistEntryIdsAvailable) return false;
          return true;
        },
        builder: (context, LocalWatchlistIdsCacheState state) {
          if (state is WatchlistEntryIdsAvailable) {
            _discoveryQueueBloc.dispatch(FetchDiscoveryEntries(
                state.allMovieIds, state.allShowIds, DiscoveryQueue.queueSize));
          }

          return BlocBuilder(
            bloc: _discoveryQueueBloc,
            builder: (context, DiscoveryQueueState state) {
              if (state is DiscoveryEntriesLoaded) {
                return MovieInfoCarousel(movies: state.movies);
              }

              return LoadingIndicator(
                height: Constants.sectionHeight,
              );
            },
          );
        });
  }
}
