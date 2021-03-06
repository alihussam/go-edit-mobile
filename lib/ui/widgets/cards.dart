import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/rating.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/ui/widgets/inputs/profileview_image_picker.dart';

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
            Divider(),
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
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 10),
                    //   child: RatingBarIndicator(
                    //     rating: asset.avgRating,
                    //     itemBuilder: (context, index) => Icon(
                    //       Icons.star,
                    //       color: Colors.amber,
                    //     ),
                    //     itemCount: 5,
                    //     itemSize: 12,
                    //     direction: Axis.horizontal,
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: onPress,
                        color: Color(0xFF333738),
                        child: Text(
                          '${asset.currency + asset.price.toString()}',
                          // asset.isCurrentUsersAsset
                          //     ? 'View'
                          //     : 'Buy ${asset.currency + asset.price.toString()}',
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
      height: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFdadadf), Color(0xFFe9e9ec).withOpacity(0.5)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                child: ProfileViewImagePicker(
                  isViewOnly: true,
                  imageUrl: user.imageUrl,
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.unifiedName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.freelancerProfile.jobTitle != ''
                            ? user.freelancerProfile.jobTitle
                            : '-',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ratings
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: user.freelancerProfile.rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemSize: 12,
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
                      Text(
                        '(${user.freelancerProfile.ratingCount})',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

Widget buildRatingCard(Rating rating, String cardTitle) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      child: ProfileViewImagePicker(
                        isViewOnly: true,
                        imageUrl: rating.user.imageUrl,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rating.user.shortName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          rating.user.freelancerProfile.jobTitle,
                          style: TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingBar.builder(
                      initialRating: rating.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemSize: 12,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (value) {
                        rating.rating = value;
                      },
                    ),
                    Container(
                      height: 15,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40)),
                        border: Border.all(
                          width: 0.4,
                          color: Colors.amber,
                          // color: Colors.green,
                          // style: BorderStyle.solid)),
                        ),
                      ),
                      child: Center(
                          child: Text(rating.rating.toString(),
                              style: TextStyle(fontSize: 8))),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 15),
            Text(
              rating.text,
              style: TextStyle(fontSize: 12),
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
