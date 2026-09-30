void main() {
  print("Map metrikleri");

  final Map<String, Map<String, dynamic>> mikroservisRehberi = {
    "auth-api": {
      "port": 8081,
      "saglik": "healthy",
      "restartSayisi": 0,
      "bellekKullanimiMb": 384.5,
      "otonomOlceklenme": true,
    },
    "payment-gateway": {
      "port": 8082,
      "saglik":"Degraded",
      "restartSayisi":4,
      "bellekKulalnimiMb":1280.0,
      "otonomOlceklenme":false,
    },
  };

  mikroservisRehberi.putIfAbsent("reporting-worker", ()=>{
    "port":9091,
    "saglik":"Healthy",
    "restartSayisi":1,
    "bellekKulalnimiMb":512.0,
    "otonomOlceklenme":true,
  },
  );




  //Metrik güncelleme
  if(mikroservisRehberi.containsKey("payment-gateway")){
    mikroservisRehberi["payment-gateway"]!["restartSayisi"] =
      (mikroservisRehberi["payment-gateway"]!["restartSayisi"] as int) + 1;

  }


  print("Güncel servis raporu:");
  print("----------------------------");
  for(var entry in mikroservisRehberi.entries){
    final String servis = entry.key;
    final Map<String,dynamic> ozet =entry.value;
    final String durumRozet = ozet["saglik"] == "Healthy" ? "OK" : "Alert";
    print("$durumRozet ${servis.padRight(18)} /Port : ${ozet ['port']} / Ram: ${ozet['bellekKullanimiMb']}Mb / Restart. $ozet{ozet['restartSayisi]}",
    );
  }
}

