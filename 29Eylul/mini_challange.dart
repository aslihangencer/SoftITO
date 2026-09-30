///Bir bulut kümesinde çalışan servislerin isimlerini içeren bir Set<String> tanımlayın 
///(mükerrer kayıtları elemek için). Ardından bir boolean bool isProduction = true; bayrağı tanımlayın. 
///Eğer ortam prodüksiyon ise listeye "vault-secret-manager" servisini Collection if ile ekleyen ve 
///tüm servisleri içeren bir List<String> oluşturup ekrana yazdırın.
void main() {
  print("Calısan Servisler");

  final Set<String> calisanServisIsimleri = {
    "payment-service",
    "gateway-service",
    "auth-service",
    "monitoring-service",
  };

  final bool isProduction = true;

  final List<String> tumServisler = [
    ...calisanServisIsimleri,
    if (isProduction) "vault-secret-manager",
  ];

  print("Tüm servisler: $tumServisler");
}