class DeviceModel {
  late String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  late String _address;
  late String _id;

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  DeviceModel.fromResult(result) {
    _id= result["idBd"] ;
    _address = result["address"];
    _name = result["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = _id ;
    data["address"] = _address;
    data["name"] = _name;
    return data;
  }
}