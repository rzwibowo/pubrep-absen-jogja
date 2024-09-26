class ItemHistoriAbsen {
  String? tanggal;
  String? jamMasuk;
  String? jamPulang;

  ItemHistoriAbsen({this.tanggal, this.jamMasuk, this.jamPulang});

  ItemHistoriAbsen.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    jamMasuk = json['jamMasuk'];
    jamPulang = json['jamPulang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tanggal'] = this.tanggal;
    data['jamMasuk'] = this.jamMasuk;
    data['jamPulang'] = this.jamPulang;
    return data;
  }
}
