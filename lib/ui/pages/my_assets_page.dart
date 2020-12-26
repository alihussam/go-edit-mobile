import 'package:flutter/material.dart';
import 'package:goedit/blocs/my_assets_page_bloc.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/pages/asset_details.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/ui/widgets/screens.dart';
import 'package:goedit/utils/global_navigation.dart';

class MyAssetsPage extends StatefulWidget {
  @override
  _MyAssetsPageState createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  FullWidthFormController _formController = FullWidthFormController();
  Asset _asset = new Asset();

  @override
  void initState() {
    myAssetsPageBloc.init();
    myAssetsPageBloc.getAllAssets();
    super.initState();
  }

  @override
  void dispose() {
    myAssetsPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // register listeners
    myAssetsPageBloc.isCreatingAsset.listen(
      (event) {
        _formController.switchIsLoading(true);
      },
    ).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });
    myAssetsPageBloc.asset.listen((event) {
      if (event != null) {
        myAssetsPageBloc.getAllAssets();
        _formController.switchIsLoading(false);
        _formController.changeCurrentScreen(true);
        _asset = new Asset();
      }
    }).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });

    Widget _buildCreateAssetForm() {
      return FullWidthFormScreen(
        actionButtonOneText: 'Save',
        actionButtonTwoText: 'Cancel',
        fullWidthFormController: _formController,
        headerTitle: 'Create New Asset',
        onActionButtonOnePress: () {
          if (_formController.validateForm()) {
            if (_asset.imageFile == null) {
              _formController.showToast('Cover image is required');
              return;
            }
            myAssetsPageBloc.createAsset(_asset);
          }
        },
        onActionButtonTwoPress: () => GlobalNavigation.key.currentState.pop(),
        onSuccessButtonPress: () => GlobalNavigation.key.currentState.pop(),
        onValueChange: (FullWidthFormState state) {
          _asset.title = state.title;
          _asset.description = state.description;
          _asset.price = state.price;
          _asset.currency = state.currency;
          _asset.imageFile = state.singleImage;
        },
        successScreenMessage: 'Success',
      );
    }

    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: myAssetsPageBloc.isLoadingAssets,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: myAssetsPageBloc.assets,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text('No assets available'),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return buildAssetTileCard(
                            snapshot.data.elementAt(index), () {
                          GlobalNavigation.key.currentState
                              .push(MaterialPageRoute(
                                  builder: (context) => AssetDetailsPage(
                                        asset: snapshot.data.elementAt(index),
                                      )));
                        });
                      });
                }
                return LoadSpinner();
              },
            );
          },
        ),
      );
    }

    Widget _buildCreateJobButton() {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: FlatButton(
          height: 50,
          color: Theme.of(context).primaryColor,
          child: Text('Create New Asset',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          onPressed: () => GlobalNavigation.key.currentState.push(
              MaterialPageRoute(builder: (context) => _buildCreateAssetForm())),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildSearchBar(
              color: Theme.of(context).primaryColor,
              onSearch: (String searchString) async {
                myAssetsPageBloc.getAllAssets(searchString: searchString);
                return [];
              },
              onCancelled: () => myAssetsPageBloc.getAllAssets()),
          _buildJobList(),
          _buildCreateJobButton(),
        ],
      ),
    );
  }
}
