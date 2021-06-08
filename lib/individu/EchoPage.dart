import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:intl/intl.dart';

class EchoPage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete _bete;
  EchographieModel ? _currentEcho;
  @override
  EchoPageState createState() => EchoPageState(this._bloc);

  EchoPage(this._bloc,this._bete);
  EchoPage.edit(this._bloc, this._currentEcho, this._bete, {Key ? key}) : super(key: key);

}

class EchoPageState extends State<EchoPage> {
  final GismoBloc _bloc;
  EchoPageState(this._bloc);
  //double _pesee = 0.0;
  TextEditingController _dateEchoCtl = TextEditingController();
  TextEditingController _dateSaillieCtl = TextEditingController();
  TextEditingController _dateAgnelageCtl = TextEditingController();

  //TextEditingController _nombreCtl = TextEditingController();
  int _nombre = 0;

  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("Echographie"),
        leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _dateEchoCtl,
                decoration: InputDecoration(
                    labelText: "Date d\'echographie",
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pas de date saisie";
                  }},
                onSaved: (value) {
                  setState(() {
                    _dateEchoCtl.text = value!;
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
                      lastDate: DateTime(2100)) as DateTime;
                  if (date != null) {
                    setState(() {
                      _dateEchoCtl.text = _df.format(date);
                    });
                  }
                }),
            new Text(
              'Résultat :',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Radio(
                  value: 0,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  'Vide',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 1,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  'simple',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ]),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                  value: 2,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  'Double',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 3,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  'Triple et +',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _dateSaillieCtl,
                decoration: InputDecoration(
                    labelText: "Date de saillie estimée",
                    hintText: 'jj/mm/aaaa'),
                onSaved: (value) {
                  setState(() {
                    _dateSaillieCtl.text = value!;
                  });
                },
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100)) as DateTime;
                  if (date != null) {
                    setState(() {
                      _dateSaillieCtl.text = _df.format(date);
                    });
                  }
                }),
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _dateAgnelageCtl,
                decoration: InputDecoration(
                    labelText: "Date d'agnelage prévu",
                    hintText: 'jj/mm/aaaa'),
                onSaved: (value) {
                  setState(() {
                    _dateAgnelageCtl.text = value!;
                  });
                },
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime ? date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _dateAgnelageCtl.text = _df.format(date);
                    });
                  }
                }),

            (_isSaving) ? CircularProgressIndicator():
              RaisedButton(
                child: Text('Enregistrer',
                  style: new TextStyle(color: Colors.white, ),),
                color: Colors.lightGreen[700],
                onPressed: _saveEcho)
          ]),

    );
  }

  @override
  void initState() {
    super.initState();
    if (this.widget._currentEcho == null)
      _dateEchoCtl.text = _df.format(DateTime.now());
    else {
      _nombre = this.widget._currentEcho!.nombre;
      _dateEchoCtl.text = this.widget._currentEcho!.dateEcho;
      if (this.widget._currentEcho!.dateAgnelage != null)
        _dateAgnelageCtl.text = this.widget._currentEcho!.dateAgnelage!;
      if (this.widget._currentEcho!.dateSaillie != null)
      _dateSaillieCtl.text = this.widget._currentEcho!.dateSaillie!;
    }
   // _nec = this.widget._currentLevel;
  }

  void _handleRdNombreChange(int ? value) {
    setState(() {
      _nombre = value!;
    });
  }

  void _saveEcho() async {
    String message;
    if (_nombre == null) {
      message = "Le nombre de foetus est vide";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    setState(() {
      _isSaving = true;
    });
    if (this.widget._currentEcho == null)
      this.widget._currentEcho = new EchographieModel();
    this.widget._currentEcho!.bete_id = this.widget._bete.idBd;
    this.widget._currentEcho!.dateEcho = _dateEchoCtl.text;
    this.widget._currentEcho!.nombre = _nombre;
    if (_dateSaillieCtl.text.isNotEmpty)
      this.widget._currentEcho!.dateSaillie = _dateSaillieCtl.text;
    else
      this.widget._currentEcho!.dateSaillie = null;
    if (_dateAgnelageCtl.text.isNotEmpty )
      this.widget._currentEcho!.dateAgnelage = _dateAgnelageCtl.text;
    else
      this.widget._currentEcho!.dateAgnelage = null;
    message =
      await this._bloc.saveEcho(this.widget._currentEcho!);
    ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }

}
