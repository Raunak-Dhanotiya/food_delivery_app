import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  final String keyword;
  final List<String> recentSearches;

  const SearchResultsScreen({
    super.key,
    required this.keyword,
    required this.recentSearches,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late List<String> recentSearches;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> restaurants = [
    {'name': 'Pizza Palace', 'rating': 4.5, 'image': 'assets/images/restaurant1.webp'},
    {'name': 'Burger King', 'rating': 4.2, 'image': 'assets/images/restaurant2.webp'},
    {'name': 'Taco Bell', 'rating': 4.7, 'image': 'assets/images/restaurant3.webp'},
    {'name': 'Pizza Hut', 'rating': 4.3, 'image': 'assets/images/restaurant4.jpg'},
    {'name': 'Burger Farm', 'rating': 4.6, 'image': 'assets/images/restaurant5.jpg'},
    {'name': 'Hot Dog Heaven', 'rating': 4.4, 'image': 'assets/images/restaurant6.jpg'},
    {'name': 'McDonalds', 'rating': 4.1, 'image': 'assets/images/restaurant7.jpg'},
    {'name': 'Pizza Hub', 'rating': 4.0, 'image': 'assets/images/restaurant8.jpg'},
  ];

  List<Map<String, dynamic>> filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    recentSearches = List.from(widget.recentSearches);
    _controller.text = widget.keyword;
    _search(widget.keyword);
  }

  void _search(String keyword) {
    setState(() {
      filteredRestaurants = restaurants
          .where((restaurant) =>
          restaurant['name'].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      if (!recentSearches.contains(keyword)) {
        recentSearches.insert(0, keyword);
        if (recentSearches.length > 10) recentSearches.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: _search,
            ),
            SizedBox(height: 20),
            Text("Recent Searches", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recentSearches.map((keyword) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(keyword),
                      onPressed: () {
                        _controller.text = keyword;
                        _search(keyword);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text("Suggested Restaurants", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: filteredRestaurants.isEmpty
                  ? Center(child: Text("No restaurants found"))
                  : ListView.builder(
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = filteredRestaurants[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        restaurant['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(restaurant['name']),
                      subtitle: Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(restaurant['rating'].toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
