// set ve ağ güvenlik kümeleri
void main() {
  print("Beyaz Liste ve Küme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri = {
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10", // set bunu anında tekilleştirir.
  };
  print("İstanbul IPleri: $istanbulVeriMerkeziIpleri");

  final Set<String> frankfurtVeriMerkeziIpleri = {
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45",
  };
  print("Frankurt IPleri: $frankfurtVeriMerkeziIpleri");

  final ortakKopruIpleri =
      istanbulVeriMerkeziIpleri.intersection(frankfurtVeriMerkeziIpleri);
  print("Ortak ağ IPleri (kesişim): $ortakKopruIpleri");

  final tumGlobalIpler =
      istanbulVeriMerkeziIpleri.union(frankfurtVeriMerkeziIpleri);
  print("Toplam global IPler (birleşim): $tumGlobalIpler");


  final sadeceIstanbul=istanbulVeriMerkeziIpleri.difference(frankfurtVeriMerkeziIpleri);
  print("Sadece İstanbul: $sadeceIstanbul");
}