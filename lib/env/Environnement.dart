import 'package:gismo/bloc/certificatLetsEncrypt.dart';
import 'package:gismo/flavor/Flavor.dart';

class Environnement {
  static Environnement ? _instance;
  Environnement(this._urlTarget, this._urlWebTarget, this.flavor);
  static CertificatLetsEncrypt certif = new CertificatLetsEncrypt();
  String _urlWebTarget;
  String _urlTarget;
  Flavor flavor;

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

  static Flavor getFlavor() {
    return _instance!.flavor;
  }
}