class Cart {
  final int? id;
  final String? productId;
  final String? productName;
  final String? image;
  final dynamic initialPrice;
  final dynamic productPrice;
  final int? quantity;

  Cart(
      {required this.productId,
      required this.id,
      required this.productName,
      required this.image,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity});

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        productId = res["productId"],
        productName = res["productName"],
        image = res["image"],
        initialPrice = res["initialPrice"],
        productPrice = res["productPrice"],
        quantity = res["quantity"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "productId": productId,
      "productName": productName,
      "image": image,
      "initialPrice": initialPrice,
      "productPrice": productPrice,
      "quantity": quantity,
    };
  }
}
