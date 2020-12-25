import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/asset.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class CreateNewAssetPageBloc {
  GlobalKey<ScaffoldState> _key;
  BehaviorSubject<bool> _isCreatingAssetController;
  BehaviorSubject<Asset> _newAssetController;
  Stream get isCreatingAsset => _isCreatingAssetController.stream;
  Stream get asset => _newAssetController.stream;

  init(GlobalKey<ScaffoldState> _key) {
    this._key = _key;
    _isCreatingAssetController = new BehaviorSubject<bool>();
    _newAssetController = new BehaviorSubject<Asset>();
    _isCreatingAssetController.add(false);
  }

  /// show alert message
  alert(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// close all the opened streams
  dispose() {
    _isCreatingAssetController.close();
    _newAssetController.close();
  }

  createAsset(Asset asset) async {
    try {
      _isCreatingAssetController.sink.add(true);
      var data = await AssetRepo.create(asset);
      _isCreatingAssetController.sink.add(false);
      Timer(Duration(milliseconds: 400),
          () => _newAssetController.sink.add(data['asset']));
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isCreatingAssetController.sink.add(false);
    }
  }
}

final createNewAssetPageBloc = new CreateNewAssetPageBloc();
