import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/repository/MemoRepository.dart';
import 'package:provider/provider.dart';

class MemoService {
  late Memorepository _repository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  MemoService() {
    if (_provider.isSubscribing()) {
      _repository = WebMemoRepository(_provider.getToken());
    }
    else {
      _repository = LocalMemoRepository();
    }
  }

  Future<String> save(MemoModel memo) async {
    String message = await _repository.save(memo);
    return message;
  }

}