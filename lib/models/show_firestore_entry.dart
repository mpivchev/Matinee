import 'package:equatable/equatable.dart';
import 'package:movie_finder/widgets/custom_widgets/entry_card/entry_item_card.dart';
import 'package:movie_finder/widgets/custom_widgets/watchlist_dialog.dart';

/// The base info for both movies and shows, used in [EntryItemCard], [WatchlistDialog]
class ShowFirestoreEntry extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final double voteAvg;
  // final EntryType entryType;

  ShowFirestoreEntry(
      this.id, this.title, this.posterPath, this.voteAvg);

  // static EntryType getTypeFromString(String strType) {
  //   for (EntryType element in EntryType.values) {
  //     if (element.toString() == "EntryType." + strType) {
  //       return element;
  //     }
  //   }

  //   throw ArgumentError("no such type " + strType);
  // }

  // static String getStringFromType(EntryType type) => type.toString().split(".")[1];
}

// enum EntryType { movie, show }
