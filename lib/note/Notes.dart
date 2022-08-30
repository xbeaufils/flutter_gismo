import 'package:flutter/material.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/NoteModel.dart';
import 'package:sentry/sentry.dart';

class NotePage extends StatefulWidget {
  GismoBloc _bloc;
  String ? _message;

  NotePage(this._bloc, this._message, {Key ? key}) : super(key: key);

  @override
  _NotePageState createState() => new _NotePageState(_bloc);
}

class _NotePageState extends State<NotePage> {
  final GismoBloc _bloc;

  _NotePageState(this._bloc);

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
          onPressed: _createLot,
          backgroundColor: Colors.lightGreen[700],
          child: Icon(Icons.add),),
    drawer: Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
      child: ListView()
    ));
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

  Future<List<Note>> _getNotes()  {
    return this._bloc.getNotes();
  }

  void _createLot(){
    /*
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LotAffectationViewPage(this._bloc, new LotModel()),
      ),
    );
    navigationResult.then( (message) {if (message != null) debug.log(message);} );
  */
  }
}

class NotesList extends StatefulWidget {
  final List<Note> notes;
  const NotesList({Key? key, required this.notes}) : super(key: key);
  @override
  State<NotesList> createState() => _NotesListState(notes: notes);
}

class _NotesListState extends State<NotesList> {
  final List<Note> _notes;
  _NotesListState({required List<Note> notes}) : _notes = notes;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _notes[index].isExpanded = !isExpanded;
        });
      },
      children: _notes.map<ExpansionPanel>((Note note) {
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