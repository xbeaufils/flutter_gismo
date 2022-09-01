import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';

class GismoDrawer extends StatelessWidget {
  GismoBloc _bloc;

  GismoDrawer(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          this._userstatus(),
          Column(
            children: [
              ListTile(
                title: Text("Accueil"),
                leading: Icon(Icons.home),
                onTap:() { _homePressed(context);},
              ),
              ListTile(
                title: Text("Notes"),
                leading: Icon(Icons.note),
                onTap: () { _notePressed(context);},
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              ListTile(
                title: Text("Configuration"),
                leading: Icon(Icons.settings),
                onTap:  () { _settingPressed(context);},
              ),
              ListTile(
                title: Text("Bluetooth"),
                leading: Icon(Icons.edit),
                onTap: () { _choixBt(context);},
              ),
          ]),
    ]));
  }

  void _choixBt(BuildContext context) {
    Navigator.pushNamed(context, '/bluetooth');
  }

  void _settingPressed(BuildContext context) {
    Navigator.pushNamed(context, '/config') ;
    /*
    message.then((message) {
      showMessage(message);
      setState(() {

      });
    }).catchError((message) {
      showMessage(message);
    });*/
  }

  void _homePressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/welcome') ;
  }

  void _notePressed( BuildContext context) {
    Navigator.pushReplacementNamed(context, '/note') ;
  }
  Widget _userstatus() {
    Icon iconConnexion = Icon(Icons.person);
    Text userName = new Text("utilisateur local");
    Text cheptel = new Text("000000");
    if (_bloc.user == null) {
      iconConnexion = Icon(Icons.error_outline);
      userName = new Text("Erreur utilisateur");
    } else
    if (_bloc.user!.subscribe == null) {
      iconConnexion = Icon(Icons.error_outline);
      userName = new Text("Erreur utilisateur");
    } else {

      if (_bloc.user!.subscribe!) {
        iconConnexion = Icon(Icons.verified_user);
        userName = new Text(_bloc.user!.email!);
        cheptel = new Text(_bloc.user!.cheptel!);
      }
    }
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.lightGreen,
      ),
      child: ListTile(
        title: userName,
        subtitle: cheptel,
        leading: CircleAvatar(
          child: iconConnexion,
          backgroundColor: Colors.white,
        ),
      ),
    );

  }
}
