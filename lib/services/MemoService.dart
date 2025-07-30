import 'package:gismo/model/MemoModel.dart';
import 'package:gismo/repository/MemoRepository.dart';
import 'package:gismo/services/AuthService.dart';

class MemoService {
  late Memorepository _repository;

  MemoService() {
    if (AuthService().subscribe ) {
      _repository = WebMemoRepository(AuthService().token);
    }
    else {
      _repository = LocalMemoRepository();
    }
  }

  Future<String> save(MemoModel memo) async {
    String message = await _repository.save(memo);
    return message;
  }

  Future<String> delete(MemoModel memo) async {
    String message = await _repository.delete(memo);
    return message;
  }

  Future<List<MemoModel>> getCheptelMemos() {
    return _repository.getCheptelMemos(AuthService().cheptel!);
  }
}