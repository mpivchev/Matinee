import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/screens/menu/home_page/home_page.dart';
import 'package:movie_finder/screens/menu/profile_page/profile_page.dart';
import 'package:movie_finder/screens/menu/watchlist_page/watchlist_page.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';

class BaseMenu extends StatefulWidget {
  @override
  _BaseMenuState createState() => _BaseMenuState();
}

class _BaseMenuState extends State<BaseMenu>
    with AfterLayoutMixin<BaseMenu>, AutomaticKeepAliveClientMixin {
  var _currentIndex = 0;

  final _items = [HomePage(), WatchListPage(), ProfilePage()];
  final _pageController = PageController();

  @override
  void afterFirstLayout(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).dispatch(GetUser());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: _showTitle(BlocProvider.of<AuthBloc>(context)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.search), title: new Text("Discover")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.playlist_add),
                title: new Text("Watchlist")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person), title: new Text("Profile"))
          ],
        ),
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          children: _items,
          controller: _pageController,
          onPageChanged: onPageChanged,
        ));
  }

  Widget _showTitle(AuthBloc bloc) {
    switch (_currentIndex) {
      case 0:
        return Text("Discover");
      case 1:
        return Text("Watchlist");
      case 2:
        return Text("Profile");
      default:
        return EmptyWidget();
    }
  }

  void onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  bool get wantKeepAlive => true;
}
