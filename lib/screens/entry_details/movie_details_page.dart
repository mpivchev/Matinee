import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/animations/slide_up_animation.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

import 'entry_details_app_bar.dart';

class MovieDetailsPage extends StatefulWidget {
  final int id;
  final String posterUrl;

  MovieDetailsPage({
    @required this.id,
    @required this.posterUrl,
  }) : assert(id != null && posterUrl != null);

  @override
  _MovieDetailsPageState createState() => new _MovieDetailsPageState();
}

//const kExpandedHeight = 200.0;

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with AfterLayoutMixin<MovieDetailsPage> {
  ScrollController _scrollController;
  final _movieDetailsBloc = TmdbMovieBloc();
  final _recommendationsBloc = TmdbMovieBloc();
  final _watchlistBloc = FirestoreWatchlistBloc();

  @override
  void afterFirstLayout(BuildContext context) {
    _movieDetailsBloc.dispatch(FetchMovieDetails(id: widget.id));
    _recommendationsBloc.dispatch(FetchSimilarFromMovie(id: widget.id));
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > EntryDetailsSliverAppBar.expandedHeight - kToolbarHeight - 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        EntryDetailsSliverAppBar(
          entryBloc: _movieDetailsBloc,
          showTitle: _showTitle,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              // Separate from main content since it needs to be showing up first (Hero animation)
              _showMoviePoster(),

              _showMainContent(),
              // _showSuggestions()
            ],
          ),
        ),
      ]),
    );
  }

  Widget _showMainContent() {
    return BlocBuilder(
      bloc: _movieDetailsBloc,
      builder: (BuildContext context, TmdbMovieState state) {
        if (state is MovieDetailsLoaded) {
          return Padding(
            padding: const EdgeInsets.all(Constants.spacingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Overview:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(state.movieDetails.overview),
//                Text(
//                  "Actors:",
//                  style: TextStyle(fontWeight: FontWeight.bold),
//                ),
              ],
            ),
          );
        }

        return EmptyWidget();
      },
    );
  }

  Widget _showSuggestions() {
    return BlocBuilder(
      bloc: _recommendationsBloc,
      builder: (BuildContext context, TmdbMovieState state) {
        if (state is SimilarMoviesLoaded) {
          return StreamBuilder<QuerySnapshot>(
              stream: _watchlistBloc.fullWatchlistSnapshot,
              builder:
                  (context, AsyncSnapshot<QuerySnapshot> watchlistSnapshot) {
                if (watchlistSnapshot.connectionState ==
                    ConnectionState.waiting) return EmptyWidget();

                return Padding(
                  padding: const EdgeInsets.all(Constants.spacingSmall),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Movies like this one:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
//                      Container(
//                        height: EntryItemCard.cardHeight,
//                        child: ListView.builder(
//                            shrinkWrap: true,
//                            scrollDirection: Axis.horizontal,
//                            physics: BouncingScrollPhysics(),
//                            itemCount: state.list.results.length,
//                            itemBuilder: (context, index) {
//                              final _movie = state.list.results[index];
//
//                              return GestureDetector(
//                                  onTap: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) =>
//                                                MovieDetailsPage(
//                                                  id: _movie.id,
//                                                  posterUrl: URL.mediaUrlW500 +
//                                                      _movie.posterPath,
//                                                )));
//                                  },
//                                  child: EntryItemCard(_movie));
//                            }),
//                      ),
                    ],
                  ),
                );
              });
        }

        return EmptyWidget();
      },
    );
  }

  Widget _showMoviePoster() {
    return GestureDetector(
//      onTap: () {
//        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsPage(id: id,)));
//      },
      // Container doesn't know the constraints of the parent, so it needs to know to start from the left side
      child: Align(
        alignment: Alignment.centerLeft,
        child: Card(
          color: Colors.black,
          shape: BeveledRectangleBorder(),
          child: Container(
            height: 204,
            width: 136,
            child: CachedNetworkImage(
              imageUrl: widget.posterUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    StatusBar.setWhite();
  }
}
