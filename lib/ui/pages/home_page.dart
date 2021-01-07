import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/pages/asset_details.dart';
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
    homeBloc.getAllAssets();
    homeBloc.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildUserProfileTile({
      @required String imageUrl,
      @required String name,
      @required String jobTitle,
    }) {
      return Container(
        height: 100,
        width: 240,
        margin: EdgeInsets.only(left: 5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imageUrl,
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
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  jobTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      );
    }

    _buildHeaderOptions(
      String title,
    ) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
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
      );
    }

    _buildDesignersGrid() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOptions('Designers'),
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
                          name: snapshot.data.elementAt(index).shortName,
                          jobTitle: snapshot.data
                                          .elementAt(index)
                                          .freelancerProfile !=
                                      null &&
                                  snapshot.data
                                          .elementAt(index)
                                          .freelancerProfile
                                          .jobTitle !=
                                      null
                              ? snapshot.data
                                  .elementAt(index)
                                  .freelancerProfile
                                  .jobTitle
                              : ' - ',
                          imageUrl: snapshot.data.elementAt(index).imageUrl,
                        );
                      }),
                    );
                    // return ListView.builder(
                    //     itemCount: snapshot.data.length,
                    //     itemBuilder: (context, index) {
                    //       return Column(
                    //         children: [
                    //           SizedBox(height: 10),
                    //           _buildUserProfileTile(
                    //             name: 'FanatasyU',
                    //             jobTitle: "Motion Artist",
                    //             imageUrl:
                    //                 "https://store.playstation.com/store/api/chihiro/00_09_000/container/IS/en/999/EP2402-CUSA05624_00-AV00000000000213/1601168968000/image?w=240&h=240&bg_color=000000&opacity=100&_version=00_09_000",
                    //           ),
                    //         ],
                    //       );
                    //     });
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

    _buildCategoryCard(String title, LinearGradient gradient) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(15),
        height: 120,
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(20)),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    _buildCategoryGrid() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderOptions('Categories'),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard(
                      'Application Interface',
                      LinearGradient(colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.orange.withOpacity(0.6),
                        Colors.orange.withOpacity(0.4)
                      ])),
                  _buildCategoryCard(
                      'Character Design',
                      LinearGradient(colors: [
                        Colors.purple.withOpacity(0.8),
                        Colors.purple.withOpacity(0.6),
                        Colors.purple.withOpacity(0.4)
                      ])),
                  _buildCategoryCard(
                      'Visual Effects',
                      LinearGradient(colors: [
                        Colors.pink.withOpacity(0.8),
                        Colors.pink.withOpacity(0.6),
                        Colors.pink.withOpacity(0.4)
                      ])),
                  _buildCategoryCard(
                      'UI Assets',
                      LinearGradient(colors: [
                        Colors.blue.withOpacity(0.8),
                        Colors.blue.withOpacity(0.6),
                        Colors.blue.withOpacity(0.4)
                      ])),
                ],
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
            _buildHeaderOptions('Recommended Assets'),
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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildDesignersGrid(),
            _buildCategoryGrid(),
            _buildRecommendedAssets(),
          ],
        ),
      ),
    );
  }
}
