// Enumlar, değişkenlerin alabileceği seçenekleri belirlemek için kullanılır.
// Böylece farklı veya yanlış değer girme ihtimali azalır.
enum HizmetKategorisi {
  ciltYenileme, // Cilt yenileme işlemleri
  medikalEstetik, // Medikal estetik işlemleri
  lazerEpilasyon, // Lazer epilasyon işlemleri
  Lipo, // Lipo işlemleri
}

enum SeansDurumu {
  bekliyor, // Randevu oluşturuldu, işlem başlamadı
  odadaIslemde, // Danışan şu anda işlem görüyor
  tamamlandi, // İşlem tamamlandı ve ödeme alındı
  iptalEdildi, // Randevu iptal edildi
}

enum OdemeYontemi {
  krediarti, // Kredi kartı ile ödeme
  havaleEft, // Havale veya EFT ile ödeme
  nakit, // Nakit ödeme
  klinikPaketKredisi, // Klinik paketi ile ödeme
}

// Danışan bilgilerini tutmak için sınıf oluşturduk.
class Danisan {
  // Her danışana ait benzersiz ID.
  final String id;

  // Danışanın adı ve soyadı.
  final String adSoyad;

  // Danışanın telefon numarası.
  final String telefon;

  // Danışanın VIP olup olmadığını tutar.
  final bool vipUyeMi;

  // Danışanın alerjilerini liste halinde tutar.
  // Liste boş olabilir ama null olmaz.
  final List<String> alerjiler;

  // Danışanın özel cilt notunu tutar.
  // ? olduğu için boş bırakılabilir.
  final String? ozelCiltNotu;

  // Nesne oluştururken çalışan constructor.
  // required olan alanların girilmesi gerekir.
  const Danisan({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    this.vipUyeMi = false, // Girilmezse VIP değildir.
    this.alerjiler = const [], // Girilmezse liste boş olur.
    this.ozelCiltNotu, // Girilmezse null olur.
  });

  // Alerji varsa danışanı hassas ciltli kabul ediyor.
  // Liste boş değilse true döner.
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  // Danışanın bilgilerini kısa şekilde göstermek için getter kullandık.
  String get bilgiOzeti {
    // Önce alerji bilgisini kontrol ediyor.
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı alerji yok" // Alerji yoksa bu yazı gelir.
        : "Alerjiler: ${alerjiler.join(", ")}";
        // Alerji varsa virgülle ayırarak gösterilir.

    // Özel not yoksa varsayılan mesaj gösterir.
    final String notBilgisi =
        ozelCiltNotu ?? "Özel medikal not girilmemiş";

    // VIP durumuna göre yazıyı belirlenir.
    final String vipRozeti = vipUyeMi ? "VIP" : "Standart";

    // Tüm bilgileri tek satırda döndürür.
    return "$vipRozeti $adSoyad ($telefon) | "
        "$alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans bilgilerini tutmak için sınıf oluşturduk.
class SeansKaydi {
  // Seansa ait benzersiz kod.
  final String seansKodu;

  // Seansın ait olduğu danışan.
  final Danisan danisan;

  // Seansın hizmet kategorisi.
  final HizmetKategorisi kategori;

  // Yapılacak işlemin adı.
  final String islemAdi;

  // İşlemin birim fiyatı.
  final double birimFiyat;

  // İşlemin kaç seans yapılacağını tutar.
  final int seansSayisi;

  // İndirim oranını yüzde olarak tutar.
  final double indirimOrani;

  // İşlemden sorumlu uzman.
  // Uzman henüz belli değilse null olabilir.
  final String? sorumluUzman;

  // Seansın mevcut durumunu tutar.
  SeansDurumu durum;

  // Ödeme yöntemi başta belli olmayabilir.
  OdemeYontemi? odemeTipi;

  // Seans oluştururken çalışan constructor.
  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1, // Yazılmazsa 1 seans kabul edilir.
    this.indirimOrani = 0.0, // Yazılmazsa indirim uygulanmaz.
    this.sorumluUzman, // Uzman girmek zorunlu değil.
    this.durum = SeansDurumu.bekliyor,
    // Yeni seansın başlangıç durumu bekliyor.
    this.odemeTipi, // Ödeme yöntemi başta boş olabilir.
  });

