import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'dart:developer' as debug;

import 'package:flutter_gismo/repository/MouvementRepository.dart';
import 'package:provider/provider.dart';

class EntreeService {
  late EntreeRepository _repository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  EntreeService() {
    if (_provider.isSubscribing()) {
      _repository = WebEntreeRepository(_provider.getToken());
    }
    else  {
      _repository = LocalEntreeRepository();
    }
  }

  Future<String> save(DateTime date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveEntree");
    this._repository.save(_provider.getCheptel()!, date, motif, betes);
    return "OK";
  }

}