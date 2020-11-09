import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goedit/blocs/create_new_job_page_bloc.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';

class CreateNewJobPage extends StatefulWidget {
  @override
  _CreateNewJobPageState createState() => _CreateNewJobPageState();
}

class _CreateNewJobPageState extends State<CreateNewJobPage>
    with FieldValidators {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Job _job = new Job(currency: 'PKR');

  @override
  void initState() {
    createNewJobPageBloc.init(_key);
    super.initState();
  }

  @override
  void dispose() {
    createNewJobPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // attach a listener to pop on success
    createNewJobPageBloc.job.listen((event) {
      Timer(Duration(milliseconds: 500),
          () => GlobalNavigation.key.currentState.pop());
    });

    Future<bool> _willPopCallBack() async {
      return false;
    }

    Widget _buildPageHeader() {
      return Container(
          padding: EdgeInsets.all(40),
          child: Text(
            'Create New Job',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ));
    }

    Widget _buildFormFields() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildFormField(
              labelText: 'Title',
              validator: (value) => validateRequired(value),
              onChanged: (value) => {_job.title = value.trim()}),
          buildFormField(
              labelText: 'Description',
              maxLines: 5,
              validator: (value) => validateRequired(value),
              onChanged: (value) => {_job.description = value.trim()}),
          buildNumericOnlyFormField(
              labelText: 'Budget',
              validator: (value) => validateRequired(value),
              onChanged: (String value) =>
                  {_job.budget = double.parse(value.trim())}),
          DropdownButton(
              hint: Text('Currency'),
              icon: Icon(Icons.money),
              isExpanded: true,
              value: _job.currency,
              items: ['PKR', 'USD']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) => {
                    setState(() {
                      _job.currency = value;
                    }),
                  }),
          // buildFormField(
          //     labelText: 'Currency',
          //     validator: (value) => validateRequired(value),
          //     onChanged: (value) => {_job.currency = value.trim()}),
        ],
      );
    }

    Widget _buildActionButtonBar() {
      return Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          initialData: false,
          stream: createNewJobPageBloc.isCreatingJob,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner(
                size: 10,
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        createNewJobPageBloc.createJob(_job);
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlineButton(
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                    onPressed: () => GlobalNavigation.key.currentState.pop(),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return WillPopScope(
      onWillPop: _willPopCallBack,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          bottomNavigationBar: Container(
            child: _buildActionButtonBar(),
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPageHeader(),
                    _buildFormFields(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
