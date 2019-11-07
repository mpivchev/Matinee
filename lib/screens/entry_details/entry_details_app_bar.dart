import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/animations/slide_up_animation.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

class EntryDetailsSliverAppBar extends StatelessWidget {
  final TmdbMovieBloc entryBloc;
  final bool showTitle;

  static const expandedHeight = 200.0;

  EntryDetailsSliverAppBar({@required this.entryBloc, @required this.showTitle});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: showTitle ? Brightness.light : Brightness.dark,
      iconTheme: showTitle
          ? IconThemeData(color: Colors.black)
          : IconThemeData(color: Colors.white),
      pinned: true,
      expandedHeight: expandedHeight,
      title: _showToolbarTitle(),
      flexibleSpace: showTitle
          ? null
          : FlexibleSpaceBar(
              title: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              background: _showToolbarBackground()),
    );
  }

  Widget _showToolbarTitle() {
    return BlocBuilder(
      bloc: entryBloc,
      builder: (BuildContext context, TmdbMovieState state) {
        if (state is MovieDetailsLoaded) {
          if (showTitle)
            return SlideUpAnimation(child: Text(state.movieDetails.title));
        }

        return EmptyWidget();
      },
    );
  }

  Widget _showToolbarBackground() {
    return BlocBuilder(
      bloc: entryBloc,
      builder: (BuildContext context, TmdbMovieState state) {
        if (state is MovieDetailsLoaded) {
          if (state.movieDetails.backdropPath == null) return EmptyWidget();
          return FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: CachedNetworkImage(
                imageUrl: Constants.backdropUrl + state.movieDetails.backdropPath,
                fit: BoxFit.cover,
              ));
        }

        return EmptyWidget();
      },
    );
  }
}
