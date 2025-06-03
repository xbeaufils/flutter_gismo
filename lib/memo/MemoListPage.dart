import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/SimpleGismoPage.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/menu/MenuPage.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/presenter/MemoPresenter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemoListPage extends StatefulWidget {
  MemoListPage( {Key ? key}) : super(key: key);

  @override
  _MemoListPageState createState() => new _MemoListPageState();
}

abstract class MemoListContract extends GismoContract {

}

class _MemoListPageState extends GismoStatePage<MemoListPage> implements MemoListContract {

  late MemoListPresenter _presenter;

  _MemoListPageState() {
    this._presenter = MemoListPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (new Text(S.of(context).memo))),
    body: _listNoteWidget(),
    floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
    floatingActionButton:
      FloatingActionButton(
          onPressed: _createNote,
          backgroundColor: Colors.lightGreen[700],
          child: Icon(Icons.add),),
    drawer: GismoDrawer()
    );
  }

   Widget _listNoteWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot noteSnap) {
        if (noteSnap.connectionState == ConnectionState.none && noteSnap.hasData == null) {
          return Container();
        }
        if (noteSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
         return _notesList  (noteSnap.data ?? []);
      },
      future: this._presenter.getNotes(),
    );
  }


  void _createNote(){
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(GismoPage.note),
      ),
    );
    navigationResult.then( (message) {
        setState(() {
          if (message != null) debug.log(message);
        });
    } );
  }

  Widget _status(MemoModel note) {
    switch (note.classe) {
      case MemoClasse.ALERT :
        return const Icon(Icons.warning_amber_outlined);
      case MemoClasse.INFO :
        return const Icon(Icons.info_outlined);
      case MemoClasse.WARNING :
        return const Icon(Icons.error_outline);
    }
    return Container();
  }

  Widget _notesList ( List<MemoModel> _notes) {
    return ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          MemoModel _note = _notes[index];
          return ListTile(
            leading: _status(_note),
            title: Row(children: [ Text(_note.numBoucle!), Spacer(), Text( DateFormat.yMd().format(_note.debut!)),]),
            subtitle: Text(_note.note!),
            isThreeLine: true,
            trailing: SizedBox(
              width: 100,
              child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => { _edit(_note) }),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => { _showDialog(context, _note) }),
                  ]),
            ),
          );
        }
    );
  }

  void _edit(MemoModel note) {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoPage.edit(note)
      ),
    );

    navigationResult.then((message) {
      setState(() {
        if (message != null)
          _showMessage(message);
      });
    });
  }
/*
  void _delete(MemoModel note) async {
    String message = await this._bloc.deleteNote(note);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() {

    });
  }
*/
  Future _showDialog(BuildContext context, MemoModel note) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _continueButton(note),
          ],
        );
      },
    );
  }
  // set up the buttons
  Widget _cancelButton() {
     return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(MemoModel event) {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: () {
          this._presenter.delete(event);
        Navigator.of(context).pop();
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
