import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_page_bloc.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  void initState() {
    jobPageBloc.init();
    jobPageBloc.getAllJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildJobList() {
      return Expanded(
        child: StreamBuilder(
          initialData: false,
          stream: jobPageBloc.isLoadingJobs,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner();
            }
            return StreamBuilder(
              stream: jobPageBloc.jobs,
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

    Widget _buildCreateJobButton() {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: FlatButton(
          height: 40,
          color: Theme.of(context).primaryColor,
          child: Text('Create new job',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          onPressed: () {},
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildSearchBar(
              onSearch: (String searchString) async {
                jobPageBloc.getAllJobs(searchString: searchString);
                return [];
              },
              onCancelled: () => jobPageBloc.getAllJobs()),
          _buildJobList(),
        ],
      ),
    );
  }
}
