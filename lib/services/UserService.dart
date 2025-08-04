import 'dart:developer' as debug;
import 'dart:io';

import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite/sqflite.dart';

class UserService extends WebRepository{
  UserService(super.token);

  Future<User> auth(User user) async {
    try {
      //final response = await _dio.post( Environnement.getUrlTarget() + '/user/auth', data: user.toMap());
      final response = await super.doPostResult( '/user/login',  user.toMap());
      debug.log("Send authentication", name: "UserService::auth");
      user.cheptel=(response["cheptel"]);
      user.token = response["token"];
    }  catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    debug.log("User is $user.cheptel", name: "WebDataProvider::auth");
    return user;
  }

  Future<String> saveConfig(bool isSubscribe, String email, String password) async {
    try {
      final storage = new FlutterSecureStorage();
      if (isSubscribe) {
        User user = User(email, password);
        user = await this.auth(user);
        AuthService().token = user.token!;
        AuthService().cheptel =  user.cheptel!;
        AuthService().subscribe = true;
        AuthService().email = email;
        storage.write(key: "email", value: email);
        storage.write(key: "password", value: password);
      }
      else {
        AuthService().token = "Nothing";
        AuthService().cheptel  = "00000000";
        AuthService().subscribe = false;
        storage.delete(key: "email");
        storage.delete(key: "password");
      }
      return "Configuration enregistrée";
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      throw e;
    }
  }

  Future<String ?> copyBD() async {
    //return (_repository.dataProvider as LocalDataProvider).copyBd();
    LocalRepository repository = LocalRepository();
    final df = new DateFormat('yyyy-MM-dd');
    DateTime date = DateTime.now();
    String databasePath = await getDatabasesPath();
    String databaseFile = join(databasePath , 'gismo_database.db');
    final Directory ? extDir = await getExternalStorageDirectory();
    Directory backupdir =  Directory(extDir!.path + '/backup');
    if ( ! backupdir.existsSync() )
      backupdir.createSync();
    String backupFile = join(backupdir.path, 'gismo_database_'+ df.format(date) + '.json');
    //File(databaseFile).copy(backupFile);
    File file = new File(backupFile);
    file.createSync();
    String base = await repository.backupBd();
    file.writeAsStringSync(base);
  }

  void deleleteBackup(String filename) async {
    final Directory ? extDir = await getExternalStorageDirectory();
    Directory backupdir =  Directory(extDir!.path + '/backup');
    if ( backupdir.existsSync() ) {
      String backupFile = join(backupdir.path, filename);
      File(backupFile).deleteSync();
    }
  }

  void restoreBackup(String filename) async {
    LocalRepository repository = LocalRepository();
    final Directory ? extDir = await getExternalStorageDirectory();
    Directory backupdir =  Directory(extDir!.path + '/backup');
    if ( backupdir.existsSync() ) {
      String backupFile = join(backupdir.path, filename);
      await repository.restoreBd(backupFile);
      // File(backupFile).copySync(databaseFile);
    }
  }

}