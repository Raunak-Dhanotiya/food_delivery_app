import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _addFoodItem() async {
    await _firestore.collection("food").add({
      "name": _nameController.text,
      "price": double.parse(_priceController.text),
      "image": "https://via.placeholder.com/150",
      "description": "Sample description",
    });
    _nameController.clear();
    _priceController.clear();
  }

  void _updateFoodItem(String id) async {
    await _firestore.collection("food").doc(id).update({
      "name": _nameController.text,
      "price": double.parse(_priceController.text),
    });
  }

  void _deleteFoodItem(String id) async {
    await _firestore.collection("food").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Items")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Food Name"),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addFoodItem,
                  child: Text("Add Food Item"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection("food").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                var foods = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    var food = foods[index];

                    return ListTile(
                      leading: Image.network(food["image"], width: 50),
                      title: Text(food["name"]),
                      subtitle: Text("\$${food["price"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _nameController.text = food["name"];
                              _priceController.text = food["price"].toString();
                              _updateFoodItem(food.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFoodItem(food.id),
                          ),
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
