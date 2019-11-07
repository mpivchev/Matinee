import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/auth/auth_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/constants/constants.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<AuthBloc>(context);
    _bloc.dispatch(GetUser());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constants.spacingMedium),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/profile_bg.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _showTitle(_bloc),
          RaisedButton(
            child: Text("Log out"),
            onPressed: () {
              FirebaseAuth.instance.signOut();
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
    );
  }

  Widget _showTitle(AuthBloc bloc) {
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, AuthState state) {
        if (state is UserAvailable) {
          return Text(
            "Logged in as ${state.firebaseUser.email}",
            style: TextStyle(color: Colors.white),
          );
        } else {
          return Text(
            "Not signed in",
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }
}
