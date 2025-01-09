import 'package:flutter/material.dart';

class CategoryFoodPage extends StatelessWidget {
  final String category;

  const CategoryFoodPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    
    final Map<String, List<Map<String, String>>> foodItems = {
      'Burger': [
        {'name': 'Classic Burger', 'image': 'burger', 'price': '150.00'},
        {'name': 'Cheese Burger', 'image': 'burger', 'price': '180.00'},
        {'name': 'Veggie Burger', 'image': 'burger', 'price': '130.00'},
        {'name': 'Double Patty Burger', 'image': 'burger', 'price': '200.00'},
      ],
      'Pizza': [
        {'name': 'Margherita Pizza', 'image': 'pizza', 'price': '250.00'},
        {'name': 'Pepperoni Pizza', 'image': 'pizza', 'price': '300.00'},
        {'name': 'BBQ Chicken Pizza', 'image': 'pizza', 'price': '350.00'},
        {'name': 'Veg Supreme Pizza', 'image': 'pizza', 'price': '280.00'},
      ],
      
    };

    
    final items = foodItems[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '$category Items',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/${item['image']}.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${item['price']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} added to cart!')),
                      );
                      
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
