// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? uuid;
  String? email;
  String? name;
  String? surname;
  UserModel({this.email, this.name, this.surname, this.uuid});

  factory UserModel.fromMap(map) {
    return UserModel(
      uuid: map["uuid"],
      email: map["email"],
      name: map["name"],
      surname: map["surname"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'email': email,
      'name': name,
      'surname': surname,
    };
  }
}
