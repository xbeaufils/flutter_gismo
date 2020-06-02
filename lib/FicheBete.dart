
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/lamb/Bouclage.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:intl/intl.dart';


class FicheBetePage extends StatefulWidget {
  final Bete _bete;
  FicheBetePage(this._bete, {Key key}) : super(key: key);
  @override
  _FicheBetePageState createState() => new _FicheBetePageState(_bete);
}

class _FicheBetePageState extends State<FicheBetePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _formKeyIdentity = GlobalKey<FormState>();
  Bete _bete;
  String _numBoucle ;
  String _numMarquage;
  String _nom;
  String _dateEntree;
  Sex _sex;
  String _motif;

  int _indexExpandedTraitement = -1;

  _FicheBetePageState(this._bete);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Individu'),
        bottom:  new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(
            child: Container(
              child:
                new Image.asset("assets/brebis2.png"),
            )
        ),
            new Tab(
                //icon: new Image.asset("assets/lamb.png") ,
                child: Container(
                  child:
                  new Image.asset("assets/lamb.png"),
                //text: "Agnelage" ,
              ),),
            new Tab(
              child: Container(
                child:
             //     icon: new Image.asset("assets/syringe_full.png") ,
                    new Image.asset("assets/syringe.png") ,),
              //text: "Traitement" ,
            )],
          )
        ),
      body:
      new TabBarView(
          controller: _tabController,
          children: <Widget>[
            _getIdentity(),
            _getLambs(),
            _getTraitement()
          ]

      ),

    );
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget _getIdentity() {
    final df = new DateFormat('dd/MM/yyyy');

    _numBoucle = this._bete.numBoucle;
    _numMarquage = this._bete.numMarquage;
    _dateEntree = this._bete.dateEntree;
    _nom = this._bete.nom;
    _sex = this._bete.sex;
    _motif = this._bete.motifEntree;

    return Container(
        child: new Form(
          key: _formKeyIdentity,
          child:
          new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new TextFormField(
                  initialValue: _numBoucle,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Numero boucle', hintText: 'Boucle'),
                  validator: (value) {
                      if (value.isEmpty) {
                        return 'Entrez le numero de boucle';
                      }
                      return "";
                      },
                    onSaved: (value) {
                      setState(() {
                        _numBoucle = value;
                      });
                    }
                ),
                new TextFormField(
                  initialValue: _numMarquage,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Numero marquage', hintText: 'Marquage'),
                  validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return "";
                    },
                    onSaved: (value) {
                      setState(() {
                        _numMarquage = value;
                      });
                    }
                ),
                new TextFormField(
                  //keyboardType: TextInputType.number,
                    initialValue: _nom,
                    decoration: InputDecoration(labelText: 'Petit nom', hintText: 'Nom'),
                    onSaved: (value) {
                      setState(() {
                        _nom = value;
                      });
                    }
                ),

                new Row(
                    children: <Widget>[
                      new Flexible (child:
                      RadioListTile<Sex>(
                        title: const Text('Male'),
                        value: Sex.male,
                        groupValue: _sex,
                        onChanged: (Sex value) { setState(() { _sex = value; }); },
                      ),
                      ),
                      new Flexible( child:
                      RadioListTile<Sex>(
                        title: const Text('Femelle'),
                        value: Sex.femelle,
                        groupValue: _sex,
                        onChanged: (Sex value) { setState(() { _sex = value; }); },
                      ),
                      ),]
                ),

                new TextFormField(
                    keyboardType: TextInputType.datetime,
                    initialValue: _dateEntree,
                    decoration: InputDecoration(
                        labelText: 'Date entrée',
                        hintText: 'Date'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return "";
                    },
                    onSaved: (value) {
                      setState(() {
                        _dateEntree = value;
                      });
                    },
                    onTap: () async{
                      DateTime date = DateTime.now();
                      FocusScope.of(context).requestFocus(new FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        setState(() {
                          _dateEntree = df.format(date);
                        });
                      }
                    }
                ),
                 new RaisedButton(
                  child: new Text(
                    'Enregistrer',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: _saveIdentity,
                  color: Colors.lightGreen[900],

                ),
              ]
          ),
        ));
  }

  Widget _getTraitement() {
    int indexPanel= -1;
    return FutureBuilder(
        builder: (context, lstTraitements) {
          if (lstTraitements.data == null)
            return Container();
          return SingleChildScrollView(child:
              ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _indexExpandedTraitement = index;
                });
              },
              children: _createExpansionList(lstTraitements.data, _indexExpandedTraitement)
         ));
        },
        future: gismoBloc.getTraitements(_bete),
      );
  }

  List<ExpansionPanel> _createExpansionList (List<TraitementModel> lstTraitements, int expandedIndex ) {
    //lstTraitements.asMap().map((i, element) => )
    List<ExpansionPanel> lstPanel = new List();
    for (var i = 0; i < lstTraitements.length; i++) {
          lstPanel.add(
              new ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(lstTraitements[i].medicament),
                  subtitle: Row( children: <Widget>[
                    Text(lstTraitements[i].debut),
                    Text(lstTraitements[i].fin)
                  ])
                );
              },
              body: Column(
                  children: <Widget>[
                     new Card(
                        child: new Column(
                          children: <Widget>[
                            (lstTraitements[i].ordonnance != null)? Text(lstTraitements[i].ordonnance): Container(),
                            new Row(children: <Widget>[
                              (lstTraitements[i].voie != null)? Text(lstTraitements[i].voie): Container(),
                              (lstTraitements[i].dose != null)? Text(lstTraitements[i].dose): Container(),
                              (lstTraitements[i].rythme != null)? Text(lstTraitements[i].rythme): Container()
                            ],),
                            (lstTraitements[i].intervenant != null)? Text(lstTraitements[i].intervenant): Container()
                          ],
                        )),
                    new Card(child:
                    new Column(
                      children: <Widget>[
                        (lstTraitements[i].motif != null)? Text(lstTraitements[i].motif): Container(),
                        (lstTraitements[i].observation != null)? Text(lstTraitements[i].observation): Container()
                      ],
                    ),)
                  ]
                //isExpanded: item.isExpanded,
              ),
              isExpanded: expandedIndex == i
          ));
        }
    return lstPanel;
  }

  Widget _getLambs() {
    return FutureBuilder(
      builder: (context, lstLambings){
        if (lstLambings.data == null)
          return Container();
        return ListView.builder(
            itemCount: lstLambings.data.length,
            itemBuilder: (context, index) {
              LambingModel lambing = lstLambings.data[index];
              return new Card(
                child: Column(
                  children: <Widget>[
                    //Text(lamb.dateAgnelage),
                    Text("Date : " + lambing.dateAgnelage),
                    Text("Qualite agnelage : " +  Agnelage.getAgnelage(lambing.qualite).value ),
                    Text("Adoption : " + Adoption.getAdoption(lambing.adoption).value),
                    Divider(),
                    _returnLambs(lambing.lambs, lambing.dateAgnelage),

                ],
                ));
            },
          );
      },
      future: gismoBloc.getLambs(_bete.idBd),
    );
    //gismoBloc.getLambs(_bete.idBd).then( (lstLambs) => {_returnLambs});
  }

  Widget _returnLambs( List<LambModel> lstLambs, String dateAgnelage) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lstLambs == null ? 0 : lstLambs.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile (
         leading: Image.asset('assets/lamb.png'),
         title: Text(lstLambs[index].sex.toString()),
         subtitle: Text(lstLambs[index].marquageProvisoire),
         trailing: _getBouclage(lstLambs[index], dateAgnelage),
        );
      },
    );

  }

  Widget _getBouclage(LambModel lamb, String dateAgnelage) {
    if (lamb.numBoucle == null)
      return IconButton(icon:Image.asset('assets/bouclage.png') , onPressed: () => _bouclage(lamb, dateAgnelage));
    else
      return Container(child:
        Column(children: <Widget>[
          Text(lamb.numBoucle),
          Text(lamb.numMarquage)
        ],),);
  }

  void _bouclage(LambModel lamb, String dateAgnelage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BouclagePage(lamb, dateAgnelage),
      ),
    );

  }

  void _saveIdentity() {
    _formKeyIdentity.currentState.save();
    if (_numBoucle == null)
    this._bete.numBoucle = _numBoucle;
    this._bete.numMarquage = _numMarquage ;
    this._bete.nom = _nom;
    this._bete.dateEntree = _dateEntree ;
    this._bete.sex = _sex ;
    this._bete.motifEntree = _motif;
    gismoBloc.saveBete(_bete);
  }


}

