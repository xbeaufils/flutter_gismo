import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/SearchPage.dart';
import 'package:flutter_gismo/services/BeteService.dart';

class SearchPresenter {

  final SearchContract _view;

  BeteService _service = BeteService();
  SearchPresenter(this._view);

  void getBetes(Sex ? searchSex) async {
    List<Bete> ? lstBetes ;
    if (searchSex == null) {
      lstBetes = await this._service.getBetes();
    }
    else {
      switch (searchSex) {
        case Sex.femelle:
          lstBetes = await this._service.getBrebis();
          break;
        case Sex.male :
          lstBetes = await this._service.getBeliers();
          break;
        default :
          lstBetes = await this._service.getBetes();
      }
    }
    this._view.fillList(lstBetes);
  }

}