import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/auth.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class MainBloc {
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  GlobalKey<ScaffoldState> _key;
  // possible values for auth are HOME, ONBOARDING, LOGIN
  BehaviorSubject<String> _authController = BehaviorSubject<String>();
  BehaviorSubject<User> _userProfileController = BehaviorSubject<User>();

  Stream<User> get userProfile => _userProfileController.stream;
  Stream<String> get auth => _authController.stream;

  /// init main bloc
  init(GlobalKey<ScaffoldState> key) => _key = key;

  /// get initial screen
  getInitialScreen() async {
    try {
      // onboarding if user is opening app for the first time
      if (await _secureStorage.read(key: 'isOnboardingVisited') == null) {
        Timer(Duration(seconds: 4), () {
          _authController.add('ONBOARDING');
          _secureStorage.write(key: 'isOnboardingVisited', value: 'yes');
        });
      } else {
        var data = await AuthRepo.getProfile();
        _userProfileController.sink.add(data['profile']);
        _authController.sink.add('HOME');
      }
    } catch (exc) {
      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          _authController.sink.add('LOGIN');
        }
        alert(exc.message);
      } else {
        alert(exc.toString());
      }
    }
  }

  /// show alert message
  alert(String message) {
    _key.currentState.hideCurrentSnackBar();
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// login user
  authenticated(User user) {
    _userProfileController.sink.add(user);
    _authController.sink.add('HOME');
  }

  /// update user profile
  updateUserProfile(User user) {
    _userProfileController.sink.add(user);
  }

  /// change auth state, result in either login, home or onboarding screen
  changeAuthState(String authState) {
    _authController.sink.add(authState);
  }

  /// logout user from application
  logout() {
    AuthRepo.logout();
    _authController.sink.add('LOGIN');
  }

  /// close all the opened streams when the application is closed
  dispose() {
    _authController.close();
    _userProfileController.close();
  }
}

final mainBloc = MainBloc();
