import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_page_bloc.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/rating.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/rxdart.dart';

class JobDetailsBloc {
  GlobalKey<ScaffoldState> _key;
  Job _job;
  User _freelancer;
  BehaviorSubject<Job> _currentJobController;
  BehaviorSubject<bool> _isBidCreatingController;
  // BehaviorSubject<Bid> _newBidController;
  // BehaviorSubject<Job> _accpetBidActionController;
  BehaviorSubject<bool> _isTakingActionOnBid;

  Stream get currentJob => _currentJobController.stream;
  Stream get isCreatingBid => _isBidCreatingController.stream;
  Stream get isTakingAction => _isTakingActionOnBid.stream;
  // Stream get bid => _newBidController.stream;
  // Stream get acceptBidAction => _accpetBidActionController.stream;

  init(GlobalKey<ScaffoldState> _key, Job job) {
    this._key = _key;
    this._job = job;
    _currentJobController = new BehaviorSubject<Job>();

    // add current job
    _currentJobController.sink.add(_job);
    _isBidCreatingController = BehaviorSubject<bool>();
    _isTakingActionOnBid = BehaviorSubject<bool>();
  }

  bool isMyBidPlaced(Job job) {
    return job.isMyBidPlaced(mainBloc.userProfileObject.sId);
  }

  Bid getMyBidPlaced(Job job) {
    return job.getMyBid(mainBloc.userProfileObject.sId);
  }

  dispose() {
    _currentJobController.close();
    _isBidCreatingController.close();
    _isTakingActionOnBid.close();
    // _newBidController.close();
    // _accpetBidActionController.close();
  }

  /// show alert message
  alert(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  isJobOfCurrentUser(Job job) {
    return job.user.sId == mainBloc.userProfileObject.sId;
  }

  hasUserProvidedRating() {
    bool isRatingGiven = false;
    if (isJobOfCurrentUser(_job)) {
      isRatingGiven = _job.freelancerRating != null;
    } else {
      isRatingGiven = _job.employerRating != null;
    }
    print('what');
    print(isRatingGiven);
    return isRatingGiven;
  }

  User getOppositUser() {
    if (isJobOfCurrentUser(_job)) {
      print('Accepted');
      Bid bid = _job.getAcceptedBid();
      if (bid != null) {
        return bid.user;
      } else if (_freelancer != null) {
        return _freelancer;
      }
      return new User();
    }
    print('employer');
    return _job.user;
  }

  Rating getRatingIProvided() {
    if (isJobOfCurrentUser(_job)) {
      return _job.freelancerRating;
    } else {
      return _job.employerRating;
    }
  }

  createBid(Bid bid) async {
    try {
      _isBidCreatingController.sink.add(true);
      var data = await JobRepo.bid(bid);
      _currentJobController.sink.add(data['job']);
      // refresh previous job page
      jobPageBloc.refetchPreviousJobs();
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    } finally {
      _isBidCreatingController.sink.add(false);
    }
  }

  acceptBid(String bidId) async {
    try {
      _isTakingActionOnBid.sink.add(true);
      Map<String, String> payload = {
        'job': _job.sId,
        'bid': bidId,
        'status': 'ACCEPTED',
      };
      var data = await JobRepo.bidAction(payload);
      _currentJobController.sink.add(data['job']);
      _freelancer = data['job'];
      // refresh previous job page
      jobPageBloc.refetchPreviousJobs();
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
    } finally {
      _isTakingActionOnBid.sink.add(false);
    }
  }

  completeJob(String ccNumber, String ccHolder, String ccCvv) async {
    try {
      Map<String, String> payload = {
        'job': _job.sId,
        'status': 'COMPLETED',
        'ccNumber': ccNumber,
        'ccHolder': ccHolder,
        'ccCvv': ccCvv,
      };
      var data = await JobRepo.jobAction(payload);
      _currentJobController.sink.add(data['job']);
      // refresh previous job page
      jobPageBloc.refetchPreviousJobs();
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      // _isTakingActionOnBid.sink.add(false);
    }
  }

  provideRating(String text, double rating) async {
    try {
      Map<String, String> payload = {
        'job': _job.sId,
        'user': mainBloc.userProfileObject.sId,
        'text': text == '' ? null : text,
        'rating': rating.toString(),
      };
      var data = await JobRepo.provideRating(payload);
      _currentJobController.sink.add(data['job']);
      // refresh previous job page
      jobPageBloc.refetchPreviousJobs();
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      // _isTakingActionOnBid.sink.add(false);
    }
  }
}

final jobDetailsBloc = JobDetailsBloc();
