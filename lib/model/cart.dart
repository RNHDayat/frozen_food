class Cart{
  final int id,price,jumlah,total;
  final String name;
  final String image;
  final String userId;
  Cart({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.jumlah,
    required this.total,
    required this.userId,
  });

  Map<String,dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'image' : image,
      'price' : price,
      'jumlah' : jumlah,
      'total' : total,
      'userId' : userId,
    };
  }

  factory Cart.fromJson(Map<String,dynamic> json) {
    return Cart(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      price: json["price"],
      jumlah: json["jumlah"],
      total: json["total"],
      userId: json["userId"],

    );
  }
}