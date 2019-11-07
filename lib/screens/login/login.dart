import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:after_layout/after_layout.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/widgets/behaviors/no_glow_scroll_behavior.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);

    _authBloc.dispatch(GetUser());

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constants.spacingMedium),
        child: Center(
            child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ListView(
            children: <Widget>[
//              _showGoogleSignInButton(_authBloc),
              _showEmailInput(),
              _showPasswordInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Log in"),
                    onPressed: () => _onLogInEmail(_authBloc),
//                  ),
//                  FlatButton(
//                    child: Text("Register"),
//                    onPressed: () => _onRegister(_authBloc),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

//  Widget _showGoogleSignInButton(AuthBloc bloc) {
//    return IconButton(
//      iconSize: 50,
//      color: Colors.red,
//      icon: Image.asset("assets/google_sign_in_button.png"),
//      onPressed: () => _onLogInGoogle(bloc),
//    );
//  }

  Widget _showEmailInput() {
    return new TextFormField(
      maxLines: 1,
      enabled: false,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: "Email",
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value,
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        enabled: false,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

//  _onLogInGoogle(AuthBloc bloc) {
//    bloc.dispatch(LogInGoogle());
//  }

  _onLogInEmail(AuthBloc bloc) {
    bloc.dispatch(LogInEmail());
  }

  _onRegister(AuthBloc bloc) {
    bloc.dispatch(RegisterEmail());
  }
}
