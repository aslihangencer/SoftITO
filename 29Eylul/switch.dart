// switch: değişkene atama yapmaz. kullanacğımız zaman içindeki veriyi çekeriz. 
enum OlaySeviyesi{
  info, 
  warning, 
  error, 
  critical
}

String alarmKanaliniBelirle(
  OlaySeviyesi seviye,
  int tekrarSayisi
){
  return switch(seviye){
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekrarSayisi >= 5 => "SMS veya Email (mükerrer hata)",
    OlaySeviyesi.error => "Email: dev@siteadi.com",
    OlaySeviyesi.critical => "ACİL DURUM: Kriz odası otomatik node kapanışı",
  };
}

String httpKoduYorumlar(int kod){
  return switch (kod){
    >= 200 && < 300 => "2xx Başarılı İstek",
    >= 400 && < 500 => "4xx İstenci Hatası (Client error)",
    >= 500 && < 600 => "5xx Sunucu Hatası (Internal Server error)",
    _               => "Tanımsız Hata Kodu",
  };
}

void main(){
  print("Switch Expressions");
  print("Warning Kanalı                     : ${alarmKanaliniBelirle(OlaySeviyesi.warning, 1)}");
  print("Tekil Error Kanalı                 : ${alarmKanaliniBelirle(OlaySeviyesi.error, 2)}");
  print("5 Kez Tekrarlanan Error Kanalı     : ${alarmKanaliniBelirle(OlaySeviyesi.error, 5)}");
  print("Kritik Kanal                       : ${alarmKanaliniBelirle(OlaySeviyesi.critical, 1)}");


  print("HTTP 204:    ${httpKoduYorumlar(204)}");
  print("HTTP 404:    ${httpKoduYorumlar(404)}");
  print("HTTP 502:    ${httpKoduYorumlar(502)}");

}
