import 'dart:io';
import 'dart:developer' as debug;

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoRepository.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/services/UserService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfigProvider extends ChangeNotifier {

  User ? _currentUser;

  User ? get currentUser => _currentUser;

  //GismoRepository ? _repository;

  // FRom https://flutter.dev/docs/cookbook/maintenance/error-reporting
  bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;
    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Future<String> init(RunningMode mode) async {
    // Read value
    FlutterSecureStorage storage = new FlutterSecureStorage();

    try {
      String? email = await storage.read(key: "email");
      if (email == null) {
        this._currentUser = new User(null, null);
        _currentUser!.setCheptel("00000000");
        _currentUser!.subscribe = false;
        _currentUser!.setToken("Nothing");
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
        if (mode == RunningMode.test) {
          //LocalRepository repository = LocalRepository();
          //repository.resetDatabase();
        }
        return "Mode autonome";
      }
      String? password = await storage.read(key: "password");
      UserService service  = UserService("nothing");
      this._currentUser = new User(email, password);
      this._currentUser?.setCheptel("");
      this._currentUser?.setToken("Nothing");
      this._currentUser = await service.auth(this._currentUser!);
      /*this._currentUser =
      await (_repository?.dataProvider as WebDataProvider).login(
          this._currentUser!);*/
      debug.log(
          'Mode connecté email : $email - cheptel: $this._currentUser.cheptel',
          name: "GismoBloc::init");
      return "Mode connecté";
    }
    on PlatformException catch(e) {
      this._currentUser = new User(null, null);
      _currentUser?.setCheptel("00000000");
      _currentUser?.subscribe = false;
      //_repository = new GismoRepository(this._currentUser!, RepositoryType.local);
      debug.log("Mode autonome", name: "GismoBloc::init");
      return "Mode autonome";
    }
  }

  bool isSubscribing() {
    if (_currentUser == null)
      return false;
    debug.log("Cheptel is " + _currentUser!.cheptel!, name:"GismoBloc::isLogged");
    if (_currentUser!.subscribe == null)
      return false;
    return _currentUser!.subscribe! ;
  }

  String ? getToken() {
    if (this._currentUser != null)
      if (this._currentUser!.token != null)
        return this._currentUser!.token!;
    return null;
  }

  String ? getCheptel() {
    if (this._currentUser != null)
      if (this._currentUser!.token != null)
        return this._currentUser!.cheptel!;
    return null;
  }
}