import 'package:flutter/material.dart';

/// Drawer Menu Option Model
class DrawerMenuOptionModel {
  final String title;
  final IconData icon;
  final Function onTap;
  DrawerMenuOptionModel(this.title, this.icon, this.onTap);
}

/// Minimal Drawer
class MinimalDrawer extends StatelessWidget {
  final Widget drawerHeader;
  final List<DrawerMenuOptionModel> drawerOptions;
  final int activeOptionIndex;
  final Color activeColor;
  final bool showLogoutButton;
  final Function onLogoutButtonPressed;

  MinimalDrawer(
      {@required this.drawerHeader,
      @required this.drawerOptions,
      this.activeOptionIndex,
      this.showLogoutButton = true,
      this.onLogoutButtonPressed,
      this.activeColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerOption(DrawerMenuOptionModel option, bool isActive) {
      Color color = isActive ? activeColor : Colors.grey;
      return ListTile(
        title: Text(
          option.title,
          style: TextStyle(color: color),
        ),
        leading: Icon(
          option.icon,
          color: color,
        ),
        onTap: option.onTap,
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
          child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            drawerHeader,
            // menup options
            Expanded(
              child: ScrollConfiguration(
                behavior: RemoveScrollGlowBehavior(),
                child: ListView.builder(
                    itemCount: drawerOptions.length,
                    itemBuilder: (context, index) {
                      return _buildDrawerOption(drawerOptions.elementAt(index),
                          index == activeOptionIndex);
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _buildDrawerOption(
                  DrawerMenuOptionModel(
                      'Logout', Icons.exit_to_app, onLogoutButtonPressed),
                  false),
            ),
          ],
        ),
      )),
    );
  }
}

/// Minimal Drawer Header
class MinimalDrawerHeader extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String email;

  MinimalDrawerHeader({
    @required this.profileImageUrl,
    @required this.name,
    @required this.email,
  });

  @override
  Widget build(BuildContext context) {
    Widget _buildProfileImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          profileImageUrl,
          fit: BoxFit.cover,
          height: 100.0,
          width: 100.0,
        ),
      );
    }

    Widget _buildInfoSection() {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(email)
            ],
          ));
    }

    Widget _buildEnd() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Divider(
          thickness: 2,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileImage(),
          _buildInfoSection(),
          _buildEnd()
        ],
      ),
    );
  }
}

// custom remove scroll glow behavior
class RemoveScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