  // Toplam brüt tutarı hesapla.
  double get brutTutar => birimFiyat * seansSayisi;

  // Toplam indirim tutarını hesapla.
  double get indirimTutari {
    // Önce verilen indirim oranını al.
    double toplamOran = indirimOrani;

    // VIP danışansa ekstra %10 indirim ekle.
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }

    // İndirim tutarını hesapla.
    return brutTutar * (toplamOran / 100.0);
  }

  // İndirim çıktıktan sonra kalan tutarı hesapla.
  double get netTutar => brutTutar - indirimTutari;
}

// Klinik işlemlerini yöneten sınıf.
class KlinikYoneticisi {
  // Şubenin adını tutar.
  final String subeAdi;

  // Tüm seansları bu listede tutuyoruz.
  // _ işareti değişkenin private olduğunu gösterir.
  final List<SeansKaydi> _seanslar = [];

  // Danışanları ID'lerine göre burada tutuyoruz.
  final Map<String, Danisan> _danisanRehberi = {};

  // Klinik yöneticisi oluştururken şube adı girilmelidir.
  KlinikYoneticisi({required this.subeAdi});

  // Yeni danışanı sisteme kaydetmek için kullandığımız metot.
  void danisanKaydet(Danisan danisan) {
    // Danışanın ID'sini kullanarak rehbere ekle.
    _danisanRehberi[danisan.id] = danisan;

    // Kayıt yapıldığını ekrana yazdır.
    print(
      "Rehbere eklendi: ${danisan.adSoyad} "
      "(${danisan.vipUyeMi ? 'VIP' : 'Standart'})",
    );
  }

  // Yeni randevu veya seans oluşturmak için kullandığımız metot.
  void randevuOlustur(SeansKaydi seans) {
    // Seansı listeye ekliyorum.
    _seanslar.add(seans);

    // Kaydedilen randevunun bilgisini yazdırır.
    print(
      "Randevu kaydedildi: [${seans.seansKodu}] : "
      "${seans.danisan.adSoyad} --> ${seans.islemAdi}",
    );
  }

  // Seansı tamamlamak ve ödeme bilgisini eklemek için kullanıyoruz.
  void seansTamamla({
    required String seansKodu,
    required OdemeYontemi odeme,
  }) {
    // Listedeki seansları tek tek kontrol et.
    for (var seans in _seanslar) {
      // Seans kodu eşleşiyorsa doğru seansı bul.
      if (seans.seansKodu == seansKodu) {
        // Seansın durumunu tamamlandı yap.
        seans.durum = SeansDurumu.tamamlandi;

        // Ödeme yöntemini kaydet.
        seans.odemeTipi = odeme;

        // Tahsil edilen tutarı ekrana yazdırır.
        print(
          "Seans tamamlandı: [${seans.seansKodu}]: "
          "${seans.netTutar.toStringAsFixed(2)} TL tahsil edildi "
          "(${odeme.name})",
        );

        // Seans bulunduğu için metottan çıkıyoruz.
        return;
      }
    }

    // Seans bulunamazsa hata mesajı gösterilir.
    print("Hata: [$seansKodu] kodlu seans bulunamadı.");
  }

