import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambPresenter.dart';

class LambPage extends StatefulWidget {
  LambModel ? _lamb;


  @override
  LambPageState createState() => LambPageState();

  LambPage.edit( this._lamb);
  LambPage();
}

abstract class LambContract extends GismoContract {
}

class LambPageState extends GismoStatePage<LambPage> implements LambContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _marquageCtrl = TextEditingController();
  Sex _sex = Sex.male;
  Sante _sante = Sante.VIVANT;
  late List<DropdownMenuItem<MethodeAllaitement>> _dropDownMenuItems;
  late MethodeAllaitement _currentAllaitement;
  late LambPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: _mainTitle(),
          actions: _getActionButton(),
        ),
        body:
          SingleChildScrollView (
            child:
                Card( child:
            Column(
              children: <Widget>[
                Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                  TextField(
                    decoration: InputDecoration(labelText: S.of(context).provisional_number),
                    controller: _marquageCtrl,
                  )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Flexible (child:
                        RadioListTile<Sex>(
                          title: Text(S.of(context).male),
                          value: Sex.male,
                          groupValue: _sex,
                          onChanged: (Sex ? value) { setState(() { _sex = value! ; }); },
                        ),
                      ),
                      new Flexible( child:
                        RadioListTile<Sex>(
                          title: Text(S.of(context).female),
                          value: Sex.femelle,
                          groupValue: _sex,
                          onChanged: (Sex ? value) { setState(() { _sex = value!; }); },
                        ),
                      ),]

                ),
                new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(S.of(context).health),
                        RadioListTile<Sante>(
                          dense: true,
                          title: Text(S.of(context).alive),
                          value: Sante.VIVANT,
                          groupValue: _sante,
                          onChanged: (Sante ? value) { setState(() { _sante = value!; }); },
                        ),
                        RadioListTile<Sante>(
                          dense: true,
                          title: Text(S.of(context).stillborn),
                          value: Sante.MORT_NE,
                          groupValue: _sante,
                          onChanged: (Sante ? value) { setState(() { _sante = value!; }); },
                        ),
                        RadioListTile<Sante>(
                          dense: true,
                          title: Text(S.of(context).aborted),
                          value: Sante.AVORTE,
                          groupValue: _sante,
                          onChanged: (Sante ? value) { setState(() { _sante = value!; }); },
                        ),
                    ]
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(S.of(context).breastfeeding_mode),
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                    ),
                    new DropdownButton(
                      value: _currentAllaitement,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  ],
                ),
                this._mainButton(),
              ]
          )),
    ),);
  }

  void changedDropDownItem(MethodeAllaitement ? selectedAllaitement) {
    setState(() {
      _currentAllaitement = selectedAllaitement!;
    });
  }

  @override
  void initState() {
    List<DropdownMenuItem<MethodeAllaitement>> items = [];
      items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_MATERNEL, child: new Text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle)));
      items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_ARTIFICIEL, child: new Text(MethodeAllaitement.ALLAITEMENT_ARTIFICIEL.libelle)));
      items.add(new DropdownMenuItem( value: MethodeAllaitement.ADOPTE, child: new Text(MethodeAllaitement.ADOPTE.libelle)));
      items.add(new DropdownMenuItem( value: MethodeAllaitement.BIBERONNE, child: new Text(MethodeAllaitement.BIBERONNE.libelle)));
    _dropDownMenuItems = items;
    if (this.widget._lamb != null) {
      _currentAllaitement = this.widget._lamb!.allaitement;
      if (this.widget._lamb!.marquageProvisoire != null )
        this._marquageCtrl.text = this.widget._lamb!.marquageProvisoire!;
      this._sex = this.widget._lamb!.sex;
      this._sante = this.widget._lamb!.sante;
    }
    else {
      _currentAllaitement = _dropDownMenuItems[0].value!;
    }
    this._presenter = LambPresenter(this);
    super.initState();
  }

  Widget _mainTitle() {
    if (this.widget._lamb == null)
      return Text( S.current.new_lamb);
    return Text(S.current.edit_lamb);
  }

  Widget _mainButton() {
    if (this.widget._lamb == null)
      return new FilledButton(
          onPressed: () => _presenter.addLamb(this._marquageCtrl.text, this._sex, this._currentAllaitement, this._sante),
          //color: Colors.lightGreen[900],
          child:
            Text(S.of(context).bt_add,)
      );
    return
      new FilledButton.icon(
        onPressed: () =>_presenter.saveLamb(this.widget._lamb!, this._marquageCtrl.text, this._sex, this._currentAllaitement, this._sante),
      //color: Colors.lightGreen[900],
        icon: Icon(Icons.save),
        label: Text(S.of(context).bt_save),
      ) ;
  }

  List<Widget> _getActionButton() {
    List <Widget> actionButtons = [];
    if (this.widget._lamb == null)
      actionButtons.add(Container());
    else {
      if (_sante != Sante.VIVANT)
        actionButtons.add(Container());
      else {
        if (this.widget._lamb!.dateDeces != null ||
            this.widget._lamb!.numBoucle != null)
          actionButtons.add(Container());
        else {
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/peseur.png"),
              onPressed: () {
                this._presenter.peser(this.widget._lamb!);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/syringe.png"),
              onPressed: () {
                this._presenter.traitement(this.widget._lamb!);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/tomb.png"),
              onPressed: () {
                this._presenter.mort(this.widget._lamb!);
              },),);
          actionButtons.add(
              IconButton(
                icon: Image.asset("assets/bouclage.png"),
                onPressed: () {
                  this._presenter.boucle(this.widget._lamb!);
                },));
        }
      }
    }
    return actionButtons;
  }


}

