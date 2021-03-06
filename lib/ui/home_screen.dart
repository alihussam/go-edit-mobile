import 'package:flutter/material.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/ui/pages/assets_page.dart';
import 'package:goedit/ui/pages/designers_page.dart';
import 'package:goedit/ui/pages/home_page.dart';
import 'package:goedit/ui/pages/jobs_history_page.dart';
import 'package:goedit/ui/pages/jobs_page.dart';
import 'package:goedit/ui/pages/my_assets_page.dart';
import 'package:goedit/ui/pages/my_jobs_page.dart';
import 'package:goedit/ui/pages/chats_page.dart';
import 'package:goedit/ui/pages/profile_page.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/ui/widgets/minimal_drawer.dart';
import 'package:goedit/utils/global_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    homeBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerMenuOptionModel> _drawerOptions = [
      DrawerMenuOptionModel(
          'Home',
          Icons.home,
          () => {
                homeBloc.changeActivePage(0),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'Designers',
          Icons.supervised_user_circle_sharp,
          () => {
                homeBloc.changeActivePage(1),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'Jobs',
          Icons.work,
          () => {
                homeBloc.changeActivePage(2),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'Jobs History',
          Icons.work_outline_outlined,
          () => {
                homeBloc.changeActivePage(3),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'My Jobs',
          Icons.work_outline,
          () => {
                homeBloc.changeActivePage(4),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'Assets',
          Icons.cloud_download,
          () => {
                homeBloc.changeActivePage(5),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'My/Bought Assets',
          Icons.cloud_download,
          () => {
                homeBloc.changeActivePage(6),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'Messages',
          Icons.message,
          () => {
                homeBloc.changeActivePage(7),
                GlobalNavigation.key.currentState.pop(),
              }),
      DrawerMenuOptionModel(
          'My Profile',
          Icons.account_circle,
          () => {
                homeBloc.changeActivePage(8),
                GlobalNavigation.key.currentState.pop(),
              }),
    ];

    final List<Widget> _pages = [
      HomePage(),
      DesignersPage(),
      JobPage(),
      JobHistoryPage(),
      MyJobsPage(),
      AssetsPage(),
      MyAssetsPage(),
      ChatPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.black, fontSize: 20),
        ),
        title: StreamBuilder(
            initialData: 0,
            stream: homeBloc.activePageIndex,
            builder: (context, snapshot) {
              return Text(_drawerOptions
                  .elementAt(snapshot.hasData ? snapshot.data : 0)
                  .title);
            }),
      ),
      drawer: StreamBuilder(
        initialData: 0,
        stream: homeBloc.activePageIndex,
        builder: (context, snapshot) {
          return MinimalDrawer(
            drawerHeader: StreamBuilder(
              stream: homeBloc.userProfile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MinimalDrawerHeader(
                    profileImageUrl: snapshot.data.imageUrl,
                    email: snapshot.data.email,
                    name: snapshot.data.unifiedName,
                  );
                }
                return LoadSpinner();
              },
            ),
            drawerOptions: _drawerOptions,
            activeOptionIndex: snapshot.hasData ? snapshot.data : 0,
            activeColor: Theme.of(context).primaryColor,
            onLogoutButtonPressed: () => homeBloc.logout(),
          );
        },
      ),
      body: StreamBuilder(
          initialData: 0,
          stream: homeBloc.activePageIndex,
          builder: (context, snapshot) {
            return _pages.elementAt(snapshot.hasData ? snapshot.data : 0);
          }),
    );
  }
}
