import 'dart:io';

import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/infra/ui/ConfigPage.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/services/UserService.dart';
import 'package:path_provider/path_provider.dart';

class ConfigPresenter {
  final ConfigContract _view;
  UserService _userUservice = UserService(AuthService().token);
  ConfigPresenter(this._view);

  Future<List<FileSystemEntity>?>  getFiles() async {
    final Directory ? extDir = await getExternalStorageDirectory();
    if (extDir == null)
      return null;
    final Directory backupDir = Directory(extDir.path + '/backup');
    if (! backupDir.existsSync())
      return [];
    //final isPermissionStatusGranted = await _requestPermissions();
    List<FileSystemEntity> files = backupDir.listSync();
    return files;
  }

  void deleteBackup(String nameFile) {
    this._userUservice.deleleteBackup(nameFile);
  }

  void copyBD() {
    this._userUservice.copyBD();
  }

  void restoreBackup(String filename) async {
    var value = await this._view.confirmRestore();
    if (value == ConfirmAction.ACCEPT)
      this._userUservice.restoreBackup(filename);
  }

  void login(String email, String password) async {
    User testUser  = User(email, password);
    try {
      User testedUser = await this._userUservice.auth(testUser);
      _view.configTeste = TestConfig.DONE;
    } on GismoException  catch(e) {
      this._view.showMessage(e.message);
    }
      catch(e) {
      this._view.showMessage(e.toString());
    }

  }

  void saveConfig(bool isSubscribe, String email, String password, bool canPop) async {
    String message = await this._userUservice.saveConfig(isSubscribe, email, password);
    if (canPop)
      this._view.backWithMessage(message);
    else
      this._view.goNextPage(WelcomePage());
  }

}