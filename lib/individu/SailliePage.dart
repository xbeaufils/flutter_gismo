import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:intl/intl.dart';

class SailliePage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete _bete;
  SaillieModel ? _currentSaillie;
  @override
  _SailliePageState createState() => _SailliePageState(this._bloc);

  SailliePage(this._bloc,this._bete);
  SailliePage.edit(this._bloc, this._currentSaillie, this._bete, {Key ? key}) : super(key: key);

}

class _SailliePageState extends State<SailliePage> {
  final GismoBloc _bloc;
  _SailliePageState(this._bloc);
  TextEditingController _dateSaillieCtl = TextEditingController();

  TextEditingController _idPereCtl = TextEditingController();
  int ? _idPere ;
  String _numBouclePere = "";
  String _numMarquagePere = "";

  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("Saillie"),
        leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _dateSaillieCtl,
                decoration: InputDecoration(
                    labelText: "Date de saillie",
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pas de date saisie";
                  }},
                onSaved: (value) {
                  setState(() {
                    _dateSaillieCtl.text = value!;
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
                      _dateSaillieCtl.text = _df.format(date);
                    });
                  }
                }),
            Card(
              child: Column(children: [
                ListTile(
                  title: Text("Mâle") ,
                  subtitle: Text("Si vide, la saillie ne sera pas enregistrée ou sera supprimée"),
                ),
                ListTile(
                  title: Text(_numBouclePere) ,
                  subtitle: Text(_numMarquagePere),
                  trailing: (_idPere == null ) ?
                  IconButton(icon: Icon(Icons.search), onPressed: () => _addPere(), ):
                  IconButton(icon: Icon(Icons.close), onPressed: () => _removePere(), ),
                ),

              ],) ,
            ),
            (_isSaving) ? CircularProgressIndicator():
              ElevatedButton(
                child: Text('Enregistrer',),
                  //style: new TextStyle(color: Colors.white, ),),
                style : ButtonStyle(
                    textStyle: MaterialStateProperty.all( TextStyle(color: Colors.white, ) ),
                    backgroundColor: MaterialStateProperty.all<Color>( (Colors.lightGreen[700])! ),),
                //color: Colors.lightGreen[700],
                onPressed: _saveSaillie)
          ]),

    );
  }

  @override
  void initState() {
    super.initState();
    if (this.widget._currentSaillie == null) {
      _dateSaillieCtl.text = _df.format(DateTime.now());
    }
    else {
      _dateSaillieCtl.text = this.widget._currentSaillie!.dateSaillie!;
      _numBouclePere = (this.widget._currentSaillie!.numBouclePere != null) ? this.widget._currentSaillie!.numBouclePere! : "";
      _numMarquagePere =(this.widget._currentSaillie!.numMarquagePere != null) ? this.widget._currentSaillie!.numMarquagePere! : "";
    }
  }

  Future _addPere() async {
    Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          SearchPage search = new SearchPage(this._bloc, GismoPage.sailliePere);
          search.searchSex = Sex.male;
          return search;
        },
        fullscreenDialog: true
    ));
    if (selectedBete != null) {
      this.setState(() {
        this._idPere = selectedBete.idBd;
        this._numBouclePere = selectedBete.numBoucle;
        this._numMarquagePere = selectedBete.numMarquage;
      });
    }
  }

  void _removePere() {
    this.setState(() {
      this._idPere = null;
      this._numBouclePere = "";
      this._numMarquagePere = "";
    });
  }
  void _saveSaillie() async {
    String message;
    setState(() {
      _isSaving = true;
    });
    if (this.widget._currentSaillie == null)
      this.widget._currentSaillie = new SaillieModel();
    this.widget._currentSaillie!.idMere = this.widget._bete.idBd!;
    this.widget._currentSaillie!.dateSaillie = _dateSaillieCtl.text;
    this.widget._currentSaillie!.idPere = _idPere!;
    message =
      await this._bloc.saveSaillie(this.widget._currentSaillie!);
    ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }

}
