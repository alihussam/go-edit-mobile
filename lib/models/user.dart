import 'package:goedit/models/employerProfile.dart';
import 'package:goedit/models/freelancerProfile.dart';
import 'package:goedit/models/name.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  @JsonKey(ignore: true)
  String sId;
  Name name;
  String email;
  String password;
  @JsonKey(ignore: true)
  bool isEmailVerified;
  String role;
  String imageUrl;
  @JsonKey(ignore: true)
  bool isDisabled;
  FreelancerProfile freelancerProfile;
  EmployerProfile employerProfile;
  @JsonKey(ignore: true)
  String createdAt;
  @JsonKey(ignore: true)
  String updatedAt;

  User(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.isEmailVerified,
      this.role,
      this.imageUrl,
      this.isDisabled,
      this.freelancerProfile,
      this.employerProfile,
      this.createdAt,
      this.updatedAt});

  String get unifiedName {
    String name = '';
    if (this.name.firstName != null) name += this.name.firstName + ' ';
    if (this.name.middleName != null) name += this.name.middleName + ' ';
    if (this.name.lastName != null) name += this.name.lastName + ' ';
    return name;
  }

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    email = json['email'];
    password = json['password'];
    isEmailVerified = json['isEmailVerified'];
    role = json['role'];
    imageUrl = json['imageUrl'];
    isDisabled = json['isDisabled'];
    freelancerProfile = json['freenlancerProfile'] != null
        ? new FreelancerProfile.fromJson(json['freenlancerProfile'])
        : null;
    employerProfile = json['employerProfile'] != null
        ? new EmployerProfile.fromJson(json['employerProfile'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sId != null) data['_id'] = this.sId;
    if (this.name != null) data['name'] = this.name.toJson();
    if (this.email != null) data['email'] = this.email;
    if (this.password != null) data['password'] = this.password;
    if (this.isEmailVerified != null)
      data['isEmailVerified'] = this.isEmailVerified;
    if (this.role != null) data['role'] = this.role;
    if (this.imageUrl != null) data['imageUrl'] = this.imageUrl;
    if (this.isDisabled != null) data['isDisabled'] = this.isDisabled;
    if (this.freelancerProfile != null)
      data['freenlancerProfile'] = this.freelancerProfile.toJson();
    if (this.employerProfile != null)
      data['employerProfile'] = this.employerProfile.toJson();
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.updatedAt != null) data['updatedAt'] = this.updatedAt;
    return data;
  }
}
