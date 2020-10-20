import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    homeBloc.getAllJobs();
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
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(jobTitle),
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
              'More',
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      _buildUserProfileTile(
                        name: 'Muzi Zuishuai',
                        jobTitle: "Graphic Designer",
                        imageUrl:
                            "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/125296371/original/653cc81872119844644e33d40f5afd9bd61743b6/create-cool-cartoon-avatars.jpg",
                      ),
                      SizedBox(height: 10),
                      _buildUserProfileTile(
                        name: 'FanatasyU',
                        jobTitle: "Motion Artist",
                        imageUrl:
                            "https://store.playstation.com/store/api/chihiro/00_09_000/container/IS/en/999/EP2402-CUSA05624_00-AV00000000000213/1601168968000/image?w=240&h=240&bg_color=000000&opacity=100&_version=00_09_000",
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _buildUserProfileTile(
                        name: 'Dazy',
                        jobTitle: "Illustrator",
                        imageUrl:
                            "https://avatarfiles.alphacoders.com/162/162492.png",
                      ),
                      SizedBox(height: 10),
                      _buildUserProfileTile(
                        name: 'Rito Gami',
                        jobTitle: "Anime Artist",
                        imageUrl:
                            "https://i.pinimg.com/236x/c0/c5/9b/c0c59bcebb8312aea75f3234fcd532e7.jpg",
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _buildUserProfileTile(
                        name: 'Living In Fantasy',
                        jobTitle: "VFX",
                        imageUrl:
                            "https://www.gameindustrycareerguide.com/wp-content/uploads/2017/12/visual-effects-nathaniel-hubbell-1000x480.jpg",
                      ),
                      SizedBox(height: 10),
                      _buildUserProfileTile(
                        name: 'Echos',
                        jobTitle: "Motion Artist",
                        imageUrl:
                            "https://www.wallpaperflare.com/static/829/954/430/astronaut-artwork-dark-space-art-wallpaper.jpg",
                      ),
                    ],
                  ),
                ],
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

    _buildAssetCard(String title, String imageUrl) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(15),
        height: 120,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(imageUrl)),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          title,
          style: TextStyle(
              backgroundColor: Colors.black,
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
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
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAssetCard('Leet Ui Kit',
                      "https://www.webdesignerdepot.com/cdn-origin/uploads/2015/02/015.jpg"),
                  _buildAssetCard('3D Asset Characters',
                      "https://i.pinimg.com/originals/1f/14/9a/1f149a35b5bc46839cabed5559970702.jpg"),
                  _buildAssetCard('Low Poly Pack',
                      "https://www.lowpolylab.net/wp-content/uploads/edd/2018/03/Low_Poly_Peoples_3D_Characters-1180x944.png"),
                ],
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
            // buildSearchBar(
            //     color: Theme.of(context).primaryColor,
            //     onSearch: (String searchString) async {
            //       homeBloc.getAllJobs(searchString: searchString);
            //       return [];
            //     },
            //     onCancelled: () => homeBloc.getAllJobs()),
            _buildDesignersGrid(),
            _buildCategoryGrid(),
            _buildRecommendedAssets(),
            // _buildJobList(),
          ],
        ),
      ),
    );
  }
}
