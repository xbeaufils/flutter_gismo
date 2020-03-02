import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LotPage extends StatefulWidget {
  LotPage({Key key}) : super(key: key);
  @override
  _LotPageState createState() => new _LotPageState();
}

class _LotPageState extends State<LotPage> {
  List<String> data = [];

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[1]);

    return "Success!";
  }


  @override
  void initState(){
    super.initState();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new ListView(
            ),

            new FlatButton(key:null, onPressed:buttonPressed,
                child:
                new Text(
                  "Ajouter",
                  style: new TextStyle(fontSize:12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                )
            )
          ]

      ),

    );
  }
  void buttonPressed(){}

}