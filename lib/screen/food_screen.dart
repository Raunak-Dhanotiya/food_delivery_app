import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Function to Add Food Item (Create)
  Future<void> addFoodItem() async{
    await _firestore.collection('food').add({
      "name": nameController.text,
      "price": double.parse(priceController.text),
      "image": imageController.text,
      "description": descriptionController.text,
    });
    nameController.clear();
    priceController.clear();
    imageController.clear();
    descriptionController.clear();
  }

  // Function to Update Food Item
  Future<void> updateFoodItem(String id) async {
    await _firestore.collection('food').doc(id).update({
      "name": nameController.text,
      "price": double.parse(priceController.text),
      "image": imageController.text,
      "description": descriptionController.text,
    });
    nameController.clear();
    priceController.clear();
    imageController.clear();
    descriptionController.clear();
  }

  // Function to Delete Food Item
  Future<void> deleteFoodItem(String id) async {
    await _firestore.collection('food').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Menu')),
      body: Column(
        children: [
          // Input Fields to Add Food Item
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Food Name")),
                TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
                TextField(controller: imageController, decoration: InputDecoration(labelText: "Image URL")),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
                SizedBox(height: 10),
                ElevatedButton(onPressed: addFoodItem, child: Text("Add Food")),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('food').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final foodItems = snapshot.data!.docs.map((doc) {
                  return FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final food = foodItems[index];
                    return ListTile(
                      leading: Image.network(food.image, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(food.name),
                      subtitle: Text("\$${food.price.toString()}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.edit), onPressed: () {
                            nameController.text = food.name;
                            priceController.text = food.price.toString();
                            imageController.text = food.image;
                            descriptionController.text = food.description;
                            updateFoodItem(food.id);
                          }),
                          IconButton(icon: Icon(Icons.delete), onPressed: () => deleteFoodItem(food.id)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
