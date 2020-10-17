import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:goedit/blocs/login.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/name.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/ui/widgets/curve.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/utils/field_validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FieldValidators {
  bool _isLogin = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // all input fields declarations
  String _firstName, _middleName, _lastName, _email, _password;

  _switchPage() => this.setState(() {
        _isLogin = !_isLogin;
        _firstName = _middleName = _lastName = _email = _password = null;
      });

  _onAuthenticate() {
    if (_formKey.currentState.validate()) {
      if (_isLogin)
        loginBloc.login(_email, _password);
      else
        loginBloc.signup(
          User(
              name: Name(
                  firstName: _firstName,
                  middleName: _middleName,
                  lastName: _lastName),
              email: _email,
              password: _password,
              role: 'USER'),
        );
    }
  }

  @override
  void initState() {
    loginBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildAuthenticateButton() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: FlatButton(
            onPressed: () => _onAuthenticate(),
            child: Text(_isLogin ? 'Login' : 'Signup',
                style: TextStyle(
                  color: Colors.white,
                )),
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(15)),
      );
    }

    Widget _buildSwitchPageLabel() {
      return InkWell(
        onTap: () => _switchPage(),
        child: Text(
          _isLogin
              ? 'Don\'t have an account? Signup'
              : 'Already have an account? Login',
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget _buildDivider() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Row(children: <Widget>[
          Expanded(
              child: Divider(
            thickness: 2,
          )),
          Text("OR"),
          Expanded(
              child: Divider(
            thickness: 2,
          )),
        ]),
      );
    }

    Widget _buildPageControls() {
      return StreamBuilder(
        stream: loginBloc.isAuthenticating,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Container(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: 40,
                )));
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildAuthenticateButton(),
                _buildDivider(),
                _buildSwitchPageLabel(),
              ],
            ),
          );
        },
      );
    }

    // build login form
    List<Widget> _loginWidgets = [
      buildFormField(
          labelText: 'Email',
          onChanged: (String value) => _email = value.trim().toLowerCase(),
          validator: (value) => validateEmail(value)),
      buildFormField(
          labelText: 'Password',
          onChanged: (value) => _password = value,
          obscureText: true,
          validator: (value) => validatePassword(value)),
      _buildPageControls(),
    ];

    // build signup page
    List<Widget> _signupWidgets = [
      Container(
        child: buildFormField(
            labelText: 'First Name',
            onChanged: (value) => _firstName = value.trim(),
            validator: (value) => validateRequired(value)),
      ),
      Container(
        child: buildFormField(
          labelText: 'Middle Name',
          onChanged: (value) => _middleName = value.trim(),
          // validator: (value) => validateRequired(value)),
        ),
      ),
      buildFormField(
          labelText: 'Last Name',
          onChanged: (value) => _lastName = value.trim(),
          validator: (value) => validateRequired(value)),
      buildFormField(
          labelText: 'Email',
          onChanged: (value) => _email = value.trim().toLowerCase(),
          validator: (value) => validateEmail(value)),
      buildFormField(
          labelText: 'Password',
          onChanged: (value) => _password = value,
          obscureText: true,
          validator: (value) => validatePassword(value)),
      _buildPageControls(),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  CurveWidget(200, Theme.of(context).primaryColor),
                  // go back to onboarding screen button
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () => loginBloc.gotoOnboarding(),
                    ),
                    top: 30,
                    left: 20,
                  ),
                  Positioned(
                    bottom: 60,
                    child: Text(
                      _isLogin ? 'LOGIN' : 'SIGNUP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _isLogin ? _loginWidgets : _signupWidgets,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
