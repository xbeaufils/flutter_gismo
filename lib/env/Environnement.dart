import 'package:flutter_gismo/bloc/certificatLetsEncrypt.dart';
import 'package:flutter_gismo/flavor/Flavor.dart';


class Environnement {
  static Environnement ? _instance;
  Environnement(this._urlTarget, this._urlWebTarget, this._flavor);
  static CertificatLetsEncrypt certif = new CertificatLetsEncrypt();
  String _urlWebTarget;
  String _urlTarget;
  Flavor _flavor;

  static void init(String urlWeb, String url, Flavor flavor) {
    if(_instance == null) {
      _instance = Environnement(url, urlWeb, flavor);
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

  static void setFlavor(Flavor flavor) {
    _instance!._flavor = flavor;
  }
  static Flavor getFlavor() {
    return _instance!._flavor;
  }
}