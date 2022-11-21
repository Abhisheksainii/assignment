class Product{
  final int id;
  final String description;
  final String title;
  final String imageid;
  final dynamic price;
  final String category;
  final Map<String, dynamic> rating;

  Product({required this.id,required  this.description,required  this.title,required  this.imageid,required  this.price,required  this.category,required  this.rating});

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      category: json["category"],
      description: json["description"],
      price: json["price"],
      imageid: json["image"],
      rating: json["rating"],
      title: json["title"],
    );
}
}