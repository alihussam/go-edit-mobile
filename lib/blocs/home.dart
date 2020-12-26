import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/repositories/asset.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc {
  BehaviorSubject<int> _activePageController;
  BehaviorSubject<bool> _isLoadingAssetsController;
  BehaviorSubject<MetaData> _assetMetaDataController;
  BehaviorSubject<List<Asset>> _assetsController;

  Stream get activePageIndex => _activePageController.stream;
  Stream get userProfile => mainBloc.userProfile;
  Stream get assets => _assetsController.stream;
  Stream get assetsMetaData => _assetMetaDataController.stream;
  Stream get isLoadingAssets => _isLoadingAssetsController.stream;

  /// init home bloc
  init() {
    _activePageController = BehaviorSubject<int>();
    _isLoadingAssetsController = BehaviorSubject<bool>();
    _assetMetaDataController = BehaviorSubject<MetaData>();
    _assetsController = BehaviorSubject<List<Asset>>();
  }

  changeActivePage(int index) {
    print('Home:: ' + index.toString());
    _activePageController.add(index);
  }

  getAllAssets({String searchString, String user, int limit, int page}) async {
    _isLoadingAssetsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {};
      if (searchString != null) queryParams['searchString'] = searchString;
      if (user != null) queryParams['user'] = user;
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      // make the call
      var res = await AssetRepo.getAll(queryParams);
      _assetsController.add(res['entries']);
      _assetMetaDataController.add(res['metaData']);
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

  /// close all the opened streams
  dispose() {
    _activePageController.close();
    _assetsController.close();
    _assetMetaDataController.close();
    _isLoadingAssetsController.close();
  }

  // logout user
  logout() => mainBloc.logout();
}

final HomeBloc homeBloc = HomeBloc();
