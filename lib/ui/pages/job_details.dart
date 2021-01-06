import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_details_bloc.dart';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/ui/pages/profile_page.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
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
    Widget _buildHeader() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.job.title,
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            // description tag
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.job.description,
                style: TextStyle(fontSize: 13),
              ),
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
                        Text(
                          'Budget:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.job.currency +
                              ' ' +
                              widget.job.budget.toString(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                        Text(widget.job.bids.length.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _buildPlaceBidForm() {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // place bid heading
            Text(
              'Place Your Bid Here',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
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
            // create submit bid button
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: jobDetailsBloc.isCreatingBid,
                initialData: false,
                builder: (context, snapshot) {
                  return FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: snapshot.data
                        ? () {}
                        : () {
                            if (_formKey.currentState.validate()) {
                              jobDetailsBloc.createBid(_myBid);
                            }
                          },
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

    Widget _buildJobOwnerPanel() {
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
            ...List.generate(widget.job.bids.length, (index) {
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // user profile header
                      InkWell(
                        onTap: () {
                          GlobalNavigation.key.currentState
                              .push(MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                        body: ProfilePage(
                                            user: widget.job.bids
                                                .elementAt(index)
                                                .user),
                                      )));
                        },
                        child: Row(
                          children: <Widget>[
                            buildRoundedCornerImage(
                                imageUrl: widget.job.bids
                                    .elementAt(index)
                                    .user
                                    .imageUrl),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                widget.job.bids
                                    .elementAt(index)
                                    .user
                                    .unifiedName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.job.bids.elementAt(index).description),
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
                            widget.job.bids.elementAt(index).currency +
                                ' ' +
                                widget.job.bids
                                    .elementAt(index)
                                    .budget
                                    .toString(),
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
                                onPressed: () => jobDetailsBloc.acceptBid(widget
                                    .job.bids
                                    .elementAt(index)
                                    .sId
                                    .toString()),
                                color: Colors.green,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      );
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
                // check if owner viewing or not
                ...(jobDetailsBloc.isJobOfCurrentUser(widget.job)
                    ? [
                        StreamBuilder(
                            stream: jobDetailsBloc.acceptBidAction,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildRoundedCornerImage(
                                                  imageUrl: snapshot
                                                      .data.user.imageUrl),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  snapshot
                                                      .data.user.unifiedName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              'STATUS: ${snapshot.data.status != null ? snapshot.data.status.toLowerCase() : ''}'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // complete job or show that its already completed
                                          ...(snapshot.data.status ==
                                                  'COMPLETED'
                                              ? []
                                              : [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      FlatButton(
                                                          onPressed: () =>
                                                              jobDetailsBloc
                                                                  .completeJob(),
                                                          color: Colors.green,
                                                          child: Text(
                                                            'Complete Job',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
                                                    ],
                                                  ),
                                                ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return _buildJobOwnerPanel();
                            })
                      ]
                    : [
                        StreamBuilder(
                            stream: jobDetailsBloc.bid,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return _buildSubmittedBidStatus(snapshot.data);
                              }
                              return _buildPlaceBidForm();
                            }),
                      ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
