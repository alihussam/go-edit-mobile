import 'package:flutter/material.dart';
import 'package:goedit/blocs/my_assets_page_bloc.dart';
import 'package:goedit/ui/pages/create_new_asset_page.dart';
import 'package:goedit/ui/pages/create_new_job_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/global_navigation.dart';

class MyAssetsPage extends StatefulWidget {
  @override
  _MyAssetsPageState createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
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
                            snapshot.data.elementAt(index));
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
              MaterialPageRoute(builder: (context) => CreateNewAssetPage())),
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
