import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_gismo/env/Environnement.dart';
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
    _headers["Accept-Language"] = Platform.localeName;
    if (this._bloc.user!.token != null) {
      _headers['token'] = this._bloc.user!.token!;
    }
    return _headers;
  }

  Future<String> doPostParcelle(String url, Object body) async {
    try {
      var response = await http.post(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() ,body: body).timeout(Duration(seconds: 10));
      return response.body;
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw(e);
    }
  }

  Future<String> doPostWeb(String url, Object body) async {
    try {
      var response = await http.post(Uri.parse(Environnement.getUrlWebTarget() + url),
          headers: _getHeaders() ,
        body: jsonEncode(body)).timeout(Duration(seconds: 10));
      return response.body;
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw (e);
    }
  }

  Future<String> doDeleteMessage(String url, Object body) async {
    //Message msg = Message();
    try {
      var response = await http.delete(
          Uri.parse(Environnement.getUrlTarget() + url),
          headers: _getHeaders(),
          body: jsonEncode(body)).timeout(Duration(seconds: 5) ).timeout(Duration(seconds: 10));
      Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
      if (msg.error) {
        throw (msg.error);
      }
      else {
        return msg.message;
      }
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw (e);
    }
  }

  Future<String> doPostMessage(String url, Object body) async {
    //Message msg = Message();
    try {
      var response = await http.post(
          Uri.parse(Environnement.getUrlTarget() + url),
          headers: _getHeaders(),
          body: jsonEncode(body)).timeout(Duration(seconds: 10));
      Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
      if (msg.error) {
        throw (msg.error);
      }
      else {
        return msg.message;
      }
    } on TimeoutException catch (e) {
        throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw (e);
    }
    //return msg;
  }

  Future<Map> doPostResult(String url, Object body) async {
    String errorMessage ="";
    try {
      var response = await http.post(
          Uri.parse(Environnement.getUrlTarget() + url),
          headers: _getHeaders(),
          body: jsonEncode(body)).timeout(Duration(seconds: 10));
      Message msg = Message(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
      if (msg.error) {
        errorMessage = msg.message;
      }
      else {
        return msg.result;
      }
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw(e);
    }
    throw Exception(errorMessage);
  }

  Future<Map<String, dynamic> > doGet(String url) async {
    try {
     var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() ).timeout(Duration(seconds: 10));
     if (response.bodyBytes.lengthInBytes == 0)
       return jsonDecode("{}");
     return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw(e);
    }
  }

  Future<List > doGetList(String url) async {
    try {
      var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: _getHeaders() );
      return jsonDecode(utf8.decode(response.bodyBytes)) as List;
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw(e);
    }
  }

}

