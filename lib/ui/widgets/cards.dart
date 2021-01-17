import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/user.dart';

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

Widget buildJobTileCard(Job job, Function onPress) {
  return Card(
    child: InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                buildRoundedCornerImage(imageUrl: job.user.imageUrl),
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
    ),
  );
}

Widget buildAssetTileCard(Asset asset, Function onPress) {
  return Card(
    semanticContainer: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: InkWell(
      onTap: onPress,
      child: Container(
        height: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFdadadf), Color(0xFFe9e9ec).withOpacity(0.5)]),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // asset image
            Expanded(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  asset.imageUrls.length > 0 ? asset.imageUrls[0] : '',
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        asset.title,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          // fontSize: 13.0,
                          // color: new Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'By ${asset.user.unifiedName}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 10.0,
                          // color: new Color(0xFF212121),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: RatingBarIndicator(
                        rating: asset.avgRating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12,
                        direction: Axis.horizontal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: onPress,
                        color: Color(0xFF333738),
                        child: Text(
                          asset.isCurrentUsersAsset
                              ? 'View'
                              : 'Buy ${asset.currency + asset.price.toString()}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildUserTileCard(User user, Function onPress) {
  return Card(
    child: InkWell(
      onTap: onPress,
      child: Container(
        height: 130,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFdadadf), Color(0xFFe9e9ec).withOpacity(0.5)]),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              // padding: EdgeInsets.all(),
              height: 120,
              width: 120,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  user.imageUrl,
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ),
            // SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      user.shortName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // SizedBox(
                  //   height: 6,
                  // ),
                  Text(
                    user.freelancerProfile.jobTitle != ''
                        ? user.freelancerProfile.jobTitle
                        : '(No Job Title)',
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(
                  //   height: 6,
                  // ),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: user.freelancerProfile.rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemSize: 14,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: null,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('(${user.freelancerProfile.ratingCount})'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
