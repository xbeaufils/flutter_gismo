
import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/NumBoucle.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';

import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/CauseMort.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambingPresenter.dart';
import 'package:intl/intl.dart';

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
  void refreshLambing(LambingModel _lambing);
  LambingModel get currentLambing;
  set adoption(AdoptionEnum value);
  AdoptionEnum get adoption;
  set agnelage(AgnelageEnum value);
  AgnelageEnum get agnelage;
}

class _LambingPageState extends GismoStatePage<LambingPage> implements LambingContract {
  late LambingPresenter _presenter;

  AdoptionEnum _adoption = AdoptionEnum.level0;
  AdoptionEnum get adoption => _adoption;
  set adoption(AdoptionEnum value) {
    _adoption = value;
  }

  AgnelageEnum _agnelage = AgnelageEnum.level0;
  AgnelageEnum get agnelage => _agnelage;
  set agnelage(AgnelageEnum value) {
    setState(() {
      _agnelage = value;
    });
  }

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
                  mainAxisSize: MainAxisSize.min,
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
                      trailing: new IconButton(key: Key("btQualite"), onPressed: this._presenter.selectQualite, icon: new Icon(Icons.create)),),
                    ListTile(
                      title: Text(S.of(context).adoption_quality) ,
                      subtitle: Text(_adoption.key.toString() + " : " + transAdoption.translate(_adoption)),
                      trailing: new IconButton(key: Key("btAdoption"), onPressed: this._presenter.selectAdoption, icon: new Icon(Icons.create)),),
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
                    ),
                    this._buildPereWidget(),])),
              SizedBox(
                height: 200,
                child: this._lambList(), //LambsPage(this._lambing.lambs, _dateAgnelageCtl.text)
              ),
              FilledButton(key:null,
                onPressed: () {
                    this._presenter.saveLambing(
                        _dateAgnelageCtl.text, _obsCtl.text,
                        _adoption.key, _agnelage.key);
                },
                 child: Text(S.of(context).validate_lambing)
            )
          ]),
        ) ,
        floatingActionButton: (currentLambing.idBd == null)?
          FloatingActionButton(
            onPressed: this._presenter.addLamb,
            tooltip: S.of(context).add_lamb,
            child: new Icon(Icons.add),
          ): null,
    );
  }

  Widget _buildPereWidget() {
    String identifPere = "";
    if (currentLambing.numBouclePere != null || currentLambing.numMarquagePere != null)  {
      identifPere = currentLambing.numBouclePere! + " " + currentLambing.numMarquagePere!;
    }
    return
      ListTile(
        title: Text(S.of(context).ram) ,
        subtitle: Text(identifPere),
        trailing: (currentLambing.idPere == null ) ?
        IconButton(icon: Icon(Icons.search), onPressed: () => this._presenter.addPere(), ):
        IconButton(icon: Icon(Icons.close), onPressed: () => this._presenter.removePere(), ),);
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
        onPressed: () { this._presenter.editLamb(lamb);},);
  }

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



