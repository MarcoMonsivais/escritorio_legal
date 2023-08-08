import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:toktok_app/globals.dart';

class Code {
  String cellphone;
  String code;
}

class Token {
  String tokenAccessToken;
  String tokenRefreshToken;
  String error;
}

class CodeService {
  static final _headers = {'Content-Type': 'application/json'};

  Future<Token> createCodeValidation(Code code) async {
    String json = _toJson(code);
    final response = await http.post(
        Uri.parse('${Globals.BASE_API_URL}/oauth/token'),
        headers: _headers,
        body: json
    );
    var c = _fromJson(response.body);
    return c;
  }

  Token _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var token = new Token();
    if(map.containsKey('error')){
      token.error = map['error'];
      return token;
    }
    token.tokenAccessToken = map['access_token'];
    token.tokenRefreshToken = map['refresh_token'];
    token.error = '';
    return token;
  }

  String _toJson(Code code) {
    var mapData = new Map();
    mapData['client_id'] = Globals.CLIENT;
    mapData['client_secret'] = Globals.SECRET;
    mapData['grant_type'] = 'cellphone';
    mapData['cellphone'] = code.cellphone;
    mapData['code'] = code.code;
    mapData['scope'] = 'super-admin';
    String json = jsonEncode(mapData);
    return json;
  }
}