import 'dart:convert';

import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/bloc/Message.dart';
import 'package:http/http.dart' as http;

class GismoHttp extends http.BaseClient {
  final http.Client _inner= http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  Future<String> doPost(String url, Object body) async {
    var response = await _inner.post(Uri.parse(Environnement.getUrlTarget() + url), body: body);
    Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
    if (msg.error) {
      throw (msg.error);
    }
    else {
      return msg.message;
    }
    //return msg;
  }

  Future<Map> doGet(String url) async {
     var response = await _inner.get(Uri.parse(Environnement.getUrlTarget() + url) );
     return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  @override
  void close() => _inner.close();
}

}