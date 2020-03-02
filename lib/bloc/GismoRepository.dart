
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/bloc/LocalDataProvider.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';

enum RepositoryType {web, local}
class GismoRepository {
  DataProvider _dataProvider;

  DataProvider get dataProvider => _dataProvider;

  GismoRepository(RepositoryType type) {
    switch (type) {
      case RepositoryType.web :
        _dataProvider = new WebDataProvider();
        break;
      case RepositoryType.local:
        _dataProvider =  new LocalDataProvider();
        //( _dataProvider as LocalDataProvider).init();
    }
  }

}