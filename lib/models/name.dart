import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Name {
  String firstName;
  String middleName;
  String lastName;

  Name({this.firstName, this.middleName, this.lastName});

  Name.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    if (this.middleName != null) {
      data['middleName'] = this.middleName;
    }
    data['lastName'] = this.lastName;
    return data;
  }
}
