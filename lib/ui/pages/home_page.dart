import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/ui/pages/asset_details.dart';
import 'package:goedit/ui/pages/job_details.dart';
import 'package:goedit/ui/pages/profile_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/global_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // homeBloc.init();
    homeBloc.getTopRatedUsers();
    homeBloc.getAllJobs();
    homeBloc.getAllAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildUserProfileTile({@required User user}) {
      return Container(
        height: 100,
        width: 240,
        margin: EdgeInsets.only(left: 5),
        child: InkWell(
          onTap: () => {
            GlobalNavigation.key.currentState.push(MaterialPageRoute(
                builder: (context) => Scaffold(
                      body: ProfilePage(user: user),
                    )))
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  user.imageUrl,
                  fit: BoxFit.cover,
                  height: 80.0,
                  width: 80.0,
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    user.freelancerProfile.jobTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
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
                ],
              ),
            ],
          ),
        ),
      );
    }

    _buildHeaderOptions(
      String title,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  '',
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 2,
          ),
        ],
      );
    }

    _buildDesignersGrid() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOptions('Top Freelancers'),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 215,
              child: StreamBuilder(
                stream: homeBloc.users,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 7,
                      children: List.generate(snapshot.data.length, (index) {
                        return _buildUserProfileTile(
                            user: snapshot.data.elementAt(index));
                      }),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Some error occured'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    _buildRecommendedAssets() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOptions('New Assets'),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 200,
              child: StreamBuilder(
                stream: homeBloc.assets,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Asset> _assets =
                        snapshot.data != null ? snapshot.data : [];
                    if (_assets.length == 0) {
                      return Center(
                          child:
                              Text('There are currently no assets available'));
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _assets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: buildAssetTileCard(_assets[index], () {
                              GlobalNavigation.key.currentState.push(
                                  MaterialPageRoute(
                                      builder: (context) => AssetDetailsPage(
                                          asset: _assets[index])));
                            }),
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Some error occured'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    _buildRecommendedJobs() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOptions('New Jobs'),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 200,
              child: StreamBuilder(
                stream: homeBloc.jobs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Job> _assets =
                        snapshot.data != null ? snapshot.data : [];
                    if (_assets.length == 0) {
                      return Center(
                          child: Text('There are currently no jobs available'));
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _assets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: buildJobTileCard(_assets[index], () {
                              GlobalNavigation.key.currentState.push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          JobDetails(job: _assets[index])));
                            }),
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Some error occured'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(colors: [
              //     Theme.of(context).primaryColor,
              //     Theme.of(context).primaryColor.withOpacity(0.2)
              //   ]),
              // ),
              height: 200,
              padding: EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  Image.asset('assets/images/home_header.png'),
                  Positioned(
                      bottom: 5,
                      right: 2,
                      child: Text(
                        'On-Demand Talent',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
            _buildDesignersGrid(),
            // _buildCategoryGrid(),
            _buildRecommendedJobs(),
            _buildRecommendedAssets(),
          ],
        ),
      ),
    );
  }

  //   _buildCategoryCard(String title, LinearGradient gradient) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     margin: EdgeInsets.only(right: 10),
  //     padding: EdgeInsets.all(15),
  //     height: 120,
  //     decoration: BoxDecoration(
  //         gradient: gradient, borderRadius: BorderRadius.circular(20)),
  //     child: Text(
  //       title,
  //       style: TextStyle(
  //           color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

  // _buildCategoryGrid() {
  //   return Container(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         _buildHeaderOptions('Categories'),
  //         Container(
  //           margin: EdgeInsets.only(top: 20),
  //           height: 120,
  //           child: ListView(
  //             scrollDirection: Axis.horizontal,
  //             children: [
  //               _buildCategoryCard(
  //                   'Application Interface',
  //                   LinearGradient(colors: [
  //                     Colors.orange.withOpacity(0.8),
  //                     Colors.orange.withOpacity(0.6),
  //                     Colors.orange.withOpacity(0.4)
  //                   ])),
  //               _buildCategoryCard(
  //                   'Character Design',
  //                   LinearGradient(colors: [
  //                     Colors.purple.withOpacity(0.8),
  //                     Colors.purple.withOpacity(0.6),
  //                     Colors.purple.withOpacity(0.4)
  //                   ])),
  //               _buildCategoryCard(
  //                   'Visual Effects',
  //                   LinearGradient(colors: [
  //                     Colors.pink.withOpacity(0.8),
  //                     Colors.pink.withOpacity(0.6),
  //                     Colors.pink.withOpacity(0.4)
  //                   ])),
  //               _buildCategoryCard(
  //                   'UI Assets',
  //                   LinearGradient(colors: [
  //                     Colors.blue.withOpacity(0.8),
  //                     Colors.blue.withOpacity(0.6),
  //                     Colors.blue.withOpacity(0.4)
  //                   ])),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
