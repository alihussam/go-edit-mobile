import 'package:flutter/material.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/job.dart';

Widget buildRoundedCornerImage({
  String imageUrl = 'https://uifaces.co/our-content/donated/L7wQctBt.jpg',
  double height = 60.0,
  double width = 60.0,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.network(
      imageUrl,
      height: height,
      width: width,
    ),
  );
}

Widget buildJobTileCard(Job job) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              buildRoundedCornerImage(),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  job.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Container(
              height: 65,
              child: Text(job.description.length <= 100
                  ? job.description
                  : job.description.substring(0, 140) + '...')),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Budget:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    job.currency + ' ' + job.budget.toString(),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildAssetTileCard(Asset asset) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              buildRoundedCornerImage(),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  asset.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Container(
              height: 65,
              child: Text(asset.description.length <= 100
                  ? asset.description
                  : asset.description.substring(0, 140) + '...')),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Price:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    asset.currency + ' ' + asset.price.toString(),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget operationSuccessScafold(
    {String successMessage = 'Successful',
    String buttonText = 'Go Back',
    Function onPressed}) {
  return Scaffold(
    body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(successMessage),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget headerContainerBottomCurve(String title, Color color) {
  return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ));
}
