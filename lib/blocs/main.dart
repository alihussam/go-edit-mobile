import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/auth.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class MainBloc {
  User user;
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  GlobalKey<ScaffoldState> _key;

  // configure socket io
  IO.Socket socket = IO.io('http://192.168.1.106:4041', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // possible values for auth are HOME, ONBOARDING, LOGIN
  BehaviorSubject<String> _authController = BehaviorSubject<String>();
  BehaviorSubject<User> _userProfileController = BehaviorSubject<User>();

  Stream<User> get userProfile => _userProfileController.stream;
  Stream<String> get auth => _authController.stream;

  User get userProfileObject => user;
  IO.Socket get socketClient => socket;

  /// init main bloc
  init(GlobalKey<ScaffoldState> key) {
    _key = key;
    this.socket.connect();
  }

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
        user = data['profile'];
        _authController.sink.add('HOME');
      }
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);

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
    this.user = user;
    _authController.sink.add('HOME');
  }

  /// update user profile
  updateUserProfile(User user) {
    this.user = user;
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
    socket.dispose();
  }
}

final mainBloc = MainBloc();
