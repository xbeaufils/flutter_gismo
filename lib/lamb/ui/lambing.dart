import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/core/ui/NumBoucle.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';

import 'package:flutter_gismo/lamb/ui/Adoption.dart';
import 'package:flutter_gismo/lamb/ui/AgnelageQualityPage.dart';
import 'package:flutter_gismo/lamb/ui/LambPage.dart';
import 'package:flutter_gismo/lamb/ui/SearchPerePage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/CauseMort.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambingPresenter.dart';
import 'package:flutter_gismo/services/LambingService.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as debug;

class LambingPage extends StatefulWidget {
  Bete ? _mere;
  late LambingModel _currentLambing;

  Bete ? get mere => _mere;

  LambingPage(this._mere, {Key? key}) : super(key: key) {
    _currentLambing = new LambingModel(this._mere!.idBd!);
    _currentLambing.setDateAgnelage( DateTime.now());
    _currentLambing.adoption = 0;
    _currentLambing.qualite =  0;
  }

  LambingPage.edit( this._currentLambing);
  LambingPage.modify(this._currentLambing);

  @override
  _LambingPageState createState() => new _LambingPageState();

  LambingModel get currentLambing => _currentLambing;
}

abstract class LambingContract extends GismoContract {
  Future<Bete ?> searchPere();
  Future<Bete ?> showPerePage();
  Future<LambModel?> addLamb();
  void refreshLambing(LambingModel _lambing);
  Future<LambModel?> editLamb (LambModel lamb, String dateNaissance);
  LambingModel get currentLambing;
}

class _LambingPageState extends GismoStatePage<LambingPage> implements LambingContract {
  late LambingPresenter _presenter;

  AdoptionEnum _adoption = AdoptionEnum.level0;
  AgnelageEnum _agnelage = AgnelageEnum.level0;

  TextEditingController _dateAgnelageCtl = TextEditingController();
  TextEditingController _obsCtl = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  _LambingPageState() {
    _presenter = LambingPresenter(this);
  }
  LambingModel get currentLambing => this.widget._currentLambing;

