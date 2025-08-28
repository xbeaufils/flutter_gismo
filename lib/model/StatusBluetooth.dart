class StatusBlueTooth {
 static String CONNECTED="CONNECTED";

  late String connectionStatus;
  late String dataStatus;
  //\" : \"" +stateBluetooth + "\", "
  String ? data;
  //\" : \"" + stateData + "\"}");
 StatusBlueTooth.none() {
   connectionStatus = "NONE";
   dataStatus = "NONE";
   data = "";
 }

  StatusBlueTooth.fromResult(result) {
    connectionStatus= result["connectionStatus"] ;
    dataStatus= result["dataStatus"] ;
    if (result["data"] != null)
      data = result["data"];
  }

}