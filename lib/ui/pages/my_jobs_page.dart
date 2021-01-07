import 'package:flutter/material.dart';
import 'package:goedit/blocs/my_jobs_page_bloc.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/ui/pages/job_details.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/ui/widgets/screens.dart';
import 'package:goedit/utils/global_navigation.dart';

class MyJobsPage extends StatefulWidget {
  @override
  _MyJobsPageState createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  FullWidthFormController _formController = FullWidthFormController();
  Job _job = new Job();
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
    // register listeners

    myJobsPageBloc.isCreatingJob.listen(
      (event) {
        _formController.switchIsLoading(true);
      },
    ).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });
    myJobsPageBloc.job.listen((event) {
      if (event != null) {
        myJobsPageBloc.getAllJobs();
        _formController.switchIsLoading(false);
        _formController.changeCurrentScreen(true);
        _job = new Job();
      }
    }).onError((error) {
      _formController.showToast(error);
      _formController.switchIsLoading(false);
    });

    Widget _buildCreateJobForm() {
      return FullWidthFormScreen(
        actionButtonOneText: 'Save',
        actionButtonTwoText: 'Cancel',
        fullWidthFormController: _formController,
        headerTitle: 'Create New Job',
        buildImageInput: false,
        onActionButtonOnePress: () {
          if (_formController.validateForm()) {
            myJobsPageBloc.createJob(_job);
          }
        },
        onActionButtonTwoPress: () => GlobalNavigation.key.currentState.pop(),
        onSuccessButtonPress: () => GlobalNavigation.key.currentState.pop(),
        onValueChange: (FullWidthFormState state) {
          _job.title = state.title;
          _job.description = state.description;
          _job.budget = state.price;
          _job.currency = state.currency;
        },
        successScreenMessage: 'Success',
      );
    }

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
                        return buildJobTileCard(
                            snapshot.data.elementAt(index),
                            () => GlobalNavigation.key.currentState.push(
                                MaterialPageRoute(
                                    builder: (context) => JobDetails(
                                        job: snapshot.data.elementAt(index)))));
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
              MaterialPageRoute(builder: (context) => _buildCreateJobForm())),
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
