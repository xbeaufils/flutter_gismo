import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/infra/ui/loginPage.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/services/UserService.dart';

class LoginPresenter {
  UserService _service = UserService(AuthService().token);
  LoginContract _view;
  LoginPresenter(this._view);

  loginWeb(String email, String password) async {
    try {
      User testUser  = User(email, password);
      User completeUser = await _service.auth(testUser);
      AuthService().email = completeUser.email;
      AuthService().cheptel = completeUser.cheptel;
      AuthService().token = completeUser.token;
      AuthService().subscribe = true;
      _view.goNextPage(WelcomePage());
    } on GismoException catch (e) {
      this._view.showMessage(e.message);
    }
    catch(e) {
      this._view.showMessage(e.toString(), true);
    }
  }

}