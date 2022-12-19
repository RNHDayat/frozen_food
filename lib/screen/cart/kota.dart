class kota {
  String? cityId;
  String? type;
  String? cityName;

  kota({this.cityId, this.type, this.cityName});

  kota.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city_name'];
  }

  @override
  String toString() => cityName as String;

  static List<kota> fromJsonList(List list) {
    if (list.length == 0) return List<kota>.empty();
    return list.map((item) => kota.fromJson(item)).toList();
  }
}
