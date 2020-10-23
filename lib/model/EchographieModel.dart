class EchographieModel {
  int _idBd;
  String _dateEcho;
  String _dateAgnelage;
  String _dateSaillie;
  int _nombre;
  int _bete_id;

  EchographieModel();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["id"] = _idBd ;
    data["dateEcho"] = _dateEcho;
    data["dateAgnelage"] = _dateAgnelage;
    data["dateSaillie"] = _dateSaillie;
    data["nombre"] = _nombre.toString();
    data["bete_id"] = _bete_id.toString();
    return data;
  }

  EchographieModel.fromResult(result) {
    _idBd = result["id"] ;
    _dateEcho = result["dateEcho"];
    _dateAgnelage = result["dateAgnelage"];
    _dateSaillie = result["dateSaillie"];
    _nombre = result["nombre"];
    _bete_id = result["bete_id"];
  }

  set bete_id(int value) {
    _bete_id = value;
  }

  set dateEcho(String value) {
    _dateEcho = value;
  }

  set idBd(int value) {
    _idBd = value;
  }
  set dateAgnelage(String value) {
    _dateAgnelage = value;
  }

   set nombre(int value) {
    _nombre = value;
  }

  set dateSaillie(String value) {
    _dateSaillie = value;
  }

  int get bete_id => _bete_id;

  int get nombre => _nombre;

  String get dateSaillie => _dateSaillie;

  String get dateAgnelage => _dateAgnelage;

  String get dateEcho => _dateEcho;

  int get idBd => _idBd;

 }