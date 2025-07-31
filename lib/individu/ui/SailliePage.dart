import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/core/ui/NumBoucle.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/individu/presenter/SailliePresenter.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:intl/intl.dart';

class SailliePage extends StatefulWidget {
  Bete _bete;
  SaillieModel ? _currentSaillie;

  set currentSaillie(SaillieModel value) {
    _currentSaillie = value;
  }

  @override
  _SailliePageState createState() => _SailliePageState();

  SailliePage(this._bete);
  SailliePage.edit(this._currentSaillie, this._bete, {Key ? key}) : super(key: key);

}

abstract class SaillieContract extends GismoContract {
  Bete get bete;
  SaillieModel ? get currentSaillie;
  set currentSaillie(SaillieModel ? value);
  Future<Bete?> selectPere();
  void showSaving();
}

class _SailliePageState extends GismoStatePage<SailliePage> implements SaillieContract {
  late SailliePresenter _presenter;
  _SailliePageState();
  TextEditingController _dateSaillieCtl = TextEditingController();

  TextEditingController _idPereCtl = TextEditingController();
  int ? _idPere ;
  String _numBouclePere = "";
  String _numMarquagePere = "";

 // final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        centerTitle: true,
        title: Text(S.of(context).mating),primary: true,
        //leading: Text(this.widget._bete.numBoucle),
      ),
      body:
          Column(children: [
            NumBoucleView(this.widget._bete),
            Card( child:
              Column(
                children: <Widget> [
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: _dateSaillieCtl,
                    decoration: InputDecoration(
                        labelText: S.of(context).mating_date,
                        hintText: 'jj/mm/aaaa'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).no_mating_date;
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
                          _dateSaillieCtl.text = DateFormat.yMd().format(date);
                        });
                      }
                    }),
                ListTile(
                  title: Text(S.of(context).male) ,
                  subtitle: Text(S.of(context).mating_male_text),
                ),
                ListTile(
                  title: Text(_numBouclePere) ,
                  subtitle: Text(_numMarquagePere),
                  trailing: (_idPere == null ) ?
                  IconButton(icon: Icon(Icons.search),
                    onPressed: () => setState(() {
                      this._presenter.addPere();
                    }), ):
                  IconButton(icon: Icon(Icons.close),
                    onPressed: () => setState(() {
                      this._presenter.removePere();
                    }), ),
                ),

              ],) ,
            ),
            (_isSaving) ? CircularProgressIndicator():
              FilledButton(
                child: Text(S.of(context).bt_save,),
                onPressed: () => this._presenter.saveSaillie(_dateSaillieCtl.text))
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    if (this.widget._currentSaillie == null) {
      _dateSaillieCtl.text = DateFormat.yMd().format(DateTime.now());
    }
    else {
      _dateSaillieCtl.text = DateFormat.yMd().format(this.widget._currentSaillie!.dateSaillie!);
      _numBouclePere = (this.widget._currentSaillie!.numBouclePere != null) ? this.widget._currentSaillie!.numBouclePere! : "";
      _numMarquagePere =(this.widget._currentSaillie!.numMarquagePere != null) ? this.widget._currentSaillie!.numMarquagePere! : "";
    }
    _presenter = SailliePresenter(this);
  }


  Future<Bete?> selectPere()  async{
    Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          SearchPage search = new SearchPage(GismoPage.sailliePere);
          search.searchSex = Sex.male;
          return search;
        },
        fullscreenDialog: true
    ));
    return selectedBete;
  }

  Bete get bete => this.widget._bete;

  SaillieModel ? get currentSaillie => this.widget._currentSaillie;

  set currentSaillie(SaillieModel ? value) {
    this.widget._currentSaillie = value;
  }
}
