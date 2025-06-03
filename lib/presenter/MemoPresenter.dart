import 'package:flutter_gismo/memo/MemoListPage.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/services/MemoService.dart';
import 'package:intl/intl.dart';

class MemoPresenter {
  final MemoContract _view;
  final MemoService _service = MemoService();

  MemoPresenter(this._view);

  void save(String debut, String fin, String note, MemoClasse classe) async {
    this._view.showSaving();
    if (this._view.currentNote == null)
      this._view.currentNote = new MemoModel();
    this._view.currentNote!.debut = DateFormat.yMd().parse(debut);
    if (fin.isNotEmpty)
      this._view.currentNote!.fin = DateFormat.yMd().parse(fin);
    else
      this._view.currentNote!.fin = null;
    this._view.currentNote!.note = note;
    if (this._view.currentNote!.bete_id == null)
      this._view.currentNote!.bete_id = this._view.bete.idBd;
    this._view.currentNote!.classe = classe;
    //if (this.widget._bete != null)
    String message= await this._service.save(this._view.currentNote!);
    this._view.backWithMessage(message);
  }

}

class MemoListPresenter {
  final MemoService _service = MemoService();
  final MemoListContract _view;

  MemoListPresenter(this._view);

  Future<List<MemoModel>> getNotes()  {
    return this._service.getCheptelMemos();
  }

  void delete(MemoModel note) async {
    String message = await this._service.delete(note);
    this._view.showMessage(message);
  }

}