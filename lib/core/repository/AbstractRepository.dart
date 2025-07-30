
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gismo/env/Environnement.dart';
import 'package:http/http.dart' as http;
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sentry/sentry.dart';
import 'package:gismo/bloc/Message.dart';

enum RepositoryType {web, local}

abstract class AbstractRepository {

}

class WebRepository {
  final DateFormat _df = new DateFormat('dd/MM/yyyy');

  DateFormat get df => _df;

  final String? _token;
  WebRepository(this._token) ;

  Future<Map<String, String>> _getHeaders() async{
    Map<String, String> _headers = new Map();
    _headers[HttpHeaders.contentTypeHeader] = ContentType.json.value;
    if (this._token != null)
      _headers['token'] = this._token!;
    _headers[HttpHeaders.acceptLanguageHeader] =  Intl.shortLocale(await findSystemLocale());
    return _headers;
  }

  Future<String> doPostParcelle(String url, Object body) async {
    try {
      var response = await http.post(Uri.parse(Environnement.getUrlTarget() + url), headers: await _getHeaders() ,body: body).timeout(Duration(seconds: 10));
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
          headers: await _getHeaders() ,
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
          headers: await _getHeaders(),
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
          headers: await _getHeaders(),
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
    //return msg;
  }

  Future<Map> doPostResult(String url, Object body) async {
    String errorMessage ="";
    try {
      var response = await http.post(
          Uri.parse(Environnement.getUrlTarget() + url),
          headers: await _getHeaders(),
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
      var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: await _getHeaders() ).timeout(Duration(seconds: 10));
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
      var response = await http.get(Uri.parse(Environnement.getUrlTarget() + url), headers: await _getHeaders() );
      return jsonDecode(utf8.decode(response.bodyBytes)) as List;
    } on TimeoutException catch (e) {
      throw (e);
    } on Error catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      throw(e);
    }
  }

}
