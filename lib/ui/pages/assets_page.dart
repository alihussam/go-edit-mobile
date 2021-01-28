import 'package:flutter/material.dart';
import 'package:goedit/blocs/assets_page_bloc.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/pages/asset_details.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/ui/widgets/screens.dart';
import 'package:goedit/utils/global_navigation.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  FullWidthFormController _formController = FullWidthFormController();
  Asset _asset = new Asset();

  @override
  void initState() {
    assetsPageBloc.init();
    assetsPageBloc.getAllAssets();
    super.initState();
  }

  @override
  void dispose() {
    assetsPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // register listeners
    assetsPageBloc.isCreatingAsset.listen(
      (event) {
        _formController.switchIsLoading(true);
      },
    ).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });
    assetsPageBloc.asset.listen((event) {
      if (event != null) {
        assetsPageBloc.getAllAssets();
        _formController.switchIsLoading(false);
        _formController.changeCurrentScreen(true);
        _asset = new Asset();
      }
    }).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });

    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: assetsPageBloc.isLoadingAssets,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: assetsPageBloc.assets,
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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildSearchBar(
              color: Theme.of(context).primaryColor,
              onSearch: (String searchString) async {
                assetsPageBloc.getAllAssets(searchString: searchString);
                return [];
              },
              onCancelled: () => assetsPageBloc.getAllAssets()),
          _buildJobList(),
        ],
      ),
    );
  }
}
