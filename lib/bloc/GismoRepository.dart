
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bloc/LocalDataProvider.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';

enum RepositoryType {web, local}
class GismoRepository {
  DataProvider _dataProvider;
  GismoBloc _bloc;
  DataProvider get dataProvider => _dataProvider;

  GismoRepository(this._bloc, RepositoryType type) {
    switch (type) {
      case RepositoryType.web :
        _dataProvider = new WebDataProvider(_bloc);
        break;
      case RepositoryType.local:
        _dataProvider =  new LocalDataProvider(_bloc);
        //( _dataProvider as LocalDataProvider).init();
    }
  }

}