import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/menu/MenuPage.dart';
import 'package:flutter_gismo/model/NoteModel.dart';
import 'package:sentry/sentry.dart';

class NoteListPage extends StatefulWidget {
  GismoBloc _bloc;


  NoteListPage(this._bloc, {Key ? key}) : super(key: key);

  @override
  _NoteListPageState createState() => new _NoteListPageState(_bloc);
}

class _NoteListPageState extends State<NoteListPage> {
  final GismoBloc _bloc;

  _NoteListPageState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (_bloc.user != null) ?
          new Text('Gismo ' + _bloc.user!.cheptel!):
         new Text('Erreur de connexion')),
    body:
      SingleChildScrollView(
        child:
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _listNoteWidget(),
            ]

          ),
      ),
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
         return NotesList(notes: noteSnap.data ?? []);
      },
      future: _getNotes(),
    );
  }

  Future<List<NoteTextuelModel>> _getNotes()  {
    return this._bloc.getNotes();
  }

  void _createNote(){

    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(this._bloc, GismoPage.note),
      ),
    );
    navigationResult.then( (message) {if (message != null) debug.log(message);} );
  }
}

class NotesList extends StatefulWidget {
  final List<NoteTextuelModel> notes;
  const NotesList({Key? key, required this.notes}) : super(key: key);
  @override
  State<NotesList> createState() => _NotesListState(notes: notes);
}

class _NotesListState extends State<NotesList> {
  final List<NoteTextuelModel> _notes;
  _NotesListState({required List<NoteTextuelModel> notes}) : _notes = notes;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _notes[index].isExpanded = !isExpanded;
        });
      },
      children: _notes.map<ExpansionPanel>((NoteTextuelModel note) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("${note.numBoucle!} ${note.numMarquage!}"),
              subtitle: Text("${note.debut}"),
            );
          },
          body: ListTile(
            title: Text(note.note!),
          ),
          isExpanded: note.isExpanded,
        );
      }).toList(),
    );
  }
}