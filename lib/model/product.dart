
class Product {
  final int id;
  final String name;
  final String image;
  final int price;
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
      };
  static Product fromJson(Map<dynamic, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        price: json['price'],
      );
}
