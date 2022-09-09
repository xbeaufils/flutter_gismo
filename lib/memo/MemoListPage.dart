import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/menu/MenuPage.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:sentry/sentry.dart';

class MemoListPage extends StatefulWidget {
  GismoBloc _bloc;


  MemoListPage(this._bloc, {Key ? key}) : super(key: key);

  @override
  _MemoListPageState createState() => new _MemoListPageState(_bloc);
}

class _MemoListPageState extends State<MemoListPage> {
  final GismoBloc _bloc;

  _MemoListPageState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (new Text('Memos'))),
    body: _listNoteWidget(),
    floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
    floatingActionButton:
      FloatingActionButton(
          onPressed: _createNote,
          backgroundColor: Colors.lightGreen[700],
          child: Icon(Icons.add),),
    drawer: GismoDrawer(this._bloc)
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
         //return NotesExpansionList(notes: noteSnap.data ?? []);
         //return NotesList(notes: noteSnap.data ?? []);
         return _notesList  (noteSnap.data ?? []);
      },
      future: _getNotes(),
    );
  }

  Future<List<MemoModel>> _getNotes()  {
    return this._bloc.getCheptelNotes();
  }

  void _createNote(){
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(this._bloc, GismoPage.note),
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
            title: Row(children: [ Text(_note.numBoucle!), Spacer(), Text("${_note.debut}"),]),
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
                        onPressed: () => { _delete(_note) }),
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
        builder: (context) => MemoPage.edit(_bloc, note)
      ),
    );

    navigationResult.then((message) {
      setState(() {
        if (message != null)
          _showMessage(message);
      });
    });
  }

  void _delete(MemoModel note) async {
    String message = await this._bloc.deleteNote(note);
    this._showMessage(message);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
