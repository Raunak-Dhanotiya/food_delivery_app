import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class Dashboard1 extends StatefulWidget {
  final LatLng location;

  Dashboard1({required this.location});

  @override
  _Dashboard1State createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
  String address = "Fetching address...";
  int cartItemCount = 2;
  String username = "Raunak";

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.location.latitude, widget.location.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        address = "${place.subLocality}, ${place.locality}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 10,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 30, color: Colors.black),
            onPressed: () {},
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "DELIVER TO",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFC6E2A),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              address,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Sen',
                                height: 1.0,
                                letterSpacing: 0.0,
                                color: Color(0xFF676767),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.black, size: 30),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(cartItemCount.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hey $username, Good Afternoon",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: "Search dishes, restaurants",
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Categories",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.orange),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 80, // Set fixed height to prevent overflow
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none, // Prevent clipping of items
                child: Row(
                  children: [
                    _buildCategoryItem("All", Icons.local_fire_department, Colors.orange),
                    _buildCategoryItem("Pizza", Icons.local_pizza, Colors.red),
                    _buildCategoryItem("Burger", Icons.fastfood, Colors.brown),
                    _buildCategoryItem("Drinks", Icons.local_drink, Colors.blue),
                    _buildCategoryItem("Desserts", Icons.cake, Colors.pink),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return Container(
      width: 130,
      height: 70,
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(39),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          SizedBox(width: 6),
          Expanded( // Prevents text overflow
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
