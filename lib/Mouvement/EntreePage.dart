import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Bete.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class EntreePage extends StatefulWidget {
  final GismoBloc _bloc;
  EntreePage(this._bloc, {Key ? key}) : super(key: key);
  @override
  _EntreePageState createState() => new _EntreePageState(_bloc);
}

class _EntreePageState extends State<EntreePage> {
  final GismoBloc _bloc;
  _EntreePageState(this._bloc);

  TextEditingController _dateEntreeCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  late List<Bete> _sheeps;
  String ?  _currentMotif;
  late List<DropdownMenuItem<String>> _motifEntreeItems;
  //BannerAd ? _adBanner;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _getMotifEntreeItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add( new DropdownMenuItem(value: 'NAISSANCE', child: new Text('Naissance')));
    items.add( new DropdownMenuItem(value: 'CREATION', child: new Text('Création')));
    items.add( new DropdownMenuItem(value: 'RENOUVELLEMENT', child: new Text('Renouvellement')));
    items.add( new DropdownMenuItem(value: 'ACHAT', child: new Text('Achat')));
    items.add( new DropdownMenuItem(value: 'MUTATION_INTERNE', child: new Text('Mutation interne')));
    items.add( new DropdownMenuItem(value: 'REACTIVATION', child: new Text('Réactivation')));
    items.add( new DropdownMenuItem(value: 'PRET_OU_PENSION', child: new Text('Prêt ou pension')));
    items.add( new DropdownMenuItem(value: 'ENTREE_EN_SCI_OU_CE', child: new Text('Entree en SCI ou CE')));
    items.add( new DropdownMenuItem(value: 'REPRISE_EN_SCI_OU_CE', child: new Text('Reprise en SCI ou CE')));
    items.add( new DropdownMenuItem(value: 'INCONNUE', child: new Text('Inconnue')));
    return items;
  }

  void _changedMotifEntreeItem(String ? selectedMotif) {
    setState(() {
      if (selectedMotif != null)
        _currentMotif= selectedMotif;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Entree'),
      ),
      body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Card(key: null,
              child:Column(
                children: <Widget>[
                  new TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateEntreeCtl,
                      decoration: InputDecoration(
                          labelText: "Date d'entrée",
                          hintText: 'jj/mm/aaaa'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Pas de date d'entrée";
                        }},
                      onSaved: (value) {
                        setState(() {
                          _dateEntreeCtl.text = value!;
                        });
                      },
                      onTap: () async{
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = (await showDatePicker(

                          locale: const Locale("fr","FR"),
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100)))!;
                        if (date != null) {
                          setState(() {
                            _dateEntreeCtl.text = _df.format(date);
                          });
                        }
                      }),
                  new DropdownButton<String>(
                    value: _currentMotif,
                    items: _motifEntreeItems,
                    hint: Text("Selectionnez une cause d'entree",style: TextStyle(color: Colors.lightGreen,)),
                    onChanged: _changedMotifEntreeItem,
                  )

                ],
              )),
          Expanded(
            child: Sheeps(this._sheeps, this)),
          RaisedButton(
            child: Text('Enregistrer',
                style: new TextStyle(color: Colors.white, ),),
            color: Colors.lightGreen[700],
            onPressed: _saveEntree),
          (this._bloc.isLogged()!) ?
            Container():_getAdmobAdvice()
           /* AdmobBanner(
              adUnitId: _getBannerAdUnitId()!,
              adSize: AdmobBannerSize.BANNER,),*/

          ]

      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: 'Ajouter une bête',
        child: new Icon(Icons.add),
      ),
    );
  }
  Widget _getAdmobAdvice() {
    if (this._bloc.isLogged() ! ) {
      return Container();
    }
    /*
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return
        Card(child:
          Container(
            height:  this._adBanner!.size.height.toDouble(),
            width:  this._adBanner!.size.width.toDouble(),
            child: AdWidget(ad:  this._adBanner!)));

    }*/
    return Container();
  }

  String ? _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/7971231462';
    }
    return null;
  }

  void _saveEntree() {
    if (_dateEntreeCtl.text.isEmpty) {
      showError("Pas de date d'entréee");
      return;
    }

    if ( _currentMotif == null) {
      showError("Cause d'entrée obligatoire");
      return;
    }
    if (_currentMotif!.isEmpty) {
      showError("Cause d'entrée obligatoire");
      return;
    }
    if (_sheeps.length == 0) {
      showError("Liste des betes vide");
      return;
    }

    var message  = this._bloc.saveEntree(_dateEntreeCtl.text, _currentMotif!, this._sheeps);
    message
      .then( (message) {goodSaving(message);})
      .catchError( (message) {showError(message);});
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Entree : " + message;
    Navigator.pop(context, message);
  }

  Future _openAddEntryDialog() async {
      Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
          builder: (BuildContext context) {
            return new BetePage(this._bloc, null);
          },
          fullscreenDialog: true
      )) as Bete;
      if (selectedBete != null) {
        setState(() {
          _sheeps.add(selectedBete);
        });
      }
  }

  @override
  void initState() {
    super.initState();
    _sheeps = [];
    _motifEntreeItems = _getMotifEntreeItems();
    _dateEntreeCtl.text = _df.format(DateTime.now());
    /*
    this._adBanner = BannerAd(
      adUnitId: _getBannerAdUnitId()!, //'<ad unit ID>',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    this._adBanner!.load();*/
  }
  @override
  void dispose() {
    super.dispose();
    //this._adBanner!.dispose();
  }

  void removeBete(int index) {
    setState(() {
      _sheeps.removeAt(index);
    });

  }
}

class Sheeps extends StatelessWidget {
  final List<Bete> _sheeps;
  _EntreePageState _entree;
  Sheeps(this._sheeps, this._entree);

  Widget _buildLambItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
            title: Text(_sheeps[index].numBoucle),
            subtitle: Text(_sheeps[index].numMarquage),
            trailing: IconButton(icon: Icon(Icons.clear), onPressed:() {  _entree.removeBete(index);} ),
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: _sheeps.length,
    );
  }
}
