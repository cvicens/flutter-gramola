import 'package:flutter/material.dart';

class LoginComponent extends StatefulWidget {
  @override
  _LoginComponentState createState() => new _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }

  void _performLogin() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('Email: $_email, password: $_password'),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

    Navigator.pushReplacementNamed(scaffoldKey.currentContext, '/events/SPAIN/MADRID');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Validating forms'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Your email'),
                validator: (val) =>
                !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (val) => _email = val,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Your password'),
                validator: (val) =>
                val.length < 6 ? 'Password too short.' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              new RaisedButton(
                onPressed: _submit,
                child: new Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}