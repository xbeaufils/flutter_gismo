import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/TraitementModel.dart';
import 'package:gismo/repository/TraitementRepository.dart';
import 'package:gismo/services/AuthService.dart';

class TraitementService {
  late Traitementrepository _repository;

  TraitementService() {
    if (AuthService().subscribe) {
      _repository = WebTraitementRepository(AuthService().token);
    }
    else
      _repository = LocalTraitementRepository();
  }
  Future<String> deleteTraitement(int idBd) {
    return this._repository.deleteTraitement(idBd);
  }

  Future<String> saveTraitement(TraitementModel traitement) {
    return this._repository.saveTraitement(traitement);
  }

  Future<String> saveTraitementCollectif(TraitementModel traitement, List<Bete> betes) {
    return this._repository.saveTraitementCollectif(traitement, betes);
  }

  Future<List<TraitementModel>> getTraitements(Bete bete) {
    return this._repository.getTraitements(bete);
  }

  Future<TraitementModel?> searchTraitement(int idBd) {
    return this._repository.searchTraitement(idBd);
  }

}