  @override
  Widget build(BuildContext context) {
    AdoptionHelper transAdoption = new AdoptionHelper(this.context);
    AgnelageHelper transAgnelage = new AgnelageHelper(this.context);
    return new Scaffold(
      appBar: new AppBar(
        title: (this.widget._mere != null) ? 
          new Text(this.widget._mere!.numBoucle + " (" + this.widget._mere!.numMarquage + ")") :
          new Text(this.widget._currentLambing.numBoucleMere! + " (" + this.widget._currentLambing.numMarquageMere! + ")"),
        key: _scaffoldKey,
      ),
      body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10),
          child:
            Column (children: [
              ( this.widget._mere == null) ? Container(): NumBoucleView(this.widget._mere!),
              Card (
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding:  const EdgeInsets.all(8.0),
                      child:
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: _dateAgnelageCtl,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                              labelText: S.of(context).lambing_date),
                          validator: (value) {
                                      if (value!.isEmpty) {
                                        return S.of(context).enter_lambing_date;
                                      }
                                      return null;
                                      },
                          onSaved: (value) {
                                      setState(() {
                                        _dateAgnelageCtl.text = value!;
                                      });
                                    },
                          onTap: () async{
                                  DateTime ? date = DateTime.now();
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  date = await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(2100)) ;
                                  if (date != null) {
                                    setState(() {
                                      _dateAgnelageCtl.text = DateFormat.yMd().format(date!);
                                    });
                                  }
                                })),
                    ListTile(
                      title: Text(S.of(context).lambing_quality) ,
                      subtitle: Text(_agnelage.key.toString() + " : " + transAgnelage.translate(_agnelage)),
                      trailing: new IconButton(key: Key("btQualite"), onPressed: _openAgnelageDialog, icon: new Icon(Icons.create)),),
                    ListTile(
                      title: Text(S.of(context).adoption_quality) ,
                      subtitle: Text(_adoption.key.toString() + " : " + transAdoption.translate(_adoption)),
                      trailing: new IconButton(key: Key("btAdoption"), onPressed: _openAdoptionDialog, icon: new Icon(Icons.create)),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                        TextFormField(
                          controller: _obsCtl,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                              labelText: S.of(context).observations,
                              hintText: 'Obs',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder()),
                            maxLines: 3,
                            onSaved: (value) {
                              setState(() {
                                  _obsCtl.text = value!;
                            });
                          })
                    ),])),
              this._buildPereWidget(),
              SizedBox(
                height: 200,
                child: this._lambList(), //LambsPage(this._lambing.lambs, _dateAgnelageCtl.text)
              ),
              FilledButton(key:null,
                onPressed: () {
                  try {
                    this._presenter.saveLambing(
                        _dateAgnelageCtl.text, _obsCtl.text,
                        _adoption.key, _agnelage.key);
                  } on NoLamb {
                    super.showMessage(S.current.no_lamb);
                  }
                },
                 child: Text(S.of(context).validate_lambing)
            )
          ]),
        ) ,
        floatingActionButton: (currentLambing.idBd == null)?
          FloatingActionButton(
            onPressed: _openAddEntryDialog,
            tooltip: S.of(context).add_lamb,
            child: new Icon(Icons.add),
          ): null,
    );
  }

  void _addLamb(LambModel newLamb){
    setState(() {
      _presenter.currentLambing.lambs.add(newLamb);
      //_lambs.add(newLamb);
    });
  }

  Widget _buildPereWidget() {
    String identifPere = "";
    if (currentLambing.numBouclePere != null || currentLambing.numMarquagePere != null)  {
      identifPere = currentLambing.numBouclePere! + " " + currentLambing.numMarquagePere!;
    }
    return Card(
      child:
      ListTile(
        title: Text(S.of(context).ram) ,
        subtitle: Text(identifPere),
        trailing: (currentLambing.idPere == null ) ?
        IconButton(icon: Icon(Icons.search), onPressed: () => this._presenter.addPere(), ):
        IconButton(icon: Icon(Icons.close), onPressed: () => this._presenter.removePere(), ),));
  }


  Future<Bete ?> showPerePage() async {
    Bete ? pere = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPerePage( currentLambing),
      ),
    );
    return pere;
  }

  Future<Bete ?> searchPere() async {
    Bete ? pere = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          SearchPage search = new SearchPage( GismoPage.sailliePere);
          search.searchSex = Sex.male;
          return search;
        },
        fullscreenDialog: true
    ));
    return pere;
  }

  Future<LambModel?> addLamb() async {
    LambModel? newLamb = await Navigator.of(context).push(new MaterialPageRoute<LambModel>(
        builder: (BuildContext context) {
          return new LambPage(); // AddingLambDialog(this._bloc);
        },
        fullscreenDialog: true
    ));
    return newLamb;
  }

  Future _openAddEntryDialog() async {
    LambModel? newLamb = await Navigator.of(context).push(new MaterialPageRoute<LambModel>(
        builder: (BuildContext context) {
          return new LambPage(); // AddingLambDialog(this._bloc);
        },
        fullscreenDialog: true
    ));
    if (newLamb != null) {
      _addLamb(newLamb);
    }
  }

  Future _openAdoptionDialog() async {
    int ? qualiteAdoption = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AdoptionDialog(this._adoption.key);
        },
        fullscreenDialog: true
    ));
    if (qualiteAdoption != null) {
      setState(() {
        _adoption = AdoptionHelper.getAdoption(qualiteAdoption);
      });
    }
  }

  Future _openAgnelageDialog() async {
    int ? qualiteAgnelage = await Navigator.of(context).push(new MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return new AgnelageDialog(this._agnelage.key);
        },
        fullscreenDialog: true
    ));
    if (qualiteAgnelage != null) {
      setState(() {
        _agnelage = AgnelageHelper.getAgnelage(qualiteAgnelage);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    //this._adBanner!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateAgnelageCtl.text = DateFormat.yMd().format(currentLambing.dateAgnelage!);
    if (currentLambing.observations != null)
      _obsCtl.text = currentLambing.observations!;
    _adoption = AdoptionHelper.getAdoption(currentLambing.adoption!);
    _agnelage = AgnelageHelper.getAgnelage(currentLambing.qualite!);
    this._presenter = LambingPresenter(this);
  }

  Widget _buildLambItem(BuildContext context, int index) {
    String sexe = (currentLambing.lambs[index].sex == Sex.male) ? S.of(context).male : "";
    sexe = (currentLambing.lambs[index].sex == Sex.femelle) ? S.of(context).female : sexe;
    return ListTile(
      leading: (currentLambing.lambs[index].marquageProvisoire == null) ? null : Text(currentLambing.lambs[index].marquageProvisoire!),
      title: Text(sexe) ,
      subtitle: (currentLambing.lambs[index].allaitement != null) ? Text(currentLambing.lambs[index].allaitement.libelle): Text(S.of(context).breastfeeding_not_specified), // Text(_lambs[index].marquageProvisoire),
      trailing:  _buildTrailing(currentLambing.lambs[index]),);
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
        Text(DateFormat.yMd().format(lamb.dateDeces!)),
      ],);

    return
      IconButton(
        icon: new Icon(Icons.keyboard_arrow_right),
        onPressed: () { this._presenter.editLamb(lamb, this._dateAgnelageCtl.text);},);
  }

  Future<LambModel?> editLamb (LambModel lamb, String dateNaissance) async {
    LambModel? newLamb = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LambPage.edit( lamb)),
    );
    return newLamb;
  }
/*
  void _openEdit(LambModel lamb, String dateNaissance) async {
    LambModel? newLamb = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LambPage.edit( lamb)),
    );
    if (newLamb == null)
      return;
    //this._bloc!.saveLamb(newLamb);
    currentLambing.lambs.forEach((aLamb) {
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
*/
  Widget _lambList() {
    return ListView.builder(
      itemBuilder: _buildLambItem,
      itemCount: currentLambing.lambs.length,
    );
  }

  @override
  void refreshLambing(LambingModel  lambing) {
    setState(() {

    });
  }

}



