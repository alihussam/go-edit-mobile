import 'package:goedit/models/user.dart';

class Rating {
  String sId;
  User user;
  String text;
  double rating;

  Rating({this.sId, this.user, this.text, this.rating});

  Rating.fromJson(Map<String, dynamic> json) {
    print('[RatingModel] fromJson');
    sId = json['_id'];
    if (!(json['user'] is String)) {
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
    }
    text = json['text'] != null ? json['text'] : 'No review comments';
    rating =
        json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['text'] = this.text;
    data['rating'] = this.rating;
    return data;
  }
}
