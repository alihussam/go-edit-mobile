import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/home.dart';
import 'package:goedit/models/job.dart';
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
    Widget _buildHomePageHeader() {
      return Container(
        height: 150,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Home',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SearchBar(
                  onSearch: (String searchString) async {
                    homeBloc.getAllJobs(searchString: searchString);
                    return [];
                  },
                  onCancelled: () => homeBloc.getAllJobs(),
                  onItemFound: null),
            ),
          ],
        ),
      );
    }

    Widget _buildJobTile(Job job) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://uifaces.co/our-content/donated/L7wQctBt.jpg',
                      height: 60.0,
                      width: 60.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      job.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Container(
                  height: 65,
                  child: Text(job.description.length <= 100
                      ? job.description
                      : job.description.substring(0, 140) + '...')),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Budget:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        job.currency + ' ' + job.budget.toString(),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

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
                        return _buildJobTile(snapshot.data.elementAt(index));
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
          _buildHomePageHeader(),
          _buildJobList(),
        ],
      ),
    );
  }
}
