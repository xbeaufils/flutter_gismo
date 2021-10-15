import 'dart:convert';

import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bloc/Message.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

class GismoHttp  {
  //final http.Client _inner= http.Client();
  final GismoBloc _bloc;
  GismoHttp(this._bloc) ;

  Map<String, String> _getHeaders() {
    Map<String, String> _headers = new Map();
    _headers['Content-Type'] = "application/json";
    if (this._bloc.user!.token != null)
      _headers['token'] = this._bloc.user!.token!;
    return _headers;
  }

  Future<String> doPostParcelle(String url, Object body) async {
    var response = await http.post(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() ,body: body);
    return response.body;
  }

  Future<String> doPost(String url, Object body) async {
    var response = await http.post(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() ,body: body);
    Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
    if (msg.error) {
      throw (msg.error);
    }
    else {
      return msg.message;
    }
    //return msg;
  }

  Future<Map> doPostResult(String url, Object body) async {
    String errorMessage ="";
    try {
      var response = await http.post(
          Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders(),
          body: jsonEncode(body));
      Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
      if (msg.error) {
        errorMessage = msg.message;
      }
      else {
        return msg.result;
      }
    }catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
    throw Exception(errorMessage);
  }

  Future<Map<String, dynamic> > doGet(String url) async {
     var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() );
     return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List > doGetList(String url) async {
    var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() );
    return jsonDecode(utf8.decode(response.bodyBytes)) as List;
  }

}

