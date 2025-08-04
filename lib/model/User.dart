class User {
  String ? _email;
  String ? _password;
  String ? _cheptel;
  String ? _token;
  bool ? _subscribe;

  bool ? get subscribe => _subscribe;

  set subscribe(bool ? value) {
    _subscribe = value;
  }

  String ? get email =>_email;
  String ? get password =>_password;
  String ? get cheptel =>_cheptel;
  String ? get token =>_token;

  set cheptel(String ? cheptel) {
    this._cheptel = cheptel;
  }

  set token(String ? value) {
    _token = value;
  }

  setEmail(String ? value) {
    _email = value;
  }

  User(this._email, this._password);
  //User(this._cheptel);

  toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_email != null)
      data['email'] = _email;
    if (_password != null)
      data['password'] = _password;
    if (_cheptel != null)
      data['cheptel'] = _cheptel;
    if ( _token != null)
      data['token'] = _token;
    return data;
  }
}