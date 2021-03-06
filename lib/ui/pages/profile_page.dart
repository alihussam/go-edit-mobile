import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/blocs/profile_page_bloc.dart';
import 'package:goedit/models/employerProfile.dart';
import 'package:goedit/models/freelancerProfile.dart';
import 'package:goedit/models/name.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/ui/pages/chats_page.dart';
import 'package:goedit/ui/widgets/curve.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/inputs/gridview_image_picker.dart';
import 'package:goedit/ui/widgets/inputs/profileview_image_picker.dart';
import 'package:goedit/ui/widgets/loading.dart';
// import 'package:flutter_tags/flutter_tags.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';
import 'package:goedit/ui/widgets/cards.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with FieldValidators {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _creditCardFormKey = new GlobalKey<FormState>();
  User updatedProfile = new User();
  String accountNumber;
  double amount;

  @override
  void initState() {
    profilePageBloc.init(widget.user);
    profilePageBloc
        .getProfile(widget.user != null ? {'user': widget.user.sId} : {});
    super.initState();
  }

  @override
  void dispose() {
    profilePageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create update profile button
    Widget _createUpdateProfileButton() {
      return Positioned(
        right: 10,
        child: StreamBuilder(
          stream: profilePageBloc.isUpdatingProfile,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data) {
              return IconButton(
                icon: CircularProgressIndicator(),
                onPressed: null,
              );
            }
            return StreamBuilder(
                initialData: false,
                stream: profilePageBloc.isUpdateModeOn,
                builder: (context, snapshot) {
                  return IconButton(
                      color: Theme.of(context).primaryColor,
                      icon:
                          !snapshot.data ? Icon(Icons.edit) : Icon(Icons.save),
                      onPressed: () => {
                            // check if we are saving
                            if (snapshot.data)
                              {
                                if (_formKey.currentState.validate())
                                  {
                                    profilePageBloc
                                        .updateProfile(updatedProfile),
                                  }
                              }
                            else
                              {profilePageBloc.toggleUpdateMode()}
                          });
                });
          },
        ),
      );
    }

    // create name view
    Widget _createNameView(Name name) {
      return StreamBuilder(
          initialData: false,
          stream: profilePageBloc.isUpdateModeOn,
          builder: (context, snapshot) {
            if (!snapshot.data) {
              return Text(
                name.unifiedName,
                style: TextStyle(fontSize: 20),
              );
            }
            return Column(
              children: [
                buildFormField(
                    labelText: 'First Name',
                    initialValue: name.firstName,
                    validator: (value) => validateRequired(value),
                    onChanged: (value) => {
                          if (updatedProfile.name == null)
                            {
                              updatedProfile.name = name,
                              updatedProfile.name.firstName = value.trim()
                            }
                          else
                            {updatedProfile.name.firstName = value.trim()}
                        }),
                buildFormField(
                    labelText: 'Middle Name',
                    initialValue: name.middleName,
                    onChanged: (value) => {
                          if (updatedProfile.name == null)
                            {
                              updatedProfile.name = name,
                              updatedProfile.name.middleName = value.trim()
                            }
                          else
                            {updatedProfile.name.middleName = value.trim()}
                        }),
                buildFormField(
                    labelText: 'Last Name',
                    initialValue: name.lastName,
                    validator: (value) => validateRequired(value),
                    onChanged: (value) => {
                          if (updatedProfile.name == null)
                            {
                              updatedProfile.name = name,
                              updatedProfile.name.lastName = value.trim()
                            }
                          else
                            {updatedProfile.name.lastName = value.trim()}
                        }),
              ],
            );
          });
    }

    // create job title view
    Widget _createJobTitleView(String jobTitle) {
      return StreamBuilder(
          initialData: false,
          stream: profilePageBloc.isUpdateModeOn,
          builder: (context, snapshot) {
            if (!snapshot.data) {
              return Text(
                jobTitle != null ? jobTitle : "(No Job Title)",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              );
            }
            return buildFormField(
                labelText: 'Job Title',
                initialValue: jobTitle,
                validator: (value) => validateJobTitle(value),
                onChanged: (value) => {
                      if (updatedProfile.freelancerProfile == null)
                        {
                          updatedProfile.freelancerProfile =
                              new FreelancerProfile(jobTitle: value.trim())
                        }
                      else
                        {
                          updatedProfile.freelancerProfile.jobTitle =
                              value.trim()
                        }
                    });
          });
    }

    // create header stats item
    Widget _buildHeaderStatsItem(String title, String value) {
      return Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    Widget _buildFreelancerProfileStatCard(
        FreelancerProfile freelancerProfile) {
      return Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Text(
                'Freelancer Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderStatsItem(
                      'Rating', freelancerProfile.rating.toString()),
                  _buildHeaderStatsItem(
                      'Projects', freelancerProfile.projects.toString()),
                  // _buildHeaderStatsItem(
                  //     'Assets', freelancerProfile.assets.toString()),
                  _buildHeaderStatsItem(
                      'Earning', 'PKR:${freelancerProfile.earning.toString()}'),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildEmployerProfileStatCard(EmployerProfile employerProfile) {
      return Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: [
            Text(
              'Employer Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderStatsItem(
                    'Rating', employerProfile.rating.toString()),
                _buildHeaderStatsItem('Projects Completed',
                    employerProfile.projectsCompleted.toString()),
                // _buildHeaderStatsItem(
                //     'Assets Bought', employerProfile.assetsBought.toString()),
                _buildHeaderStatsItem(
                    'Spent', 'PKR:${employerProfile.spent.toString()}'),
              ],
            ),
          ]),
        ),
      );
    }

    Widget _buildUserStats(User user) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            child: PageView(
              onPageChanged: (int index) =>
                  profilePageBloc.changeActiveStatCard(index),
              children: [
                _buildFreelancerProfileStatCard(user.freelancerProfile),
                _buildEmployerProfileStatCard(user.employerProfile),
              ],
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: profilePageBloc.activeStatCardIndex,
            initialData: 0,
            builder: (context, snapshot) {
              return DotsIndicator(
                position: double.parse(snapshot.data.toString()),
                dotsCount: 2,
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).primaryColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              );
            },
          ),
        ],
      );
    }

    // build header
    Widget _buildProfileHeader(User user) {
      return Stack(
        children: [
          // update button
          ...(widget.user == null ||
                  profilePageBloc.isCurrentUser(widget.user.sId)
              ? [_createUpdateProfileButton()]
              : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            GlobalNavigation.key.currentState.push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OneToOneChat(user: widget.user)));
                          })
                    ],
                  )
                ]),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileViewImagePicker(
                  imageUrl: user.imageUrl,
                  isViewOnly: widget.user != null &&
                      !profilePageBloc.isCurrentUser(widget.user.sId),
                  onImageSelect: (File image) {
                    updatedProfile.profileImage = image;
                    profilePageBloc.updateProfilePicture(updatedProfile);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _createNameView(user.name),
                SizedBox(
                  height: 10,
                ),
                _createJobTitleView(user.freelancerProfile.jobTitle),
                SizedBox(
                  height: 20,
                ),
                _buildUserStats(user),
                SizedBox(
                  height: 20,
                ),
                // if current user show withdraw earning button
                ...(widget.user == null ||
                        profilePageBloc.isCurrentUser(widget.user.sId)
                    ? [
                        FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (user.freelancerProfile.earning -
                                    user.freelancerProfile.withdrawn >
                                100) {
                              _buildPaymentModal();
                            } else {
                              profilePageBloc.alert(
                                  'Not enough earnings to withdraw. Withdraw is possible for value greater than 100');
                            }
                          },
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Text(
                            'Withdraw Remaining Earnings \n Rs: ${user.freelancerProfile.earning - user.freelancerProfile.withdrawn}',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ]
                    : []),
              ],
            ),
          )
        ],
      );
    }

    // build body bio
    Widget _buildBioBodySection(String bio) {
      return StreamBuilder(
          initialData: false,
          stream: profilePageBloc.isUpdateModeOn,
          builder: (context, snapshot) {
            if (!snapshot.data) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bio',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      bio != null && bio != '' ? bio : '(No Bio Entered)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }
            return buildFormField(
                labelText: 'Bio',
                initialValue: bio,
                maxLines: 8,
                validator: (value) => validateBio(value),
                onChanged: (value) => {
                      if (updatedProfile.freelancerProfile == null)
                        {
                          updatedProfile.freelancerProfile =
                              new FreelancerProfile(bio: value.trim())
                        }
                      else
                        {updatedProfile.freelancerProfile.bio = value.trim()}
                    });
          });
    }

    // build skill section
    Widget _buildPortfolioSection(User user) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Portfolio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                initialData: false,
                stream: profilePageBloc.isUpdateModeOn,
                builder: (context, snapshot) {
                  return GridViewImagePicker(
                    imageUrls: user.portfolioUrls,
                    isViewModeOnly: !(snapshot.hasData && snapshot.data),
                    onImageSelect: (List<File> images) {
                      updatedProfile.portfolioImages = images;
                    },
                  );
                }),

            // Tags(
            //   itemCount: 5,
            //   itemBuilder: (int index) {
            //     return ItemTags(
            //       index: index,
            //       title: [
            //         'UI/UX',
            //         'Photoshop',
            //         'Illustrator',
            //         'Figma',
            //         'AdobeXD'
            //       ].elementAt(index),
            //       elevation: 5.0,
            //       pressEnabled: false,
            //     );
            //   },
            // )
          ],
        ),
      );
    }

    Widget _buildRatingSection(User user) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile Ratings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            ...(user.ratings.length > 0
                ? List.generate(
                    user.ratings.length,
                    (index) =>
                        buildRatingCard(user.ratings.elementAt(index), ''))
                : [
                    Text(
                      'You haven\'t been rated yet',
                      textAlign: TextAlign.center,
                    ),
                  ]),
          ],
        ),
      );
    }

    // build profile body
    Widget _buildProfileBody(User user) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBioBodySection(
              user.freelancerProfile.bio,
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            _buildPortfolioSection(user),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            _buildRatingSection(user),
          ],
        ),
      );
    }

    return SafeArea(
      child: StreamBuilder(
        stream: profilePageBloc.userProfile,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: LoadSpinner());
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stack(
                  //   children: [
                  //     CurveWidget(
                  //         250, Theme.of(context).primaryColor.withOpacity(0.7)),
                  //     _buildProfileHeader(
                  //       snapshot.data,
                  //     ),
                  //   ],
                  // ),
                  _buildProfileHeader(
                    snapshot.data,
                  ),
                  _buildProfileBody(
                    snapshot.data,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildPaymentModal() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    if (_creditCardFormKey.currentState.validate()) {
                      if (amount <= 100) {
                        profilePageBloc.alert(
                            'Not enough earnings to withdraw. Withdraw is possible for value greater than 100');
                        return;
                      }
                      GlobalNavigation.key.currentState.pop();
                      profilePageBloc.withdraw(accountNumber, amount);
                      amount = 0;
                      accountNumber = '';
                    }
                  },
                  child: Text('Submit')),
            ],
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _creditCardFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Withdraw info'),
                      SizedBox(
                        height: 10,
                      ),
                      buildFormField(
                          labelText: 'Account Number',
                          controller: accNumberMask,
                          validator: (value) => accNumberValidate(value),
                          onChanged: (value) => accountNumber = value.trim()),
                      buildNumericOnlyFormField(
                          labelText: 'Amount',
                          validator: (value) => validateRequired(value),
                          onChanged: (String value) =>
                              {amount = double.parse(value.trim())}),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
