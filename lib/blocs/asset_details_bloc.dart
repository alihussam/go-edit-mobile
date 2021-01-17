import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_page_bloc.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/rating.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/asset.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/rxdart.dart';

class AssetDetailsBloc {
  GlobalKey<ScaffoldState> _key;
  Asset _asset;
  BehaviorSubject<Asset> _currentAssetController;
  BehaviorSubject<bool> _isTakingActionOnAsset;

  Stream get currentAsset => _currentAssetController.stream;
  Stream get isTakingAction => _isTakingActionOnAsset.stream;

  init(GlobalKey<ScaffoldState> _key, Asset _asset) {
    this._key = _key;
    this._asset = _asset;
    _currentAssetController = new BehaviorSubject<Asset>();
    _isTakingActionOnAsset = BehaviorSubject<bool>();

    // listen to job update and resync changes
    mainBloc.socket.on('asset_update_${this._asset.sId}',
        (data) => getCurrentAsset(_asset.sId));

    // finally get current job
    getCurrentAsset(_asset.sId);
  }

  dispose() {
    _currentAssetController.close();
    _isTakingActionOnAsset.close();

    // unbind all socket listeners
    mainBloc.socket.off('asset_update_${this._asset.sId}');
  }

  /// show alert message
  alert(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // update profile
  updateResource(File file) async {
    try {
      // _isUpdatingProfileController.sink.add(true);
      var data = await AssetRepo.updateResource(_asset.sId, file);
      mainBloc.updateUserProfile(data['profile']);
      // _userProfileController.sink.add(data['profile']);
      getCurrentAsset(_asset.sId);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    } finally {
      // _isUpdatingProfileController.sink.add(false);
    }
  }

  // isJobOfCurrentUser(Job job) {
  //   return job.user.sId == mainBloc.userProfileObject.sId;
  // }

  // hasUserProvidedRating() {
  //   bool isRatingGiven = false;
  //   if (isJobOfCurrentUser(_asse)) {
  //     isRatingGiven = _asse.freelancerRating != null;
  //   } else {
  //     isRatingGiven = _asse.employerRating != null;
  //   }
  //   print(isRatingGiven);
  //   return isRatingGiven;
  // }

  // User getOppositUser(Job job) {
  //   if (isJobOfCurrentUser(job)) {
  //     Bid bid = job.getAcceptedBid();
  //     if (bid != null) {
  //       return bid.user;
  //     } else if (_freelancer != null) {
  //       return _freelancer;
  //     }
  //     return new User();
  //   }
  //   return job.user;
  // }

  // Rating getRatingIProvided() {
  //   if (isJobOfCurrentUser(_job)) {
  //     return _job.freelancerRating;
  //   } else {
  //     return _job.employerRating;
  //   }
  // }

  // Rating getRatingForCurrentUser() {
  //   if (isJobOfCurrentUser(_job)) {
  //     return _job.employerRating;
  //   } else {
  //     return _job.freelancerRating;
  //   }
  // }

  getCurrentAsset(String jobId) async {
    try {
      print('[ASSET_DETAILS_BLOC]: Getting current job');
      _isTakingActionOnAsset.sink.add(true);
      var data = await AssetRepo.getSingleAsset(jobId);
      _currentAssetController.sink.add(data['asset']);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    } finally {
      _isTakingActionOnAsset.sink.add(false);
    }
  }
}

final assetDetailsBloc = AssetDetailsBloc();
