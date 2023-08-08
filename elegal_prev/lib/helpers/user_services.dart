import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'user.dart';
import 'package:toktok_app/globals.dart';

class UserService {
  static final _headers = {'Content-Type': 'application/json'};

  Future<User> createUser(User user) async {
    String json = _toJson(user);
    final response = await http.post(
        Uri.parse('${Globals.BASE_API_URL}/users'),
        headers: _headers,
        body: json
    );
    var c = _fromJson(response.body);
    return c;
  }

  User _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var user = new User();
    if(map.containsKey('error')){
      print(map['error']);
      user.error = map['error'];
      return user;
    }
    user.name = map['data']['name'];
    user.lastName = map['data']['lastName'];
    user.email = map['data']['email'];
    user.cellphone = map['data']['cellphone'].toDouble();
    user.age = map['data']['age'];
    user.gender = map['data']['gender'];
    user.error = '';
    print(user);
    return user;
  }

  String _toJson(User user) {
    var mapData = new Map();
    mapData['name'] = user.name;
    mapData['lastName'] = user.lastName;
    mapData['email'] = user.email;
    mapData['password'] = user.password;
    mapData['password_confirmation'] = user.passwordConfirmation;
    mapData['cellphone'] = user.cellphone;
    mapData['age'] = user.age;
    mapData['gender'] = user.gender;
    String json = jsonEncode(mapData);
    return json;
  }
}