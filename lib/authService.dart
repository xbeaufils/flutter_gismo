import 'dart:async';

//import 'package:dio/dio.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/bloc/GismoHttp.dart';
import 'package:flutter_gismo/model/User.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  late GismoHttp _gismoHttp; // = new GismoHttp(super.token);

  //final dio = new Dio();
  // Login+
 /* Future<User> isLogged() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cheptel = prefs.getString('cheptel');
    if (cheptel != null) {
      User user = new User(cheptel);
      return user;
    }
    return null;
  }
  */
/*
  Future<bool> saveWebConfig(String cheptel, String email, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("token", token);
    return prefs.setString("cheptel", cheptel);
  }
  Future<bool> saveLocalConfig(String cheptel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("cheptel", cheptel);
  }
*/

  Future<User> login(User user) async {
    try {
      final response = await _gismoHttp.doPostResult(
          Environnement.getUrlTarget() + '/user/login', user.toMap());
        user.setCheptel(response["cheptel"]);
    } catch (e) {
        throw ("Erreur de connection à " + Environnement.getUrlTarget());
    }
    return user;
  }
  // Logout
  Future<void> logout() async {
    // Simulate a future for response after 1 second.
    return await new Future<void>.delayed(
        new Duration(
            seconds: 1
        )
    );
  }
}