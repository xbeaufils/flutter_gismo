import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/NoteModel.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final GismoBloc _bloc;
  final Bete _bete;
  NoteTextuelModel ? _currentNote;

  @override
  NotePageState createState() => NotePageState(this._bloc);

  NotePage(this._bloc,this._bete);
}

class NotePageState extends State<NotePage> {
  final GismoBloc _bloc;
  NotePageState(this._bloc);

  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _noteCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("Note"),
        //leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new Card( child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Flexible( child:
                      new TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _dateDebutCtl,
                        decoration: InputDecoration(
                            labelText: "Date début",
                            hintText: 'jj/mm/aaaa'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Pas de date de début";
                          }},
                        onSaved: (value) {
                          setState(() {
                            _dateDebutCtl.text = value!;
                          });
                        },
                        onTap: () async{
                          DateTime ? date = DateTime.now();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              locale: const Locale("fr","FR"),
                              context: context,
                              initialDate:DateTime.now(),
                              firstDate:DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              _dateDebutCtl.text = _df.format(date!);
                            });
                          }
                        }),
              ),
                    new Flexible( child:
                    new TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _dateFinCtl,
                        decoration: InputDecoration(
                            labelText: "Date fin",
                            hintText: 'jj/mm/aaaa'),
                        onSaved: (value) {
                          setState(() {
                            _dateFinCtl.text = value!;
                          });
                        },
                        onTap: () async{
                          DateTime ? date = DateTime.now();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          date = await showDatePicker(
                              locale: const Locale("fr","FR"),
                              context: context,
                              initialDate:DateTime.now(),
                              firstDate:DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            setState(() {
                              _dateFinCtl.text = _df.format(date!);
                            });
                          }
                        }),
                    ),
            ])),
            TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                controller: _noteCtl,
                decoration: InputDecoration(
                    labelText: "Note",
                    hintText: 'Information sur cette bête'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pas de note saisi";
                  }},
                onSaved: (value) {
                  setState(() {
                    _noteCtl.text = value!;
                  });
                }
            ),
            (_isSaving) ? CircularProgressIndicator():
            ElevatedButton(
                child: Text('Enregistrer',),
                //style: new TextStyle(color: Colors.white, ),),
                style : ButtonStyle(
                  textStyle: MaterialStateProperty.all( TextStyle(color: Colors.white, ) ),
                  backgroundColor: MaterialStateProperty.all<Color>( (Colors.lightGreen[700])! ),),
                //color: Colors.lightGreen[700],
                onPressed: _saveNote)
          ]),

    );
  }

  @override
  void initState() {
    super.initState();
    _dateDebutCtl.text = _df.format(DateTime.now());
  }

  void _saveNote() async {
    String message="";
    setState(() {
      _isSaving = true;
    });
    if (this.widget._currentNote == null)
      this.widget._currentNote = new NoteTextuelModel();
    this.widget._currentNote!.debut = _dateDebutCtl.text;
    this.widget._currentNote!.fin = _dateFinCtl.text;
    this.widget._currentNote!.note = _noteCtl.text;
    this.widget._currentNote!.bete_id = this.widget._bete.idBd;
    if (this.widget._bete != null)
      message = await this._bloc.saveNote(this.widget._currentNote!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }

}
