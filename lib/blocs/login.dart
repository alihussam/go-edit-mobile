import 'dart:async';

import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/auth.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class LoginBloc {
  BehaviorSubject<bool> _isAuthenticatingController;
  Stream<bool> get isAuthenticating => _isAuthenticatingController.stream;

  alert(String message) => mainBloc.alert(message);

  // init
  init() {
    _isAuthenticatingController = BehaviorSubject<bool>();
  }

  // dispose
  dispose() {
    _isAuthenticatingController.close();
  }

  login(String email, String password) async {
    try {
      _isAuthenticatingController.sink.add(true);
      var data = await AuthRepo.login(email, password);
      mainBloc.authenticated(data['profile']);
      _isAuthenticatingController.sink.add(false);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isAuthenticatingController.sink.add(false);
    }
  }

  signup(User user) async {
    try {
      _isAuthenticatingController.sink.add(true);
      var data = await AuthRepo.signup(user);
      mainBloc.authenticated(data['profile']);
      _isAuthenticatingController.sink.add(false);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isAuthenticatingController.sink.add(false);
    }
  }

  // goto onboarding
  gotoOnboarding() => mainBloc.changeAuthState('ONBOARDING');
}

final LoginBloc loginBloc = LoginBloc();
