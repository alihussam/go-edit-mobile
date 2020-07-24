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
  @JsonKey(ignore: true)
  bool isDisabled;
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
      this.isDisabled,
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
    isDisabled = json['isDisabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['email'] = this.email;
    data['password'] = this.password;
    // data['isEmailVerified'] = this.isEmailVerified;
    data['role'] = this.role;
    // data['isDisabled'] = this.isDisabled;
    // data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    return data;
  }
}
