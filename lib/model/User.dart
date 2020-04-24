class User {
  String _email;
  String _password;
  String _cheptel;
  String _token;
  bool _subscribe;

  bool get subscribe => _subscribe;

  set subscribe(bool value) {
    _subscribe = value;
  }

  String get email =>_email;
  String get password =>_password;
  String get cheptel =>_cheptel;
  String get token =>_token;

  void setCheptel(String cheptel) {
    this._cheptel = cheptel;
  }

  setToken(String value) {
    _token = value;
  }

  setEmail(String value) {
    _email = value;
  }

  User(this._email, this._password);
  //User(this._cheptel);

  toMap() {
    return {
      //"User" : {
        "email" : _email,
        "password": _password,
        "cheptel" : _cheptel,
        "token" : _token
      //}
    };
  }
}