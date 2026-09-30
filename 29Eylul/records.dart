// dart record ve api durum kontrolü

({ // Fonksiyonun dönüş tipi: Named Record !!!! POZİSYONEL RECORD
// birden fazla farklı tipteki veriyi tip güvenliği (type-safety) korunarak paketler.
  String nodeAdi,  // sıralama önemli, isimle gelmez, 1 2 olarak gellir aşağıda return'e!!!
  int statusCode, 
  double latencyMs, 
  bool baglantiBasarili
}) sunucuPingAt ({
  required String hedefIp, // PM. fonksiyon çağrılırken parametrenin isminin açıkça belirtilmesi zorunlu
}){
  final double gecikme = 24.8;
  final int kod = 200;

  return(
    // burada sıralama önemli! yukarıdan isimle gelmez! 1 2 diye diye gelir. 
    nodeAdi:"edge-router-ist-$hedefIp",
    statusCode: kod,
    latencyMs: gecikme,
    baglantiBasarili: kod == 200,
  );
}

void main(){
  print("Dart Record Kayıtları");

  final probeSonucu = sunucuPingAt(hedefIp: "10.0.1.50");
  
  print("IP Adı         : ${probeSonucu.nodeAdi}");
  print("HTTP Kodu      : ${probeSonucu.statusCode}");
  print("Gecikme Süresi : ${probeSonucu.latencyMs}");
  print("Ağ Durumu      : ${probeSonucu.baglantiBasarili ? "Stabil" : "Kopuk"}");


  // Tek Hamlede Değişkenlere Parçalama
  final(:nodeAdi, :statusCode, :latencyMs, :baglantiBasarili) = probeSonucu;

  print("Değişkenler -> $nodeAdi [Kod: $statusCode, Gecikme: ${latencyMs} ms]");

  final (String podId, int cpuCores, double ramGb) = ("k8s-pod-77x", 8, 32.0);

  print("Pod Özeti: $podId | Çekirdek: $cpuCores | RAM: ${ramGb}GB");

}







