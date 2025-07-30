import 'package:gismo/model/ParcelleModel.dart';
import 'package:gismo/repository/ParcelleRepository.dart';
import 'package:gismo/services/AuthService.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ParcelleService {
  late ParcelleRepository _repository;

  ParcelleService() {
    _repository = WebParcelleRepository(AuthService().token);
  }

  Future<String> getCadastre(LatLng /*Position*/ myPosition) async {
       String cadastre = await this._repository.getCadastre(myPosition);
       return cadastre;
  }

  Future<Pature> getPature(String idu) async {
      Pature pature = await this._repository.getPature(idu);
      return pature;
  }

    Future<String> getParcelle(LatLng touchPosition) async {
      String cadastre = await this._repository.getParcelle(touchPosition);
      return cadastre;
  }

  Future<List<Parcelle>> getParcelles()  async{
      List<Parcelle> parcelles = await this._repository.getParcelles();
      return parcelles;
  }

  Future<String> savePature(Pature pature) async {
    return await this._repository.savePature(pature);
  }
}