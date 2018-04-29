import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_flux/flutter_flux.dart';

import 'package:fh_sdk/fh_sdk.dart';

import 'package:gramola/config/stores.dart';

const String BACKGROUND_PHOTO = 'images/background.jpg';

class LoginTextField extends TextFormField {
  static const Color TEXT_COLOR = Colors.white;
  static const TextStyle TEXT_STYLE = TextStyle(color: TEXT_COLOR);
  LoginTextField ({
    IconData iconData,
    String labelText, 
    FormFieldValidator<String> validator, 
    FormFieldSetter<String> onSaved, 
    bool obscureText: false
    }) : super(
        decoration: new InputDecoration(
          icon: new Icon(iconData),
          labelText: labelText,
          //labelStyle: TEXT_STYLE,
          //border: new UnderlineInputBorder(
          //  borderSide: new BorderSide(color: TEXT_COLOR)
          //),
        ),
        //style: TEXT_STYLE,
        validator: validator,
        onSaved: onSaved,
        obscureText: obscureText
      );
}

class LoginComponent extends StatefulWidget {
  @override
  _LoginComponentState createState() => new _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> 
  with StoreWatcherMixin<LoginComponent>{

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  // Never write to these stores directly. Use Actions.
  LoginStore loginStore;

  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      // form is valid, let's login
      _performLogin();
    }
  }

  void _performLogin() async {
    try {
      authenticateRequestAction(_email);
      dynamic result = await FhSdk.auth('flutter', _email, _password);
      authenticateSuccessAction(result);
      Navigator.pushReplacementNamed(scaffoldKey.currentContext, '/events/SPAIN/MADRID');
    } on PlatformException catch (e) {
      authenticateFailureAction(e.message);
      _showSnackbar('Authentication failed!');
    }
  }

  void _showSnackbar (String message) {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _buildLoginForm(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Form(
        key: formKey,
        child: new Column(
          children: [
            const SizedBox(height: 24.0),
            new LoginTextField(
              iconData: Icons.person,
              labelText: 'User Name',
              validator: (val) =>
              val.length < 3 ? 'Not a valid User Name' : null,
              onSaved: (val) => _email = val,
            ),
            new LoginTextField(
              iconData: Icons.vpn_key,
              labelText: 'Password',
              validator: (val) =>
              val.length < 3 ? 'Password too short.' : null,
              onSaved: (val) => _password = val,
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            new RaisedButton(
              onPressed: _submit,
              child: new Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      //appBar: new AppBar(
      //  title: new Text('Validating forms'),
      //),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset(BACKGROUND_PHOTO, fit: BoxFit.cover),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: new Container(
              color: Colors.black.withOpacity(0.5),
              // TODO: child: _buildContent(),
              child: _buildLoginForm(context)
            ),
          ),
        ],
      ),
    );
  }
}