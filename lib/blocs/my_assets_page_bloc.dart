import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/repositories/asset.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class MyAssetsPageBloc {
  BehaviorSubject<bool> _isLoadingAssetsController;
  BehaviorSubject<MetaData> _assetsMetaDataController;
  BehaviorSubject<List<Asset>> _assetsController;
  BehaviorSubject<bool> _isCreatingAssetController;
  BehaviorSubject<Asset> _newAssetController;

  Stream get assets => _assetsController.stream;
  Stream get assetsMetaData => _assetsMetaDataController.stream;
  Stream get isLoadingAssets => _isLoadingAssetsController.stream;
  Stream get isCreatingAsset => _isCreatingAssetController.stream;
  Stream get asset => _newAssetController.stream;

  init() {
    _assetsController = BehaviorSubject<List<Asset>>();
    _assetsMetaDataController = BehaviorSubject<MetaData>();
    _isLoadingAssetsController = BehaviorSubject<bool>();
    _isCreatingAssetController = BehaviorSubject<bool>();
    _newAssetController = BehaviorSubject<Asset>();
  }

  dispose() {
    _assetsController.close();
    _assetsMetaDataController.close();
    _isLoadingAssetsController.close();
    _isCreatingAssetController.close();
    _newAssetController.close();
  }

  createAsset(Asset asset) async {
    try {
      _isCreatingAssetController.sink.add(true);
      var data = await AssetRepo.create(asset);
      _newAssetController.sink.add(data['asset']);
    } catch (error) {
      if (error is RequestException) {
        _newAssetController.sink.addError(error.message);
      } else {
        _newAssetController.sink.addError(error.toString());
      }
    } finally {
      _isCreatingAssetController.sink.add(false);
    }
  }

  resetAssetCreation() => _newAssetController.sink.add(null);

  getAllAssets({String searchString, String user, int limit, int page}) async {
    _isLoadingAssetsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {};
      if (searchString != null) queryParams['searchString'] = searchString;
      if (user != null) queryParams['user'] = mainBloc.userProfileObject.sId;
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      // make the call
      var res = await AssetRepo.getAll(queryParams);
      _assetsController.add(res['entries']);
      _assetsMetaDataController.add(res['metaData']);
      _isLoadingAssetsController.add(false);
    } catch (exc) {
      _isLoadingAssetsController.add(false);

      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        alert(exc.message);
      } else {
        alert(exc.toString());
      }
    }
  }

  /// show alert message
  alert(String message) => mainBloc.alert(message);
}

final MyAssetsPageBloc myAssetsPageBloc = MyAssetsPageBloc();
