void main() {
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0",
  ];
  aktifMikroservisler.add("telemery-collector:v1.0");
  print("Aktif servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler");

  // sabit uzunluktaki liste (fixed-length)
  final List<String> cekirdekYukDengeleyiciler =
      List<String>.filled(4, "Port-Kapalı", growable: false);
  cekirdekYukDengeleyiciler[0] = "LB-NODE-02; 192.168.1.11 (Online)";
  // cekirdekYukDengeleyiciler.add("LB-NODE-05"); // HATA: FIXED-LENGTH LİSTEYE ELEMAN EKLENEMEZ.
  print("ÇEKİRDEK YÜK DENGELEYİCİ PORTALARI: $cekirdekYukDengeleyiciler");

  // programatik list üretici
  final List<String> kubernetPodlari = List.generate(
    3,
    (index) => "pod-node-eu-west-${index + 1} [Ram:16GB, CPU:4 Cores]",
  );
  print("Oluşturulan K8s Podları: $kubernetPodlari");
}



//değiştirilemez liste
final List<String> guvenlikDuvariPortlari = List.unmodifiable([
  "22/TCP (SSH)",
  "443/TCP (HTTPS)",
  "6443/TCP (K8s-API)",
]);
//guvenlikDuvariPortları[0]="80-TCP";//hatacontrol
void yazdirGuvenlikDuvariPortlari() {
  print("Güvenlik duvarı korumalı portlar $guvenlikDuvariPortlari");
}


//