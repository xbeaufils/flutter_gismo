import 'package:flutter_gismo/bloc/certificatLetsEncrypt.dart';

class Environnement {
  static Environnement ? _instance;
  Environnement(this._urlTarget, this._urlWebTarget);
  static CertificatLetsEncrypt certif = new CertificatLetsEncrypt();
  String _urlWebTarget;
  String _urlTarget;

  static void init(String urlWeb, String url) {
    if(_instance == null) {
      _instance = Environnement(url, urlWeb);
      Environnement.certif.getCertificat();
    }
  }

  static String getUrlTarget() {
    return _instance!._urlTarget;
  }

  static String getUrlWebTarget() {
    return _instance!._urlWebTarget;
  }

  static Environnement getInstance() {
    return _instance!;
  }
}