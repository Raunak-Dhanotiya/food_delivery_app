import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'search_results_screen.dart';

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
  List<String> addresses = [
    "Vijay Nagar, Indore",
    "Rajeev Gandhi Nagar, Kota",
    "Malviya Nagar, Jaipur"
  ];
  List<String> recentSearches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.location.latitude,
        widget.location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          address = "${place.subLocality}, ${place.locality}";
        });
      }
    } catch (e) {
      setState(() {
        address = "Unknown Location";
      });
    }
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: addresses.map(
                        (addr) => ListTile(
                      title: Text(addr),
                      onTap: () {
                        setState(() {
                          address = addr;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchSubmitted(String keyword) {
    if (keyword.isNotEmpty) {
      setState(() {
        if (!recentSearches.contains(keyword)) {
          recentSearches.insert(0, keyword);
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(
            keyword: keyword,
            recentSearches: recentSearches,
          ),
        ),
      );
    }
  }

  Widget buildCategoryChip(String label, IconData icon) {
    return Container(
      width: 120,
      height: 90,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(39),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 35, color: Colors.orange),
          ),
          SizedBox(width: 5),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget buildRestaurantCard(String imagePath, String name, double rating, String delivery, String time) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.w400, fontSize: 18)),
          SizedBox(height: 5),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.orange.shade100,
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(rating.toString(), style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.delivery_dining, size: 16),
                  SizedBox(width: 4),
                  Text(delivery, style: TextStyle(fontSize: 13)),
                ],
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 4),
                  Text(time, style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 10,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFECF0F4),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu, color: Colors.black, size: 24),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: _showAddressBottomSheet,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("DELIVER TO", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFC6E2A))),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontFamily: 'Sen', color: Color(0xFF676767)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.black, size: 26),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartItemCount.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hey $username, Good Afternoon", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextField(
                controller: _searchController,
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: "Search dishes, restaurants",
                  hintStyle: TextStyle(fontSize: 16),
                  prefixIcon: Icon(Icons.search, size: 28, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("See All >", style: TextStyle(color: Colors.orange)),
                ],
              ),
              SizedBox(height: 14),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    buildCategoryChip("All", Icons.local_fire_department),
                    buildCategoryChip("Pizza", Icons.local_pizza),
                    buildCategoryChip("Burger", Icons.fastfood),
                    buildCategoryChip("Sandwich", Icons.lunch_dining),
                    buildCategoryChip("Drinks", Icons.local_drink),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Open Restaurants", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("See All >", style: TextStyle(color: Colors.orange)),
                ],
              ),
              SizedBox(height: 14),
              Column(
                children: [
                  buildRestaurantCard("assets/images/restaurant1.webp", "Pizza Palace", 4.5, "Free Delivery", "20-30 min"),
                  buildRestaurantCard("assets/images/restaurant2.webp", "Pizza Hut", 4.2, "Free Delivery", "10-20 min"),
                  buildRestaurantCard("assets/images/restaurant3.webp", "Taco Bell", 4.7, "Free Delivery", "15-25 min"),
                  buildRestaurantCard("assets/images/restaurant4.jpg", "Pizza Hub", 4.4, "Free Delivery", "05-10 min"),
                  buildRestaurantCard("assets/images/restaurant5.jpg", "McDonalds", 4.3, "Free Delivery", "10-15 min"),
                  buildRestaurantCard("assets/images/restaurant6.jpg", "Burger-co", 4.7, "Free Delivery", "15-25 min"),
                  buildRestaurantCard("assets/images/restaurant7.jpg", "Burger King", 4.5, "Free Delivery", "15-25 min"),
                  buildRestaurantCard("assets/images/restaurant8.jpg", "Burger Farm", 4.8, "Free Delivery", "15-25 min"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}