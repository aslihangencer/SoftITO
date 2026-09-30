// SPREAD ... ....? ve collection if ve collection for kullanimi
void main() {
  print("Pipeline Konfigurasyonu");

  bool productionMu = true;
  bool debugLoggingAktif = false;
  final List<String>? cloudWatchEklentileri = ["datadog-agent:v7", "prometheus-exporter"];
  final List<String>? geciciTestYamalari = null;

  final List<String> aktifPipelineAdimlari = [
    "git-checkout",
    "security-sast-scan",
    if (productionMu) "production-kms-check",
    if (debugLoggingAktif) "verbose-debug-logger" else "minified-json-logger",
    ...["docker-build", "helm-chart-package"],
    ...?cloudWatchEklentileri,
    ...?geciciTestYamalari,
  ];

  for (int i = 0; i < aktifPipelineAdimlari.length; i++) {
    print("Adim ${i + 1}: ${aktifPipelineAdimlari[i]}");
  }

  final List<int> izinliPortlar = [8080, 8443, 9090];
  print("Izinli portlar: $izinliPortlar");

  final List<String> firewallGuvenlikKurallari = [
    "INTGRESSS-DEFAULT-DROP",
    for (var port in izinliPortlar) "ALLOW-TCP_PORT-Sport(VPC_INTERNAL)",
    "EGRESS_ALL_ALLOW",
  ];

  print("Firewall guvenlik kurallari (collection for): ---");
  firewallGuvenlikKurallari.forEach((kural) => print(kural));
}