import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:intl/intl.dart';

class PeseePage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete _bete;

  @override
  PeseePageState createState() => PeseePageState(this._bloc);

  PeseePage(this._bloc,this._bete);
}

class PeseePageState extends State<PeseePage> {
  final GismoBloc _bloc;
  PeseePageState(this._bloc);
  int _nec = 0;
  TextEditingController _dateNoteCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("Pesée"),
        leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _dateNoteCtl,
                decoration: InputDecoration(
                    labelText: "Date de pesée",
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Pas de date de pesée";
                  }},
                onSaved: (value) {
                  setState(() {
                    _dateNoteCtl.text = value;
                  });
                },
                onTap: () async{
                  DateTime date = DateTime.now();
                  FocusScope.of(context).requestFocus(new FocusNode());
                  date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _dateNoteCtl.text = _df.format(date);
                    });
                  }
                }),
            _getNec(NEC.level0),
            _getNec(NEC.level1),
            _getNec(NEC.level2),
            _getNec(NEC.level3),
            _getNec(NEC.level4),
            _getNec(NEC.level5),
            (_isSaving) ? CircularProgressIndicator():
              RaisedButton(
                child: Text('Enregistrer',
                  style: new TextStyle(color: Colors.white, ),),
                color: Colors.lightGreen[700],
                onPressed: _saveNote)
          ]),

    );
  }

  Widget _getNec(NEC nec) {
    return RadioListTile<int>(
      title: Text(nec.note.toString()),
      subtitle: Text(nec.label),
      secondary: IconButton(
        icon: new Icon(Icons.help),
        onPressed: () =>{
          Navigator.push(context,MaterialPageRoute(builder: (context) => HelpPage( nec),),)},),
      value: nec.note,
      groupValue: _nec,
      onChanged: (int value) {
        setState(() {
          _nec = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
   // _nec = this.widget._currentLevel;
  }

  void _saveNote() async {
    setState(() {
      _isSaving = true;
    });
    String message = await this._bloc.saveNec(this.widget._bete,  NEC.getNEC(_nec), _dateNoteCtl.text);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }

}

class HelpPage  extends StatefulWidget {

  NEC _nec;

  HelpPage(this._nec);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: const Text("Note d'état corporel"),
    ),
    body:
      Card(
        child: ListTile(
          leading: Text(this.widget._nec.note.toString()),
          title: (Text(this.widget._nec.label)),
          subtitle: Text(this.widget._nec.description),
        ),)
    );
  }
}