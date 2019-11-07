import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';

class Constants {
  static const double spacingVerySmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const String mediaUrlW300 = "http://image.tmdb.org/t/p/w300/";
  static const String mediaUrlW500 =
      "http://image.tmdb.org/t/p/w500/";
  static const String backdropUrl = "http://image.tmdb.org/t/p/w1280/";
  static const double sectionHeight = entryCardHeight + 39;
  static const double entryCardHeight = 259;
  static const double entryCardWidth = 115;

}

enum EntryType { movie, show }
