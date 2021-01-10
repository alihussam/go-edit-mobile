import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Name {
  String firstName;
  String middleName;
  String lastName;

  Name({this.firstName, this.middleName, this.lastName});

  String get unifiedName {
    String name =
        '${this.firstName ?? ''} ${this.middleName ?? ''} ${this.lastName ?? ''}';
    return name;
  }

  Name.fromJson(Map<String, dynamic> json) {
    print('[NameModel] fromJson =>  $json');
    firstName = json['firstName'] ?? '';
    middleName = json['middleName'] ?? '';
    lastName = json['lastName'] ?? '';
    print('[NameModel] fromJson END');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.firstName != null) data['firstName'] = this.firstName;
    if (this.middleName != null && this.middleName != '') {
      data['middleName'] = this.middleName;
    }
    if (this.lastName != null) data['lastName'] = this.lastName;
    return data;
  }
}
