import 'dart:io';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:gismo/bloc/GismoBloc.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/infra/presenter/ConfigPresenter.dart';
import 'package:gismo/infra/ui/MenuPage.dart';
import 'package:gismo/services/AuthService.dart';

import 'package:path/path.dart' as path;

enum TestConfig{NOT, DONE}
enum ConfirmAction { CANCEL, ACCEPT }

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => new _ConfigPageState();
}

abstract class ConfigContract extends GismoContract {
  TestConfig get configTeste;
  set configTeste(TestConfig value);
  Future confirmRestore();
}

class _ConfigPageState extends GismoStatePage<ConfigPage> implements ConfigContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late ConfigPresenter _presenter;

  bool _isSubscribed = false;
  TestConfig _configTeste = TestConfig.NOT;

  TestConfig get configTeste => _configTeste;

  set configTeste(TestConfig value) {
    setState(() {
      _configTeste = value;
    });
  }

  final _cheptelCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void switched(value) {
    this.setState(() {
      this._isSubscribed = value;
      if (this._isSubscribed)
        configTeste = TestConfig.NOT;
     });
  }

  Widget _loginPage() {
    return  new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(S.of(context).connected_mode),
              subtitle: Text(S.of(context).connected_mode_text),
            isThreeLine: true,),
            new Card(key: null,
              child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(S.of(context).email,
                    ),
                    new TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: S.of(context).email,
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                    new Text(S.of(context).password),
                    new TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: S.of(context).password,
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                    new ElevatedButton(key:null, onPressed:() => this._presenter.login(_emailCtrl.text, _passwordCtrl.text) ,
                        //color: const Color(0xFFe0e0e0),
                        child:
                        new Text(S.of(context).connection,
                          style: new TextStyle(
                            color: const Color(0xFF000000),),
                        )
                    )
                  ]
              ),
            )
          ]
      );

  }

  Widget _autonomePage() {
    return new Column(children: <Widget>[
      ListTile(
        title: Text(S.of(context).alone_mode),
        subtitle: Text(S.of(context).alone_mode_text),
        isThreeLine: true,
      ),
        FutureBuilder(
            builder: (context,AsyncSnapshot projectSnap) {
              switch (projectSnap.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container();
                default:
                  if (projectSnap.data == null)
                    return Container(child: Text(S.of(context).data_null),);
                  if (projectSnap.data.length == 0 ) {
                    return Container(child: Text(S.of(context).empty_folder),);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: projectSnap.data.length,
                    itemBuilder: (context, index) {
                      FileSystemEntity file = projectSnap.data[index];
                      String filename = path.basename( file.path);
                      return new Column(
                          children: <Widget>[
                            new ListTile(
                              title: Text(filename), 
                              trailing: IconButton(icon: Icon(Icons.delete), onPressed: ()  {
                                setState( () {
                                  this._presenter.deleteBackup(filename); });
                              }  ,),
                              leading: IconButton(icon: Icon(Icons.restore), onPressed: () => this._presenter.restoreBackup(filename)) ,)
                          ]);
                    },
                  );
              }
            },
            future: this._presenter.getFiles(),
        ),
      new ElevatedButton(key:null, onPressed: this._presenter.copyBD,
          //color: const Color(0xFFe0e0e0),
          child:
          new Text(S.of(context).copy_base,
            style: new TextStyle(
              color: const Color(0xFF000000),),
          )
      )

    ],
    );
  }

  Future confirmRestore() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).restore_bd),
          content: Text(S.of(context).restore_bd_text),
          actions: [
            TextButton(
              child: Text(S.of(context).bt_cancel),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            TextButton(
              child: Text(S.of(context).bt_continue),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debug.log("Build" , name: "_ConfigPageState:Build");
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (! _isSubscribed || configTeste == TestConfig.DONE)?
        FloatingActionButton.extended(
            onPressed: () => this._presenter.saveConfig(this._isSubscribed, _emailCtrl.text, _passwordCtrl.text, Navigator.canPop(context)),
            label: Text(S.of(context).save_config),
            icon: Icon(Icons.save),
        ): null ,
        appBar: AppBar(
          title: Text(S.of(context).configuration),
        ),
        body:
          SingleChildScrollView(
            child:
              Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Text(S.of(context).with_subscription)
                      ),
                      Switch(
                        value: _isSubscribed,
                        onChanged: (value) {switched(value);},
                      ),
                    ]),
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        child: _isSubscribed ? _loginPage(): _autonomePage(),
                      ),
                   ])
          ),
        drawer: GismoDrawer(),);
  }

  @override
  void initState() {
    debug.log("initState", name: "_ConfigPageState:initState");
    super.initState();
    this._presenter = ConfigPresenter(this);
    if (AuthService().subscribe) {
      if (AuthService().email != null)
        _emailCtrl.text = AuthService().email!;
        _isSubscribed = true;
    }
    else _isSubscribed = false;
    if (_isSubscribed) {
      configTeste = TestConfig.DONE;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cheptelCtrl.dispose();
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
  }
}

