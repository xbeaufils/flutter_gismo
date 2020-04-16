
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/config.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';

import 'dart:developer' as debug;

import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class WebDataProvider extends DataProvider {
  static BaseOptions options = new BaseOptions(
    baseUrl: urlTarget,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  final Dio _dio = new Dio(options);

  WebDataProvider(/*this._token*/){
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) => requestInterceptor(options),
      //onResponse: (Response response) => responseInterceptor(response),
      onError: (DioError dioError) => onError(dioError)
    ));
  }

  dynamic requestInterceptor(RequestOptions options)  {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString("token");
    options.headers.addAll({"Token": gismoBloc.user.token});
    return options;
  }

  FutureOr<dynamic> onError(DioError dioError) {
    debug.log("dioError " + dioError.toString(), name: "WebDataProvider::onError");
    return dioError;
  }

  Future<User> auth(User user) async {
    try {
      final response = await _dio.post(urlTarget + '/user/auth', data: user.toMap());
      debug.log("Send authentication", name: "WebDataProvider::auth");
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        user.setCheptel(response.data['result']["cheptel"]);
      }
    } on DioError catch (e) {
      throw ("Erreur de connection à " + urlTarget);
    }
    debug.log("User is $user.cheptel", name: "WebDataProvider::auth");
    return user;
  }

  Future<String> saveLambing(LambingModel lambing ) async {
    try {
      final response = await _dio.post('/lamb/add', data: lambing.toJson());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        return response.data['message'];
      }
    }
    on DioError catch ( e) {
      debug.log("Error " + e.message);
    }
  }

   Future<List<Bete>> getBetes(String cheptel) async {
    final response = await _dio.get(
        '/bete/searchAll?cheptel=' + cheptel);
    List<Bete> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Bete.fromResult(response.data[i]));
    }
    return tempList;
  }

  Future<String> saveBete(Bete bete) async {
    String action;
    if (bete.idBd == null)
      action = "new";
    else
      action = "update";
    try {
      final response = await _dio.post(
          '/bete/' + action,
          data: bete.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    } on TypeError catch( e) {
      throw ("Oulala" + urlTarget);
    }

  }

  Future<User> login(User user) async {
    try {
      final response = await _dio.post(
          '/user/login', data: user.toMap());
      if (response.data['error']) {
        throw (response.data['message']);
      }
      else {
        user.setCheptel (response.data['result']["cheptel"]);
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
    return user;
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    final response = await _dio.get(
        '/lamb/searchAll?idMere=' + idBete.toString());
    List<LambingModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new LambingModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause'] = motif;
    data['dateSortie'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _dio.post(
      '/bete/sortie', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
        throw ("Erreur de connection à " + urlTarget);
      }
    }
  @override
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cheptel'] = cheptel;
    data['cause'] = motif;
    data['dateEntree'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _dio.post(
          '/bete/entree', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  @override
  Future<String> saveTraitement(TraitementModel traitement) async {
    final Map<String, dynamic> data = traitement.toJson();
    try {
      final response = await _dio.post(
          '/traitement/add', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }

  }
  Future<List<TraitementModel>> getTraitements(Bete bete) async {
    final response = await _dio.get(
        '/traitement/get?idBete=' + bete.idBd.toString());
    List<TraitementModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new TraitementModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lamb"] = lamb.toJson();
    data["bete"] = bete.toJson();
    try {
      final response = await _dio.post(
          '/lamb/boucle', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) async {
    final response = await _dio.get(
        '/traitement/search?idBd=' + idBd.toString());
    return new TraitementModel.fromResult(response.data);
  }

  @override
  Future<LambingModel> searchLambing(int idBd) async {
    final response = await _dio.get(
        '/lamb/search?idBd=' + idBd.toString());
    return new LambingModel.fromResult(response.data);
  }

  @override
  Future<void> mort(LambModel lamb, String motif, String date) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idBb"] = lamb.idBd;
    data["dateDeces"] = date;
    data["motifDeces"] = motif;
    try {
      final response = await _dio.post(
          '/lamb/mort', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  @override
  Future<String> saveNec(NoteModel note) async {
    try {
      final response = await _dio.post(
          '/nec/new', data: note.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  @override
  Future<List<NoteModel>> getNec(Bete bete) async {
    final response = await _dio.get(
        '/nec/get?idBete=' + bete.idBd.toString());
    List<NoteModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new NoteModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    final response = await _dio.get(
        '/lot/getAll/' + cheptel);
    List<LotModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new LotModel.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    final response = await _dio.get(
        '/lot/getBeliers/' + idLot.toString());
    List<Affectation> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Affectation.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    final response = await _dio.get(
        '/lot/getBrebis/' + idLot.toString());
    List<Affectation> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Affectation.fromResult(response.data[i]));
    }
    return tempList;
  }

  @override
  Future<Function> remove(Affectation affect) async {
      try {
        final response = await _dio.post(
            '/lot/del', data: affect.toJson());
        if (response.data['error']) {
          throw (response.data['error']);
        }
        else {
          return response.data['message'];
        }
      } on DioError catch ( e) {
        throw ("Erreur de connection à " + urlTarget);
      }
  }

  @override
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lotId"] = lot.idb;
    data["brebisId"] = bete.idBd;
    data["dateEntree"] = dateEntree;
    try {
      final response = await _dio.post(
          '/lot/add', data: data);
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }

  }

  @override
  Future<LotModel> saveLot(LotModel lot) async{
    try {
      final response = await _dio.post(
          '/lot/create', data: lot.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return LotModel.fromResult(response.data['result']);
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      final response = await _dio.get(
          '/lot/bete/' + idBete.toString());
      List<Affectation> tempList = new List();
      for (int i = 0; i < response.data.length; i++) {
        tempList.add(new Affectation.fromResult(response.data[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " + urlTarget);
    }

  }

  @override
  Future<List<Bete>> getBeliers() async {
    try {
      final response = await _dio.get(
          '/bete/getBeliers/');
      List<Bete> tempList = new List();
      for (int i = 0; i < response.data.length; i++) {
        tempList.add(new Bete.fromResult(response.data[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " + urlTarget);
    }

  }

  @override
  Future<List<Bete>> getBrebis() async {
    final response = await _dio.get(
        '/bete/getBrebis/');
    List<Bete> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new Bete.fromResult(response.data[i]));
    }
    return tempList;
  }

  Future<String> getCadastre(LocationData myPosition) async {
    try {
      final response = await _dio.post(
          '/map/cadastre', data: {
            'lattitude': myPosition.latitude,
            'longitude': myPosition.longitude
      });
        String cadastre =  response.data;
        return cadastre;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  Future<String> getParcelle(LatLng touchPosition) async {
    try {
      final response = await _dio.post(
          '/map/parcelle', data: {
        'lattitude': touchPosition.latitude,
        'longitude': touchPosition.longitude
      });
      String cadastre =  response.data;
      return cadastre;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }

  Future<List<Parcelle>> getParcelles() async {
    try {
      final response = await _dio.get(
          '/map/parcelles/');
      List<Parcelle> parcelles = new List();
      for (int i = 0; i < response.data.length; i++) {
        parcelles.add(Parcelle.fromResult(response.data[i]));
      }
      return parcelles;
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }
  Future<Pature> getPature(String idu) async {
    try {
      final response = await _dio.get(
          '/paturage/' + idu);
      List<Parcelle> parcelles = new List();
      if( response.data.length>0) {
        Pature pature = Pature.fromResult(response.data);
        return pature;
      }
      throw ("Pature non trouvée");
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }
  }
  Future<String> savePature(Pature pature) async {
    try {
      final response = await _dio.post(
          '/paturage/save', data: pature.toJson());
      if (response.data['error']) {
        throw (response.data['error']);
      }
      else {
        return response.data['message'];
      }
    } on DioError catch ( e) {
      throw ("Erreur de connection à " + urlTarget);
    }

  }
}