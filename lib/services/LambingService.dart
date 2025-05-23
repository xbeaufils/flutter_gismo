import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/repository/LambRepository.dart';
import 'package:provider/provider.dart';

class LambingService {
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);
  late LambRepository _lambRepository;

  LambingService() {
    if (_provider.isSubscribing()) {
      _lambRepository = WebLambRepository(_provider.getToken());
    }
    else {
      _lambRepository = LocalLambRepository();
    }
  }

  Future<String ?>  saveLambing() async {
    _lambing.setDateAgnelage(DateFormat.yMd().parse(_dateAgnelageCtl.text));
    _lambing.observations = _obsCtl.text;
    _lambing.adoption = _adoption.key;
    _lambing.qualite = _agnelage.key;

    String ? message  = await this._lambRepository.saveLambing(this._lambing);
    return message;
  }

}