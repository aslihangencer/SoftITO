class Cloud implements Exception{
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  Cloud(this.hataKodu, this.mesaj);

  @override 
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

class CpuOverload extends Cloud{
  final double mevcutCpu;
  final double limit;

  CpuOverload({
    required this.mevcutCpu, 
    required this.limit,
  }):super(
    "Err_cpu_overload",
    "Cpu kullanımı eşik limitini ($limit) aştı: $mevcutCpu%",
  );
}

class NodeUnavailable extends Cloud{
  final String nodeId;

  NodeUnavailable(
    this.nodeId
  ):super(
    "Err_node_offline","Yanıt vermiyor: $nodeId"
  );
}

void podKaynagiTahsisEt(
  String podAdi, 
  double talepEdilenCpu, 
  double sistemKalanCpu
){
  if (talepEdilenCpu <= 0){
    throw Cloud("Err_invalid_param", "Talep Edilen cpu pozitif bir değer olmalıdır.");
  }

  if (talepEdilenCpu > sistemKalanCpu){
    throw CpuOverload(mevcutCpu: 100-sistemKalanCpu+talepEdilenCpu, limit: 100.00);
  }

  print("Pod [$podAdi] başarıyla tahsis edildi: Kalan boş cpu: ${sistemKalanCpu - talepEdilenCpu}%");
}

void main(){
  print("Yönetim Panei");
  // başarılı tahsis
  try{
    podKaynagiTahsisEt("ingress-controller", 15.0, 40);
  } catch(e){
    print("Hata: $e");
  }

// TRY ON
  try{
    podKaynagiTahsisEt("ai-training-pd", 75.0, 20.0);
  } on CpuOverload catch(e){
    print("Cpu hatası yakalandı.");
    print("Hata kodu: ${e.hataKodu}");
    print("Mesaj: ${e.mesaj}");
    print("Aksiyon: Otomatik AWS açma isteği gönderildi.");
  } on Cloud catch(e){
    print("Bulut hatası: ${e.mesaj}");
  } catch(e, stackTrace){
    print("Bilinmedik Sistem Hatası $e");
  } finally{
    print("Pod tahsis günlüğü kapatıldı.");
  }


}
