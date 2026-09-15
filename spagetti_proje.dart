abstract class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;

  Urun(this.id, this.ad, this.fiyat, this.stok);
}

// Sadece kargolanabilen ürünler bu sınıftan türetilir.
abstract class KargolanabilirUrun extends Urun {
  KargolanabilirUrun(
    String id,
    String ad,
    double fiyat,
    int stok,
  ) : super(id, ad, fiyat, stok);

  double kargoUcretiHesapla();
}

class FizikselUrun extends KargolanabilirUrun {
  FizikselUrun(
    String id,
    String ad,
    double fiyat,
    int stok,
  ) : super(id, ad, fiyat, stok);

  @override
  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(
    String id,
    String ad,
    double fiyat,
    int stok,
  ) : super(id, ad, fiyat, stok);
}

// OCP: Ödeme yöntemleri abstraction üzerinden tanımlanıyor.
abstract class OdemeYontemi {
  void odemeYap(double tutar);
}

class KrediKartiOdeme implements OdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kredi kartindan POS ile cekildi.");
  }
}

class HavaleOdeme implements OdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
  }
}

class KapidaOdeme implements OdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kapida odeme tahsil edilecek.");
  }
}

class CryptoOdeme implements OdemeYontemi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL USDT transferi onaylandi.");
  }
}

// ISP: Her servis yalnızca kendi sorumluluğunu tanımlar.
// Veritabani için ayrı abstraction.
abstract class Veritabani {
  void kaydet(String orderId, double tutar);
}

class SqliteVeritabani implements Veritabani {
  @override
  void kaydet(String orderId, double tutar) {
    print(
      "DB calistirildi: "
      "INSERT INTO siparisler VALUES ('$orderId', $tutar)",
    );
  }
}

// ISP: Mail işlemleri ayrı abstraction.
abstract class MailServisi {
  void mailGonder(String email, String mesaj);
}

class SmtpMailServisi implements MailServisi {
  @override
  void mailGonder(String email, String mesaj) {
    print("SMTP Mail gonderildi: $email");
  }
}

// ISP: SMS işlemleri ayrı abstraction.
abstract class SmsServisi {
  void smsGonder(String tel, String mesaj);
}

class NetgsmSmsServisi implements SmsServisi {
  @override
  void smsGonder(String tel, String mesaj) {
    print("SMS iletildi: $tel");
  }
}

// ISP: Kargo işlemleri ayrı abstraction.
abstract class KargoServisi {
  void kargoGonder(String orderId, String adres);
}

class MngKargoServisi implements KargoServisi {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }
}

// ISP: Fatura işlemleri ayrı abstraction.
abstract class FaturaServisi {
  void faturaYazdir(String orderId);
}

class PdfFaturaServisi implements FaturaServisi {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }
}

// İndirim işlemleri için abstraction.
abstract class IndirimStratejisi {
  double uygula(double toplam);
}

class Indirim10 implements IndirimStratejisi {
  @override
  double uygula(double toplam) {
    return toplam * 0.90;
  }
}

class Yaz20Indirimi implements IndirimStratejisi {
  @override
  double uygula(double toplam) {
    return toplam * 0.80;
  }
}

class Sepette50Indirimi implements IndirimStratejisi {
  @override
  double uygula(double toplam) {
    return toplam - 50;
  }
}

class IndirimsizIndirim implements IndirimStratejisi {
  @override
  double uygula(double toplam) {
    return toplam;
  }
}

class SiparisYoneticisi {
 final Veritabani veritabani;
  final OdemeYontemi odemeYontemi;
  final MailServisi mailServisi;
  final SmsServisi smsServisi;
  final KargoServisi kargoServisi;
  final FaturaServisi faturaServisi;
  IndirimStratejisi indirimStratejisi;

  // DIP: Bağımlılıklar dışarıdan veriliyor.
  SiparisYoneticisi(
    this.veritabani,
    this.odemeYontemi,
    this.mailServisi,
    this.smsServisi,
    this.kargoServisi,
    this.faturaServisi,
    this.indirimStratejisi,
  );

  void siparisTamamla(
    String orderId,
    List<Urun> sepet,
    String musteriAdi,
    String email,
    String tel,
    String adres,
  ) {
    stokKontrolEt(sepet);

    double toplam = toplamHesapla(sepet);

    toplam = indirimStratejisi.uygula(toplam);

    double sonTutar = kdvHesapla(toplam);

    odemeYontemi.odemeYap(sonTutar);

    veritabani.kaydet(orderId, sonTutar);

    faturaServisi.faturaYazdir(orderId);

    bildirimGonder(
      musteriAdi,
      email,
      tel,
      orderId,
      sonTutar,
    );

    kargoGonder(orderId, adres, sepet);

    stoklariAzalt(sepet);
  }

  // SRP: Stok kontrolü ayrı bir metoda ayrıldı.
  void stokKontrolEt(List<Urun> sepet) {
    for (Urun urun in sepet) {
      if (urun.stok <= 0) {
        throw StateError("${urun.ad} tukenmis!");
      }
    }
  }

  // SRP: Toplam hesaplama ayrı bir metoda ayrıldı.
  double toplamHesapla(List<Urun> sepet) {
    double toplam = 0;

    for (Urun urun in sepet) {
      toplam += urun.fiyat;

      if (urun is KargolanabilirUrun) {
        toplam += urun.kargoUcretiHesapla();
      }
    }

    return toplam;
  }

  // SRP: KDV hesaplama ayrı bir metoda ayrıldı.
  double kdvHesapla(double toplam) {
    double kdv = toplam * 0.20;
    return toplam + kdv;
  }

  // SRP: Bildirim işlemleri ayrı metoda ayrıldı.
  void bildirimGonder(
    String musteriAdi,
    String email,
    String tel,
    String orderId,
    double sonTutar,
  ) {
    mailServisi.mailGonder(
      email,
      "Sayin $musteriAdi, siparisiniz alindi. "
      "Tutar: $sonTutar TL",
    );

    smsServisi.smsGonder(
      tel,
      "Siparisiniz onaylandi: $orderId",
    );
  }

  // Sadece fiziksel ürün varsa kargo gönderilir.
  void kargoGonder(
    String orderId,
    String adres,
    List<Urun> sepet,
  ) {
    bool fizikselUrunVar = false;

    for (Urun urun in sepet) {
      if (urun is KargolanabilirUrun) {
        fizikselUrunVar = true;
        break;
      }
    }

    if (fizikselUrunVar) {
      kargoServisi.kargoGonder(orderId, adres);
    }
  }

  // SRP: Stok azaltma ayrı metoda ayrıldı.
  void stoklariAzalt(List<Urun> sepet) {
    for (Urun urun in sepet) {
      urun.stok--;
    }
  }
}

void main() {
  // Kullanılacak ödeme yöntemi seçiliyor.
  OdemeYontemi odeme = KrediKartiOdeme();

  // Bağımlılıklar SiparisYoneticisi'ne dışarıdan veriliyor.
  SiparisYoneticisi siparisci = SiparisYoneticisi(
    SqliteVeritabani(),
    odeme,
    SmtpMailServisi(),
    NetgsmSmsServisi(),
    MngKargoServisi(),
    PdfFaturaServisi(),
    Indirim10(),
  );

  FizikselUrun urun1 = FizikselUrun(
    "1",
    "Kablosuz Mouse",
    450.0,
    5,
  );

  DijitalUrun urun2 = DijitalUrun(
    "2",
    "Flutter Kursu E-Kitap",
    150.0,
    100,
  );

  List<Urun> sepet = [
    urun1,
    urun2,
  ];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
  );
}