import 'package:flutter/material.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/ui/pages/home_page.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/ui/widgets/minimal_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DrawerMenuOptionModel> _drawerOptions = [
    DrawerMenuOptionModel(
        'Home', Icons.home, () => homeBloc.changeActivePage(0)),
    // DrawerMenuOptionModel(
    //     'My Profile', Icons.account_circle, () => homeBloc.changeActivePage(1)),
  ];

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
    final List<Widget> _pages = [
      HomePage(),
      Container(
        child: Text('Profile'),
      )
    ];
    return Scaffold(
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
                    profileImageUrl:
                        'https://uifaces.co/our-content/donated/L7wQctBt.jpg',
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
