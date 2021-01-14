import 'package:flutter/material.dart';
import 'package:goedit/blocs/desginers_page_bloc.dart';
import 'package:goedit/ui/pages/profile_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/global_navigation.dart';

class DesignersPage extends StatefulWidget {
  @override
  _DesignersPageState createState() => _DesignersPageState();
}

class _DesignersPageState extends State<DesignersPage> {
  @override
  void initState() {
    designersPageBloc.init();
    designersPageBloc.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: designersPageBloc.isLoadingUsers,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: designersPageBloc.users,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text('No designers found'),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return buildUserTileCard(
                            snapshot.data.elementAt(index),
                            () => GlobalNavigation.key.currentState
                                .push(MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          body: ProfilePage(
                                              user: snapshot.data
                                                  .elementAt(index)),
                                        ))));
                      });
                }
                return LoadSpinner();
              },
            );
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildSearchBar(
              color: Theme.of(context).primaryColor,
              onSearch: (String searchString) async {
                designersPageBloc.getAllUsers(searchString: searchString);
                return [];
              },
              onCancelled: () => designersPageBloc.getAllUsers()),
          _buildJobList(),
        ],
      ),
    );
  }
}
