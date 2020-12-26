import 'package:flutter/material.dart';
import 'package:goedit/models/asset.dart';

class AssetDetailsPage extends StatefulWidget {
  final Asset asset;

  AssetDetailsPage({@required this.asset});

  @override
  _AssetDetailsPageState createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage> {
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
          ],
        ),
      );
    }

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderImage(widget.asset),
              _buildBody(widget.asset),
            ],
          ),
        ),
      ),
    ));
  }
}
