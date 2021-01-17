import 'package:flutter/material.dart';
import 'package:goedit/blocs/asset_details_bloc.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetDetailsPage extends StatefulWidget {
  final Asset asset;

  AssetDetailsPage({@required this.asset});

  @override
  _AssetDetailsPageState createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    assetDetailsBloc.init(_key, widget.asset);
    super.initState();
  }

  @override
  void dispose() {
    assetDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildHeaderImage(Asset asset) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  asset.imageUrls.length > 0 ? asset.imageUrls[0] : '')),
        ),
      );
    }

    Widget _buildBody(Asset asset) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    asset.title +
                        'afdasd afsdad fashker erthwlj v alkjhjfh aksldhfla dadfkajn garulhas lsjdfkaks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Text('Price',
                          style: TextStyle(
                              fontSize: 14, color: Colors.green[700])),
                      SizedBox(
                        height: 8,
                      ),
                      Text(asset.currency + ' ' + asset.price.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(asset.description),
            SizedBox(
              height: 20,
            ),
            // check if asset exist if not show add asset
            ...(asset.resourceUrl != null
                ? [
                    FlatButton(
                        onPressed: () async {
                          if (await canLaunch(asset.resourceUrl)) {
                            launch(asset.resourceUrl);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Download Asset',
                          style: TextStyle(color: Colors.white),
                        ))
                  ]
                : [
                    SingleImageInput(
                      onImageSelect: (file) {
                        assetDetailsBloc.updateResource(file);
                      },
                      isShowPlaceHolderImage: false,
                      placeHolderText: '+ Add asset resource',
                    ),
                  ]),
          ],
        ),
      );
    }

    return SafeArea(
        child: Scaffold(
      key: _key,
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder(
            stream: assetDetailsBloc.currentAsset,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                  child: LoadSpinner(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderImage(snapshot.data),
                    _buildBody(snapshot.data),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ));
  }
}
