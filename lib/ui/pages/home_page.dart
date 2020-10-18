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
    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: homeBloc.isLoadingJobs,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: homeBloc.jobs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text('No jobs found'),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return buildJobTileCard(snapshot.data.elementAt(index));
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
        children: <Widget>[
          buildSearchBar(
              onSearch: (String searchString) async {
                homeBloc.getAllJobs(searchString: searchString);
                return [];
              },
              onCancelled: () => homeBloc.getAllJobs()),
          _buildJobList(),
        ],
      ),
    );
  }
}