  // Bir seansı iptal etmek için kullandığımız metot.
  void seansiIptalEt(
    String seansKodu, {
    String? iptalNedeni,
  }) {
    // Listedeki seansları kontrol et.
    for (var seans in _seanslar) {
      // Kodlar aynıysa doğru seansı bul.
      if (seans.seansKodu == seansKodu) {
        // Seansın durumunu iptal edildi yap.
        seans.durum = SeansDurumu.iptalEdildi;

        // İptal nedenini ekrana yazdırılır.
        print(
          "Seans iptal edildi [${seans.seansKodu}]: "
          "${iptalNedeni ?? "Gerekçe belirtilmedi"}",
        );

        // Seansı bulduğumuz için metottan çıkılır.
        return;
      }
    }

    // Seans bulunamazsa hata mesajı gösteririz.
    print("Hata: [$seansKodu] kodlu seans bulunamadı.");
  }

  // Tamamlanan seansların toplam net cirosunu hesapla.
  double get toplamTahsilEdilenCiro => _seanslar
      // Sadece tamamlanan seansları al.
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      // Net tutarları topla.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Henüz tamamlanmayan seansların tahmini gelirini hesapla.
  double get beklenenPotansiyelCiro => _seanslar
      // Bekleyen veya işlemde olan seansları al.
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      // Bu seansların net tutarlarını topla.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Kategorilere göre kaç seans olduğunu hesapla.
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    // Sonuçları tutmak için boş bir map oluşturuyoruz.
    final Map<HizmetKategorisi, int> dagilim = {};

    // Tüm hizmet kategorilerini gezmek için kullanırız.
    for (var kat in HizmetKategorisi.values) {
      // Her kategoriye başlangıçta 0 veriyoruz.
      dagilim[kat] = 0;
    }

    // Tüm seansları kontrol et.
    for (var s in _seanslar) {
      // İlgili kategorinin sayısını 1 artır.
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }

    // Hazırladığımız dağılımı geri döndür.
    return dagilim;
  }

  // Seanslarda görev yapan uzmanların listesini döndürüyoruz.
  Set<String> gorevliUzmanKadrosu() {
    return _seanslar
        // Seanslardaki uzmanları al.
        .map((s) => s.sorumluUzman)
        // Uzmanı olmayanları çıkarır.
        .whereType<String>()
        // Aynı uzmanı tekrar göstermez.
        .toSet();
  }

  // Henüz uzman atanmamış seansları getirir.
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar
        // Uzmanı null olan seansları bul.
        .where((s) => s.sorumluUzman == null)
        // Sonucu listeye çevirir.
        .toList();
  }

  // Gün sonunda klinik raporunu ekrana yazdırdık.
  void gunSonuRaporuYazdir() {
    // Rapor başlığını yazdırdık.
    print("Günlük seans ve işlem çizelgesi");

    // Tabloyu ayırmak için çizgi yazdırıyoruz.
    print("---------------------------------");

    // Tablo başlıklarını yazdırıyoruz.
    print(
      "${'Kod'.padRight(10)} |"
      "${'Danışan'.padRight(16)} |"
      "${'İşlem'.padRight(20)} |"
      "${'Uzman'.padRight(18)} |"
      "${'Tutar'.padRight(10)} |"
      "${'Durum'} |",
    );

    // Başlıkların altına çizgi çekiyoruz.
    print("----------------------------------");

    // Tüm seansları tek tek yazdırıyoruz.
    for (var s in _seanslar) {
      // Uzman yoksa varsayılan bir yazı gösterilir.
      final String uzman = s.sorumluUzman ?? "Nöbetçi bekliyor";

      // Seans durumuna göre ekranda gösterilecek yazıyı belirledik.
      final String durumRozet = switch (s.durum) {
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      // Seans bilgilerini tablo şeklinde yazdırıyoruz.
      print(
        "${s.seansKodu.padRight(10)} |"
        "${s.danisan.adSoyad.padRight(16)} |"
        "${s.islemAdi.padRight(20)} |"
        "${uzman.padRight(18)} |"
        "${s.netTutar.toStringAsFixed(2).padRight(10)} |"
        "$durumRozet",
      );
    }

    // Tablo bittikten sonra çizgi yazdırıyoruz.
    print("-----------------------------------------------------");

    // Finansal özet bölümünü başlat.
    print("Finansal özet:");

    // Tamamlanan seanslardan gelen net ciroyu yazdır.
    print(
      "* Gerçekleşen net ciro: "
      "${toplamTahsilEdilenCiro.toStringAsFixed(2)} TL",
    );

    // Beklenen potansiyel geliri yazdır.
    print(
      "* Bekleyen potansiyel alacak: "
      "${beklenenPotansiyelCiro.toStringAsFixed(2)} TL",
    );

    // Toplam seans sayısını yazdır.
    print("* Toplam seans: ${_seanslar.length} randevu");

    // Yeni bölümü ayırıyoruz.
    print("-----------------------------------------------------");

    // Aktif uzmanları göster.
    print("Aktif uzmanlar:");

    // Uzman listesini al.
    final uzmanlar = gorevliUzmanKadrosu();

    // Uzman yoksa bilgi ver.
    if (uzmanlar.isEmpty) {
      print("Kayıtlı uzman bulunamadı.");
    } else {
      // Uzmanları virgülle ayırarak yazdır.
      print(uzmanlar.join(", "));
    }

    // Uzmanı olmayan seansları bul.
    final uzmansizlar = uzmansizSeanslariGetir();

    // Uzmanı olmayan seans varsa uyarı ver.
    if (uzmansizlar.isNotEmpty) {
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır.",
      );
    }

    // Uzmanı olmayan seansları tek tek yazdır.
    for (var u in uzmansizlar) {
      print("-> [${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
    }

    // Raporun sonuna çizgi ekliyoruz.
    print("-----------------------------------------------------");
  }
}

