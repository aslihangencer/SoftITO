# CSS Grid, Flexbox ve Responsive Tasarım

## 1. Flexbox ile CSS Grid arasındaki mimari fark nedir ve ne zaman hangisi seçilmelidir?

**Flexbox** tek boyutlu bir düzen sistemidir. Elemanları bir satırda yan yana veya bir sütunda alt alta düzenlemek için kullanılır. Örneğin navbar'da logoyu sola, linkleri sağa yerleştirmek veya bir butonun içindeki ikon ve metni ortalamak için Flexbox kullanabiliriz. Kısacası, tek yönlü düzenlerde **Flexbox** tercih edilir.

**CSS Grid** ise iki boyutlu bir düzen sistemidir. Hem satırları hem de sütunları aynı anda kontrol etmemizi sağlar. Sayfanın genel iskeletini oluştururken, ürün veya fotoğraf galerilerini düzenlerken ya da dashboard'daki kartları yerleştirirken **CSS Grid** daha uygundur.

---

## 2. CSS Grid'deki `fr` birimi, `%` birimine göre neden daha güvenlidir?

`fr` birimi, grid container içinde kalan alanı sütunlar arasında paylaştırır. Bu yüzden özellikle `gap` gibi boşluklarla birlikte kullanıldığında alanı daha kontrollü dağıtır.

`%` kullanırken sütunların genişlikleri toplamına `gap` de eklendiğinde container'ın dışına taşma ihtimali olabilir. Bu nedenle Grid yapılarında **`fr` kullanmak genellikle daha güvenlidir.**

---

## 3. Neden Mobile-First (`min-width`) mimarisi tercih edilir?

**Mobile-First** yaklaşımında tasarıma önce küçük ekranlardan başlanır. Daha sonra ekran genişledikçe `min-width` kullanılarak yeni düzenlemeler eklenir.

Bu yaklaşım responsive tasarımı daha kolay yönetmemizi sağlar ve başlangıçta gereksiz CSS yazmamızı önler. Ayrıca tasarımın mobil cihazlarda düzgün çalışmasını en baştan sağlamış oluruz.

---

## 4. Neden `top`, `left`, `width` yerine `transform` ve `opacity` tercih edilir?

`top`, `left` ve `width` gibi özellikler değiştirildiğinde tarayıcının sayfanın yerleşimini tekrar hesaplaması gerekebilir. Bu durum özellikle sık çalışan animasyonlarda performansı olumsuz etkileyebilir.

`transform` ve `opacity` ise animasyonlarda tarayıcı tarafından daha verimli işlenebilir. Bu yüzden daha akıcı animasyonlar oluşturmak için genellikle **`transform` ve `opacity`** tercih edilir.

---

## 5. CSS Grid'de `auto-fit` ile `minmax()` birleşimi nasıl çalışır?

`minmax()` bir sütunun alabileceği **minimum ve maksimum genişliği** belirler. `auto-fit` ise container'a sığabilecek kadar sütun oluşturur ve ekran genişliği değiştikçe sütun sayısını otomatik olarak ayarlar.

Örneğin:

```css
grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
```

Bu kullanım sayesinde kartlar ekran genişliğine göre otomatik olarak yeniden düzenlenir. Böylece farklı ekran boyutları için ayrı ayrı media query yazmaya daha az ihtiyaç duyarız.

---

## 6. `grid-template-areas` özelliğinin en büyük kurumsal avantajı nedir?

En büyük avantajı, sayfa düzenini **daha okunabilir ve anlaşılır** hale getirmesidir.

Örneğin `header`, `sidebar`, `main` ve `footer` gibi bölümlere isim vererek sayfanın genel iskeletini CSS içerisinde kolayca görebiliriz. Bu da özellikle büyük projelerde kodun okunmasını, bakımını ve sonradan değiştirilmesini kolaylaştırır.

---

## 7. CSS'te `clamp()` fonksiyonunun 3 parametresi ne anlama gelir?

`clamp()` üç değer alır:

```css
clamp(minimum, ideal, maximum)
```

* İlk değer → **Minimum değer**
* İkinci değer → **Tercih edilen / ideal değer**
* Üçüncü değer → **Maksimum değer**

Örneğin:

```css
font-size: clamp(16px, 2vw, 24px);
```

Burada yazı boyutu ekran genişliğine göre değişebilir ancak **16px'den küçük ve 24px'den büyük olamaz.**

---

## 8. Bir CSS animasyonunun sonsuza kadar kesintisiz çalışması için hangi CSS kuralı kullanılır?

Animasyonun kaç kez tekrarlanacağını belirlemek için `animation-iteration-count` kullanılır. Sonsuz tekrar için değer olarak `infinite` verilir.

Örneğin:

```css
animation: hareket 2s infinite;
```

Burada animasyon **2 saniyelik süreyle sonsuza kadar tekrar eder.**

---

## 9. Flutter'da CSS Grid ve Flexbox'ın doğrudan karşılığı olan widget'lar nelerdir?

Flutter'da Flexbox'ın kullanım mantığına en yakın widget'lar **`Row`** ve **`Column`**'dur.

* `Row` → Elemanları yatay olarak düzenler.
* `Column` → Elemanları dikey olarak düzenler.
* `GridView` → Elemanları satır ve sütunlardan oluşan ızgara yapısında düzenler.

Bu nedenle CSS Grid'e karşılık olarak genellikle **`GridView`** kullanılır.

---

## 10. React Native'de CSS Grid kullanılabilir mi? Çok sütunlu yapı nasıl oluşturulur?

React Native'de web'deki CSS Grid sistemi doğrudan kullanılmaz. Çok sütunlu liste ve ızgara yapıları oluşturmak için genellikle **`FlatList`** kullanılır.

`numColumns` özelliği ile kaç sütun olacağını belirleyebiliriz.

Örneğin:

```jsx
<FlatList
  data={items}
  numColumns={2}
  renderItem={({ item }) => <Card item={item} />}
/>
```

Burada `numColumns={2}` kullanıldığı için elemanlar **iki sütun halinde** gösterilir.
