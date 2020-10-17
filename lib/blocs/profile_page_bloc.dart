import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class ProfilePageBloc {
  BehaviorSubject<int> _activeStatCardController;
  BehaviorSubject<bool> _isUpdateModeOnController;
  BehaviorSubject<bool> _isUpdatingProfileController;
  Stream get activeStatCardIndex => _activeStatCardController.stream;
  Stream get isUpdateModeOn => _isUpdateModeOnController.stream;
  Stream get isUpdatingProfile => _isUpdatingProfileController.stream;

  /// init home bloc
  init() {
    _activeStatCardController = new BehaviorSubject<int>();
    _isUpdateModeOnController = new BehaviorSubject<bool>();
    _isUpdatingProfileController = new BehaviorSubject<bool>();
    // add initial value
    _isUpdateModeOnController.add(false);
    _isUpdatingProfileController.add(false);
  }

  changeActiveStatCard(int index) => _activeStatCardController.add(index);
  toggleUpdateMode() =>
      _isUpdateModeOnController.add(!_isUpdateModeOnController.value);

  /// show alert message
  alert(String message) => mainBloc.alert(message);

  /// close all the opened streams
  dispose() {
    _activeStatCardController.close();
    _isUpdateModeOnController.close();
    _isUpdatingProfileController.close();
  }

  // update profile
  updateProfile(User user) async {
    try {
      _isUpdatingProfileController.sink.add(true);
      var data = await UserRepo.updateProfile(user);
      mainBloc.updateUserProfile(data['profile']);
      _isUpdatingProfileController.sink.add(false);
      _isUpdateModeOnController.sink.add(false);
    } catch (error) {
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