// Programın başladığı ana fonksiyon.
void main() {
  // Programın başladığını ekrana yazdırır.
  print("Klinik yönetim sistemi başlatılıyor...");

  // Klinik yöneticisi oluşturduk.
  final yonetici = KlinikYoneticisi(
    subeAdi: "Softito - Bağcılar Şubesi",
  );

  // Birinci danışanı oluşturduk.
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol", "Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  // İkinci danışanı oluşturduk.
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    alerjiler: [],
  );

  // Üçüncü danışanı oluşturduk.
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol", "Aspirin"],
  );

  // Dördüncü danışanı oluşturduk.
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  // Danışanları sisteme kaydet.
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  // Danışan bilgilerini kontrol etmek için başlık yazdırdık.
  print("Danışan güvenlik kontrolü");

  // Birinci danışanın bilgilerini yazdırdık.
  print(d1.bilgiOzeti);

  // İkinci danışanın bilgilerini yazdırdık.
  print(d2.bilgiOzeti);

  // Bölümleri ayırıyoruz.
  print("---------------------------");

  // Birinci seansı oluşturduk.
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0,
    sorumluUzman: "Sümeyye",
  );

  // İkinci seansı oluşturduk.
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile yüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
  );

  // Üçüncü seansı oluşturduk.
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm vücut lazer epilasyon",
    birimFiyat: 25500.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba",
  );

  // Dördüncü seansı oluşturduk.
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin",
  );

  // Oluşturduğum seansları sisteme kaydet.
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);

  // Seansların sisteme gönderildiğini belirt
  print("Seanslar gönderiliyor...");

  // Birinci seansı kredi kartı ile tamamlandı.
  // İkinci seansı nakit ödeme ile tamamlandı.
  // Son olarak bir seansı iptal et.
  yonetici.seansTamamla(seansKodu: "SNS-2026-1", odeme: OdemeYontemi.krediarti);
  yonetici.seansTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  yonetici.seansiIptalEt("SNS-2026-04",iptalNedeni: "danışanın müsaitliği yokmuş");

  // Gün sonu raporunu ekrana yazdır.
  yonetici.gunSonuRaporuYazdir();
}

