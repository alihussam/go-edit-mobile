import 'package:flutter/material.dart';
import 'package:goedit/blocs/asset_details_bloc.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetDetailsPage extends StatefulWidget {
  final Asset asset;

  AssetDetailsPage({@required this.asset});

  @override
  _AssetDetailsPageState createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage>
    with FieldValidators {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _creditCardFormKey = new GlobalKey<FormState>();
  String ccNumber;
  String ccHolder;
  String ccCvv;

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
            Divider(),
            SizedBox(
              height: 20,
            ),
            Text(asset.description),
            SizedBox(
              height: 20,
            ),
            // check if asset exist if not show add asset
            ...(assetDetailsBloc.isAssetOfCurrentUser() ||
                    assetDetailsBloc.isAssetBought()
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
                    FlatButton(
                        onPressed: () async {
                          _buildPaymentModal();
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Buy',
                          style: TextStyle(color: Colors.white),
                        ))
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

  _buildPaymentModal() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    if (_creditCardFormKey.currentState.validate()) {
                      GlobalNavigation.key.currentState.pop();
                      assetDetailsBloc.buy();
                      // jobDetailsBloc.completeJob(ccNumber, ccHolder, ccCvv);
                    }
                  },
                  child: Text('Submit')),
            ],
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _creditCardFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Payment Info'),
                      SizedBox(
                        height: 10,
                      ),
                      buildFormField(
                          labelText: 'Credit Card Number',
                          controller: ccNumberMask,
                          validator: (value) => ccNumberValidate(value),
                          onChanged: (value) => ccNumber = value.trim()),
                      buildFormField(
                          labelText: 'Card Holder Name',
                          validator: (value) => validateRequired(value),
                          onChanged: (value) => ccHolder = value.trim()),
                      buildFormField(
                          labelText: 'CVV',
                          validator: (value) => ccCvvValidate(value),
                          controller: ccCvvMask,
                          onChanged: (value) => ccCvv = value.trim()),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
