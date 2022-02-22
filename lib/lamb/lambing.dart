import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';

import 'package:flutter_gismo/lamb/Adoption.dart';
import 'package:flutter_gismo/lamb/AgnelageQualityPage.dart';
import 'package:flutter_gismo/lamb/LambPage.dart';
import 'package:flutter_gismo/lamb/SearchPerePage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/CauseMort.dart';
import 'package:flutter_gismo/model/LambModel.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as debug;

class LambingPage extends StatefulWidget {
  final GismoBloc _bloc;

  Bete ? _mere;
  LambingModel ? _currentLambing;
  LambingPage(this._bloc, this._mere, {Key? key}) : super(key: key);
  LambingPage.edit(this._bloc, this._currentLambing);

  @override
  _LambingPageState createState() => new _LambingPageState(_bloc);
}

class _LambingPageState extends State<LambingPage> {
  //List<LambModel> _lambs = new List();
  final GismoBloc _bloc;
  late LambingModel _lambing;
  //List<LambModel> _lambs;
  //BannerAd ? _adBanner;

  DateTime selectedDate = DateTime.now();
  final df = new DateFormat('dd/MM/yyyy');
  Adoption _adoption = Adoption.level0;
  Agnelage _agnelage = Agnelage.level0;

  TextEditingController _dateAgnelageCtl = TextEditingController();
  TextEditingController _obsCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _LambingPageState(this._bloc);

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        title: (this.widget._mere != null) ? 
          new Text(this.widget._mere!.numBoucle + " (" + this.widget._mere!.numMarquage + ")") :
          new Text(this.widget._currentLambing!.numBoucleMere! + " (" + this.widget._currentLambing!.numMarquageMere! + ")"),
        key: _scaffoldKey,
      ),
      body:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateAgnelageCtl,
                      decoration: InputDecoration(

                                    labelText: 'Date Agnelage',
                                    hintText: 'jj/mm/aaaa'),
                      validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Entrez une date d''agnelage';
                                  }
                                  return null;
                                  },
                      onSaved: (value) {
                                  setState(() {
                                    _dateAgnelageCtl.text = value!;
                                  });
                                },
                      onTap: () async{
                              DateTime date = DateTime.now();
                              FocusScope.of(context).requestFocus(new FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100)) as DateTime;
                              if (date != null) {
                                setState(() {
                                  _dateAgnelageCtl.text = df.format(date);
                                });
                              }
                            }),
                ListTile(
                  title: Text("Qualité d'agnelage") ,
                  subtitle: Text(_agnelage.key.toString() + " : " +_agnelage.value),
                  trailing: new IconButton(onPressed: _openAgnelageDialog, icon: new Icon(Icons.create)),),
                ListTile(
                  title: Text("Qualité adoption") ,
                  subtitle: Text(_adoption.key.toString() + " : " +_adoption.value),
                  trailing: new IconButton(onPressed: _openAdoptionDialog, icon: new Icon(Icons.create)),),
                TextFormField(
                  controller: _obsCtl,
                  decoration: InputDecoration(
                  labelText: 'Observations',
                  hintText: 'Obs',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder()),
                  maxLines: 3,
                  onSaved: (value) {
                    setState(() {
                          _obsCtl.text = value!;
                    });
                  }
                ),
                this._buildPereWidget(),
                SizedBox(
                  height: 200,
                  child: this._lambList(), //LambsPage(this._lambing.lambs, _dateAgnelageCtl.text)
                ),
                 /*new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[*/
                ButtonBar(alignment: MainAxisAlignment.start,
                    children : [ ElevatedButton(key:null,
                        onPressed:saveLambing,
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen[700])),
                        //color: Colors.lightGreen[700],
                        child:
                          new Text(
                          "Valider l'agnelage",
                          style: new TextStyle(color: Colors.white, ), )
                    )
                  ]
                ),
                (this._bloc.isLogged()!) ?
                Container():_getAdmobAdvice(),
            ],),
          ) ,
      floatingActionButton: (this._lambing.idBd == null)?
      new FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: 'Ajouter un agneau',
        child: new Icon(Icons.add),
      ): null,
    );
  }

  Widget _getAdmobAdvice() {
    if (this._bloc.isLogged() ! ) {
      return Container();
    }/*
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return Card(
          child:
          Container(
              height:  this._adBanner!.size.height.toDouble(),
              width:  this._adBanner!.size.width.toDouble(),
              child: AdWidget(ad:  this._adBanner!)));
    }*/
    return Container();
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/4514368033';
    }
    return "";
  }

  void _addLamb(LambModel newLamb){
    setState(() {
      _lambing.lambs.add(newLamb);
      //_lambs.add(newLamb);
    });
  }

  Widget _buildPereWidget() {
    String identifPere = "";
    if (_lambing.numBouclePere!=null ||_lambing.numMarquagePere!=null)  {
      identifPere = _lambing.numBouclePere! + " " + _lambing.numMarquagePere!;
    }
    return ListTile(
      title: Text("Père") ,
      subtitle: Text(identifPere),
      trailing: (_lambing.idPere == null ) ?
      IconButton(icon: Icon(Icons.search), onPressed: () => _addPere(), ):
      IconButton(icon: Icon(Icons.close), onPressed: () => _removePere(), ),);
  }

  void _addPere() async {
    this._lambing.setDateAgnelage( _dateAgnelageCtl.text );
    Bete ? pere;
    if (this._bloc.isLogged() != null) {
      if (this._bloc.isLogged()!) {
        pere = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPerePage(this._bloc, this._lambing),
          ),
        ) as Bete;
      }
      else
        pere = await this._searchPere();
    }
    else
      pere = await this._searchPere();
    if (pere != null)
     setState(() {
       _lambing.numBouclePere=  (pere == null)?null:pere.numBoucle;
       _lambing.numMarquagePere = pere!.numMarquage;
       _lambing.idPere = (pere == null)?null:pere.idBd;
     });
  }

  Future<Bete ?> _searchPere() async {
    Bete ? pere = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          SearchPage search = new SearchPage(this._bloc, GismoPage.sailliePere);
          search.searchSex = Sex.male;
          return search;
        },
        fullscreenDialog: true
    ));
    return pere;
  }

  void _removePere() {
    setState(() {
      _lambing.numBouclePere=  null;
      _lambing.numMarquagePere = null;
      _lambing.idPere = null;
    });
  }

  Future _openAddEntryDialog() async {
    LambModel newLamb = await Navigator.of(context).push(new MaterialPageRoute<LambModel>(
        builder: (BuildContext context) {
          return new LambPage(this._bloc); // AddingLambDialog(this._bloc);
        },
        fullscreenDialog: true
    )) as LambModel;
    if (newLamb != null) {
      _addLamb(newLamb);
    }
  }

  Future _openAdoptionDialog() async {
    int qualiteAdoption = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AdoptionDialog(this._adoption.key);
        },
        fullscreenDialog: true
    )) as int;
    if (qualiteAdoption != null) {
      setState(() {
        _adoption = Adoption.getAdoption(qualiteAdoption);
      });
    }
  }

  Future _openAgnelageDialog() async {
    int qualiteAgnelage = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AgnelageDialog(this._agnelage.key);
        },
        fullscreenDialog: true
    ))as int;
    if (qualiteAgnelage != null) {
      setState(() {
        _agnelage = Agnelage.getAgnelage(qualiteAgnelage);
      });
    }
  }

  void saveLambing() {
    _lambing.setDateAgnelage(_dateAgnelageCtl.text);
    _lambing.observations = _obsCtl.text;
    _lambing.adoption = _adoption.key;
    _lambing.qualite = _agnelage.key;

    var message  = this._bloc.saveLambing(this._lambing);
    message!
        .then( (message) {goodSaving(message);})
        .catchError( (message) {  _handleError(message); /*badSaving(message);*/});
  }

  void _handleError(Object obj) {
    debug.log("ERROR", name:"_LambPageState::_handleError", error: obj);
  }

  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    message = "Agnelage : " + message;
    Navigator.pop(context, message);
  }
  //void radioChanged(double value) {}

  @override
  void initState() {
    super.initState();
    if (this.widget._currentLambing == null) {
      _lambing = new LambingModel(this.widget._mere!.idBd!);
      _dateAgnelageCtl.text = df.format(selectedDate);
      _adoption = Adoption.level0;
      _agnelage = Agnelage.level0;
    }
    else {
      _lambing = this.widget._currentLambing!;
      _dateAgnelageCtl.text = _lambing.dateAgnelage!;
      if (_lambing.observations != null)
        _obsCtl.text = _lambing.observations!;
      _adoption = Adoption.getAdoption(_lambing.adoption!);
      _agnelage = Agnelage.getAgnelage(_lambing.qualite!);
    }/*
    this._adBanner = BannerAd(
      adUnitId: _getBannerAdUnitId(), //'<ad unit ID>',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    this._adBanner!.load();
    */
  }

  @override
  void dispose() {
    super.dispose();
    //this._adBanner!.dispose();
  }

  Widget _buildLambItem(BuildContext context, int index) {
    String sexe = (_lambing.lambs[index].sex == Sex.male) ?"Male" : "";
    sexe = (_lambing.lambs[index].sex == Sex.femelle) ?"Femelle" : sexe;
    return ListTile(
      leading: (_lambing.lambs[index].marquageProvisoire == null) ? null : Text(_lambing.lambs[index].marquageProvisoire!),
      title: Text(sexe) ,
      subtitle: (_lambing.lambs[index].allaitement != null) ? Text(_lambing.lambs[index].allaitement.libelle): Text("Allaitement non spécifié"), // Text(_lambs[index].marquageProvisoire),
      trailing:  _buildTrailing(_lambing.lambs[index]),);
  }

  Widget ? _buildTrailing(LambModel lamb) {
    if (lamb.idBd == null)
      return null;
    if (lamb.numBoucle != null )
      return Column(
        children: <Widget>[
          Text(lamb.numBoucle!),
          Text(lamb.numMarquage!),
        ],
      );

    if (lamb.dateDeces != null)
      return Column(children: <Widget>[
        Text(CauseMortExtension.getValue(lamb.motifDeces!).name),
        Text(lamb.dateDeces!),
      ],);

    return
      IconButton(
        icon: new Icon(Icons.keyboard_arrow_right),
        onPressed: () {_openEdit(lamb, this._dateAgnelageCtl.text);},);
   }

  void _openEdit(LambModel lamb, String dateNaissance) async {
    LambModel newLamb = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LambPage.edit( this._bloc, lamb)),
    );
    if (newLamb == null)
      return;
    this._bloc.saveLamb(newLamb);
    _lambing.lambs.forEach((aLamb) {
      if (aLamb.idBd == newLamb.idBd) {
        aLamb.sex = newLamb.sex;
        aLamb.allaitement = newLamb.allaitement;
        aLamb.marquageProvisoire = newLamb.marquageProvisoire;
        aLamb.dateDeces = newLamb.dateDeces;
        aLamb.motifDeces = newLamb.motifDeces;
        aLamb.numBoucle = newLamb.numBoucle;
        aLamb.numMarquage = newLamb.numMarquage;
      }
    });
    setState(() {

    });
  }

  Widget _lambList() {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: _lambing.lambs.length,
    );
  }
}



