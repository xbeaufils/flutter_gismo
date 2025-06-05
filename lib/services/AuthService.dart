import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/services/UserService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as debug;

class AuthService {

  static AuthService ? _singleton;
  AuthService._internal();
  factory AuthService() => _singleton ??= AuthService._internal();

  User ? _currentUser;

  String ? _cheptel;
  String ? get cheptel => _cheptel;
  set cheptel(String ? value) {
    _cheptel = value;
  }
  static String ? _token;
  String  get token => _token!;
  set token(String value) {
    _token = value;
  }

  static bool ? _subscribe;
  bool get subscribe => _subscribe!;
  set subscribe(bool value) {
    _subscribe = value;
  }

  String ? _email;

  String ? get email => _email;

  set email(String ? value) {
    _email = value;
  }

  static Future<String> init() async {
    // Read value
    FlutterSecureStorage storage = new FlutterSecureStorage();
    try {
      String? email = await storage.read(key: "email");
      if (email == null) {
        AuthService().cheptel = "00000000";
        AuthService().subscribe = false;
        AuthService().token ="Nothing";
        debug.log("Mode autonome", name: "GismoBloc::init");
        // Ajout des pubs
        //Admob.initialize();
        FacebookAudienceNetwork.init(
          testingId: "a77955ee-3304-4635-be65-81029b0f5201",
          iOSAdvertiserTrackingEnabled: true,
        );
        if (Platform.isIOS) {
          //await Admob.requestTrackingAuthorization();
        }
        return "mode autonome";
      }
      String? password = await storage.read(key: "password");
      UserService service  = UserService("nothing");
      User _user = new User(email, password);
      _user.cheptel ="" ;
      _user.setToken("Nothing");
      _user = await service.auth(_user);
      AuthService().cheptel = _user.cheptel;
      AuthService().token = _user.token!;
      AuthService().subscribe = true;
      AuthService().email = _user.email;
      /*this._currentUser =
      await (_repository?.dataProvider as WebDataProvider).login(
          this._currentUser!);*/
      debug.log(
          'Mode connecté email : $email - cheptel: currentUser.cheptel',
          name: "GismoBloc::init");
      return "mode connecte";
    }
    on PlatformException catch(e) {
      User _user = new User(null, null);
      _user.cheptel = "00000000";
      _user.subscribe = false;
      //_repository = new GismoRepository(this._currentUser!, RepositoryType.local);
      debug.log("Mode autonome", name: "GismoBloc::init");
      return "mode erreur";
    }
  }
}