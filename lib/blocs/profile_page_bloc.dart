import 'dart:async';

import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/auth.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class ProfilePageBloc {
  BehaviorSubject<int> _activeStatCardController;
  BehaviorSubject<bool> _isUpdateModeOnController;
  BehaviorSubject<bool> _isUpdatingProfileController;
  BehaviorSubject<User> _userProfileController;

  Stream get activeStatCardIndex => _activeStatCardController.stream;
  Stream get isUpdateModeOn => _isUpdateModeOnController.stream;
  Stream get isUpdatingProfile => _isUpdatingProfileController.stream;
  Stream get userProfile => _userProfileController.stream;

  /// init home bloc
  init(User user) {
    _activeStatCardController = new BehaviorSubject<int>();
    _isUpdateModeOnController = new BehaviorSubject<bool>();
    _isUpdatingProfileController = new BehaviorSubject<bool>();
    _userProfileController = BehaviorSubject<User>();
    // add initial value
    _isUpdateModeOnController.add(false);
    _isUpdatingProfileController.add(false);
    if (user != null) {
      _userProfileController.sink.add(user);
    } else {
      _userProfileController.sink.add(mainBloc.userProfileObject);
    }

    // check which user to work on
  }

  changeActiveStatCard(int index) => _activeStatCardController.add(index);
  toggleUpdateMode() =>
      _isUpdateModeOnController.add(!_isUpdateModeOnController.value);

  /// show alert message
  alert(String message) => mainBloc.alert(message);

  isCurrentUser(String userId) {
    return userId == mainBloc.userProfileObject.sId;
  }

  /// close all the opened streams
  dispose() {
    _activeStatCardController.close();
    _isUpdateModeOnController.close();
    _isUpdatingProfileController.close();
    _userProfileController.close();
  }

  // update profile
  updateProfilePicture(User user) async {
    try {
      _isUpdatingProfileController.sink.add(true);
      var data = await UserRepo.updateProfilePicture(user);
      mainBloc.updateUserProfile(data['profile']);
      _userProfileController.sink.add(data['profile']);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    } finally {
      _isUpdatingProfileController.sink.add(false);
    }
  }

  getProfile(Map<String, dynamic> queryParams) async {
    try {
      var data = await AuthRepo.getProfile(queryParams);
      if (queryParams == null) {
        mainBloc.updateUserProfile(data['profile']);
      }
      _userProfileController.sink.add(data['profile']);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    }
  }

  // update profile
  updateProfile(User user) async {
    try {
      _isUpdatingProfileController.sink.add(true);
      var data = await UserRepo.updateProfile(user);
      mainBloc.updateUserProfile(data['profile']);
      _userProfileController.sink.add(data['profile']);
      _isUpdatingProfileController.sink.add(false);
      _isUpdateModeOnController.sink.add(false);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isUpdatingProfileController.sink.add(false);
    }
  }

  withdraw(String accountNumber, double amount) async {
    try {
      _isUpdatingProfileController.sink.add(true);
      var data = await UserRepo.withdraw(amount);
      print('Data found');
      print(data['profile']);
      mainBloc.updateUserProfile(data['profile']);
      _userProfileController.sink.add(data['profile']);
      _isUpdatingProfileController.sink.add(false);
      _isUpdateModeOnController.sink.add(false);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isUpdatingProfileController.sink.add(false);
    }
  }
}

final profilePageBloc = new ProfilePageBloc();
