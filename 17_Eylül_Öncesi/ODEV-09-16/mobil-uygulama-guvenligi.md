## a) Ekran Görüntüsü ve Ekran Kaydı
Bankacılık uygulamalarında, kripto işlemlerinde kredi kartı bilgileri ve bakiye gibi hassas bilgiler bulunur. Ekran görüntüsü veya ekran kaydı alınabilirse bu bilgiler başka kişiler tarafından görülebilir veya paylaşılabilir.
* **Android'de FLAG_SECURE:** Banka uygulamasında hassas bilgilerin olduğu ekranda ekran görüntüsü ve ekran kaydını engeller. Örneğin ekran görüntüsü alınmaya çalışıldığında siyah ekran çıkabilir veya ekran televizyona yansıtıldığında hassas bilgiler görünmez.
* **iOS'ta Blur (Bulanıklaştırma):** Uygulamadan çıkıldığında uygulamanın önizlemesindeki hassas bilgileri bulanıklaştırır. Örneğin Apple Mail veya bazı banka uygulamalarında uygulama önizlemesine bakıldığında bilgiler net görünmez.

## b) Overlay Saldırıları
Saldırgan, açık olan uygulamanın üzerine başka bir uygulamadan sahte bir buton ("Hediyeni al !!!!!") veya ekran yerleştirebilir. Örneğin bankacılık uygulamasındaki giriş ekranının üzerine sahte bir giriş ekranı koyarak kullanıcının kullanıcı adı ve şifresini girmesini sağlayabilir.

## c) Root / Jailbreak
Root veya Jailbreak yapılmış cihazlarda güvenlik kısıtlamaları aşılabildiği için uygulamanın dosya ve belleğine erişmek daha kolaydır. Örneğin saldırgan, bellekte bulunan Access Token gibi hassas bilgileri inceleyebilir.

### Kurumsal Root / Jailbreak Tespit Zinciri:
* **Dosya sistemi kontrolü:** SU dosyalarının ve root yöneticilerinin aranması.
* **Sistem izinleri & build tags:** İşletim sisteminin nasıl derlendiğinin kontrol edilmesi.
* **Komut satırı:** su komutunun çalıştırılması ve yönetici erişiminin kontrol edilmesi.
* **Dizin yazma testi:** `/system` veya `/private` dizinlerine yazma kontrolü.

*Kullandığımız cihazda bu 4 maddeden herhangi biri varsa root ya da jailbreak olduğu düşünülebilir.*

## d) SQLite ve Şifreleme
Normal bir SQLite veritabanında bilgiler düz metin olarak tutulursa cihazdaki dosyaya erişen biri kullanıcı bilgilerini okuyabilir. SQLCipher gibi şifreleme çözümlerinde veritabanı şifrelenir. Böylece dosyaya erişilse bile bilgiler doğrudan okunamaz. Anahtar girilmeden `SELECT`, `INSERT`, `UPDATE` vb. komutlar çalıştırılırsa sistem hata verir.

> **Çıktı:** `ERROR: file is not a database`

## e) Token Yönetimi

### Access Token
* Kullanıcının uygulamada yaptığı işlemlerde kimliğini doğrulamak için kullanılır.
* Güvenlik açısından kısa bir süre için geçerlidir. 
* Örneğin online para transferinde banka, müşterinin Access Token'ına bakarak kimliğini doğrular. 
* Eğer Access Token'ın süresi dolmuşsa ya da geçersizse `401 Unauthorized` hatası alınır. 
* Yalnızca RAM bellekte tutulur.

### Refresh Token
* Access Token'dan daha uzun süre geçerlidir. 
* Access Token'ın süresi dolduğunda yeni Access Token üretir. 
* Güvenli depolama altında (`Keystore`/`Keychain`) tutulur.
* Access Token'ın süresi dolduğunda `401 Unauthorized` hatası alınırsa mobil uygulama kullanıcıya hissettirmeden Refresh Token sayesinde yeni Access Token üretir ve oturum devam eder.