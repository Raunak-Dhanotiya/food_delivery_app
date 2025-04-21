class FoodItem {
  String id;
  String name;
  double price;
  String image;
  String description;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  // Convert FoodItem to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "image": image,
      "description": description,
    };
  }

  // Convert Firestore Document to FoodItem Object
  factory FoodItem.fromMap(Map<String, dynamic> data, String id) {
    return FoodItem(
      id: id,
      name: data["name"],
      price: (data["price"] as num).toDouble(),
      image: data["image"],
      description: data["description"],
    );
  }
}
