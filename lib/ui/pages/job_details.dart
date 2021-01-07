import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_details_bloc.dart';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/ui/pages/profile_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';

class JobDetails extends StatefulWidget {
  final Job job;

  JobDetails({@required this.job});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> with FieldValidators {
  Bid _myBid;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _myBid = new Bid(currency: 'PKR', job: widget.job.sId);
    jobDetailsBloc.init(_key, widget.job);
    super.initState();
  }

  @override
  void dispose() {
    jobDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// build job header
    Widget _buildHeader() {
      return Container(
        child: StreamBuilder(
          stream: jobDetailsBloc.currentJob,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Job _job = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_job.title, style: TextStyle(fontSize: 28)),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  // description tag
                  Container(
                    padding: EdgeInsets.all(10),
                    child:
                        Text(_job.description, style: TextStyle(fontSize: 13)),
                  ),
                  // budget and bid count
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // budget
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Budget:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 5),
                              Text(
                                  _job.currency + ' ' + _job.budget.toString()),
                            ],
                          ),
                          SizedBox(height: 10),
                          // bid count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of bids:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(_job.bids.length.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: LoadSpinner(),
              ),
            );
          },
        ),
      );
    }

    Widget _buildPlaceBidForm(Job currentJob) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Place Your Bid Here',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildFormField(
                      labelText: 'Description',
                      maxLines: 5,
                      validator: (value) => validateRequired(value),
                      onChanged: (value) =>
                          {_myBid.description = value.trim()}),
                  buildNumericOnlyFormField(
                      labelText: 'Price',
                      validator: (value) => validateRequired(value),
                      onChanged: (String value) =>
                          {_myBid.budget = double.parse(value.trim())}),
                  DropdownButton(
                      hint: Text('Currency'),
                      icon: Icon(Icons.money),
                      isExpanded: true,
                      value: _myBid.currency,
                      items: ['PKR', 'USD']
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) => {
                            setState(() {
                              _myBid.currency = value;
                            }),
                          }),
                ],
              ),
            ),
            SizedBox(height: 10),
            // create submit bid button
            StreamBuilder(
                stream: jobDetailsBloc.isCreatingBid,
                initialData: false,
                builder: (context, snapshot) {
                  return FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: !snapshot.data
                        ? () {
                            if (_formKey.currentState.validate()) {
                              jobDetailsBloc.createBid(_myBid);
                            }
                          }
                        : null,
                    child: snapshot.data
                        ? CircularProgressIndicator()
                        : Text(
                            'Submit bid',
                            style: TextStyle(color: Colors.white),
                          ),
                    color: Theme.of(context).primaryColor,
                  );
                })
          ],
        ),
      );
    }

    Widget _buildSubmittedBidStatus(Bid bid) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // place bid heading
            Text(
              'Bid Sumbitted',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'Bid status',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    bid.status.toUpperCase(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _buildBidTile(Bid bid) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // user profile header
              InkWell(
                onTap: () {
                  GlobalNavigation.key.currentState.push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            body: ProfilePage(user: bid.user),
                          )));
                },
                child: Row(
                  children: <Widget>[
                    buildRoundedCornerImage(
                        imageUrl:
                            bid.user.imageUrl != null ? bid.user.imageUrl : ''),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        bid.user.unifiedName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(bid.description),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bid Amount:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    bid.currency + ' ' + bid.budget.toString(),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () {},
                      child: FlatButton(
                        child: Text('Message',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                        color: Colors.blue,
                      )),
                  FlatButton(
                      onPressed: () {},
                      child: FlatButton(
                        child: Text('Accept',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () =>
                            jobDetailsBloc.acceptBid(bid.sId.toString()),
                        color: Colors.green,
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildBidList(Job job) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Placed Bids',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            // create a list of bids
            ...List.generate(job.bids.length, (index) {
              return _buildBidTile(job.bids.elementAt(index));
            })
          ],
        ),
      );
    }

    Widget _buildAuthorJobControls(Job job) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    buildRoundedCornerImage(
                        imageUrl: job.getAcceptedBid().user.imageUrl),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        job.getAcceptedBid().user.unifiedName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Text(
                //     'STATUS: ${job.getAcceptedBid().status != null ? snapshot.data.status.toLowerCase() : ''}'),
                SizedBox(
                  height: 10,
                ),
                // complete job or show that its already completed
                // ...(snapshot.data.status == 'COMPLETED'
                //     ? []
                //     : [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             FlatButton(
                //                 onPressed: () => jobDetailsBloc.completeJob(),
                //                 color: Colors.green,
                //                 child: Text(
                //                   'Complete Job',
                //                   style: TextStyle(color: Colors.white),
                //                 ))
                //           ],
                //         ),
                //       ]),
              ],
            ),
          ),
        ),
      );
    }

    // Bidders view
    _buildBiddersview() {
      return StreamBuilder(
          stream: jobDetailsBloc.currentJob,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Job _job = snapshot.data;
              // first check if the job already has hiring
              // then check if current user has already placed a bid or
              return _job.hasAcceptedBid()
                  ? Text('Bid placed already')
                  : jobDetailsBloc.isMyBidPlaced(_job)
                      ? _buildSubmittedBidStatus(
                          jobDetailsBloc.getMyBidPlaced(_job))
                      : _buildPlaceBidForm(_job);
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: LoadSpinner(),
              ),
            );
          });
    }

    /// Job author view
    _buildJobAutherView() {
      return StreamBuilder(
          stream: jobDetailsBloc.currentJob,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Job _job = snapshot.data;
              // first check if the job already has hiring
              // then check if current user has already placed a bid or
              return _job.hasAcceptedBid()
                  ? _buildAuthorJobControls(_job)
                  : _buildBidList(_job);
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: LoadSpinner(),
              ),
            );
          });
    }

    /// render view based on the user
    Widget _renderViewBasedOnUser(Job job) {
      return jobDetailsBloc.isJobOfCurrentUser(widget.job)
          ? _buildJobAutherView()
          : _buildBiddersview();
    }

    return Scaffold(
      key: _key,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _renderViewBasedOnUser(widget.job),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
