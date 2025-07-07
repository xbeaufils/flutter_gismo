import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/lamb/ui/Bouclage.dart';
import 'package:flutter_gismo/lamb/ui/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambPresenter.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:intl/intl.dart';

class LambPage extends StatefulWidget {
  LambModel ? _lamb;


  @override
  LambPageState createState() => LambPageState();

  LambPage.edit( this._lamb);
  LambPage();
}

abstract class LambContract {
  Future <Bete?> showBouclage(LambModel lamb);
  Future<String> showDeath(LambModel lamb);
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
            SingleChildScrollView (child:
          Column(
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(labelText: S.of(context).provisional_number),
                  controller: _marquageCtrl,
                ),
                new Row(
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
                SizedBox(
                    height: 200,
                    child : (this.widget._lamb == null) ? Container() : _buildEvents())
              ]
          ),
    ),);
  }

  void _addLamb() {
    Navigator
        .of(context)
        .pop(new LambModel(this._marquageCtrl.text, this._sex, this._currentAllaitement, this._sante));
  }

  void _saveLamb() {
    this.widget._lamb!.marquageProvisoire = this._marquageCtrl.text;
    this.widget._lamb!.sex = this._sex;
    this.widget._lamb!.allaitement = this._currentAllaitement;
    this.widget._lamb!.sante = this._sante;
    Navigator
        .of(context)
        .pop(this.widget._lamb);
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
      return new ElevatedButton(
          onPressed:_addLamb,
          //color: Colors.lightGreen[900],
          child:
          new Text(S.of(context).bt_add,
            style: new TextStyle(color: Colors.white),
          )
      );
    return
      new ElevatedButton.icon(
        onPressed:_saveLamb,
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
                _openPesee(this.widget._lamb!);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/syringe.png"),
              onPressed: () {
                _openTraitement(this.widget._lamb!);
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

  Widget _buildEvents() {
     return FutureBuilder(
      builder:(context, AsyncSnapshot eventSnap) {
        if (eventSnap.connectionState == ConnectionState.none ||
            eventSnap.hasData == false) {
          return Container();
        }
        if (eventSnap.connectionState == ConnectionState.waiting)
          return Center(child:  CircularProgressIndicator(),);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: eventSnap.data.length,
          itemBuilder: (context, index) {
            Event event = eventSnap.data[index];
            return new ListTile(
                leading: _getImageType(event.type),
                title: Text(event.eventName),
                subtitle: Text(DateFormat.yMd().format(event.date)),
                trailing: IconButton(icon: Icon(Icons.delete), onPressed: () =>  _showDialog(context, event), )
            );
          },
        );
      },
      future: null //this.widget._bloc.getEventsForLamb(this.widget._lamb!),
    );
  }

  Future <Bete?> showBouclage(LambModel lamb) async {
    Bete? bete = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BouclagePage(lamb)),
    );
    return bete;
  }

  Future<String> showDeath(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MortPage(lamb)),
    );
    return "Toto";
  }


  void _openPesee(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PeseePage( null, lamb )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  void _openTraitement(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SanitairePage(null, lamb )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  Widget _getImageType(EventType type) {
    switch (type) {
      case EventType.traitement :
        return new Image.asset("assets/syringe.png");
        break;
      case EventType.agnelage :
        return new Image.asset("assets/lamb.png");
        break;
      case EventType.NEC:
        return new Image.asset("assets/etat_corporel.png");
        break;
      case EventType.entreeLot:
        return new Image.asset("assets/Lot_entree.png");
        break;
      case EventType.sortieLot:
        return new Image.asset("assets/Lot_sortie.png");
        break;
      case EventType.pesee:
        return new Image.asset("assets/peseur.png");
        break;
      case EventType.echo:
        return new Image.asset("assets/ultrasound.png");
      case EventType.entree:
      case EventType.sortie:
    }
    return Container();
  }

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(Event event) {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: () {
        if (event.type == EventType.pesee || event.type == EventType.traitement)
          _deleteEvent(event);
        Navigator.of(context).pop();
      },
    );
  }

  Future _showDialog(BuildContext context, Event event) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _continueButton(event),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) async {
    String message = ""; //await this.widget._bloc.deleteEvent(event);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    /*_scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(message)));*/
    setState(() {

    });
  }
}

