import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String restaurantName;
  final List<Map<String, dynamic>> foods;

  RestaurantDetailScreen({required this.restaurantName, required this.foods});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Image.asset(
                food['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(food['name']),
              subtitle: Text("₹${food['price']}"),
              trailing: Icon(Icons.add_shopping_cart),
            ),
          );
        },
      ),
    );
  }
}
