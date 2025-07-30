import 'package:gismo/infra/ui/loginPage.dart';
import 'package:gismo/infra/ui/welcome.dart';
import 'package:gismo/model/User.dart';
import 'package:gismo/services/AuthService.dart';
import 'package:gismo/services/UserService.dart';

class LoginPresenter {
  UserService _service = UserService(AuthService().token);
  LoginContract _view;
  LoginPresenter(this._view);

  loginWeb(String email, String password) async {
    try {
      User testUser  = User(email, password);
      await _service.auth(testUser);
      _view.goNextPage(WelcomePage(null));
    }
    catch(e) {
      this._view.showMessage(e.toString());
    }
  }

}