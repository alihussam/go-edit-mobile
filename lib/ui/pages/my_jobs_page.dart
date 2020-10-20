import 'package:flutter/material.dart';
import 'package:goedit/blocs/my_jobs_page_bloc.dart';
import 'package:goedit/ui/pages/create_new_job_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/global_navigation.dart';

class MyJobsPage extends StatefulWidget {
  @override
  _MyJobsPageState createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  @override
  void initState() {
    myJobsPageBloc.init();
    myJobsPageBloc.getAllJobs();
    super.initState();
  }

  @override
  void dispose() {
    myJobsPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: myJobsPageBloc.isLoadingJobs,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: myJobsPageBloc.jobs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text('No job found'),
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

    Widget _buildCreateJobButton() {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: FlatButton(
          height: 50,
          color: Theme.of(context).primaryColor,
          child: Text('Create new job',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          onPressed: () => GlobalNavigation.key.currentState.push(
              MaterialPageRoute(builder: (context) => CreateNewJobPage())),
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
                myJobsPageBloc.getAllJobs(searchString: searchString);
                return [];
              },
              onCancelled: () => myJobsPageBloc.getAllJobs()),
          _buildJobList(),
          _buildCreateJobButton(),
        ],
      ),
    );
  }
}
