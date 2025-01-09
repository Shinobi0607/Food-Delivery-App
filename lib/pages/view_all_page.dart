import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_ordering_app/pages/product_details_page.dart';

class ViewAllPage extends StatelessWidget {
  final List<Map<String, String>> allFoodItems = [
    {'name': 'Burger', 'imageUrl': 'burger', 'price': '100.00'},
    {'name': 'Pizza', 'imageUrl': 'pizza', 'price': '250.00'},
    {'name': 'Chicken Bucket', 'imageUrl': 'chicken-bucket', 'price': '100.00'},
    {'name': 'Ice Cream', 'imageUrl': 'ice-cream', 'price': '50.00'},
    {'name': 'Dosa', 'imageUrl': 'dosa', 'price': '80.00'},
    {'name': 'Egg', 'imageUrl': 'egg', 'price': '60.00'},
    {'name': 'Salad', 'imageUrl': 'salad', 'price': '120.00'},
    {'name': 'Soft Drink', 'imageUrl': 'soft-drink', 'price': '30.00'},
  ];

  ViewAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Available Items',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: allFoodItems.length,
          itemBuilder: (context, index) {
            final food = allFoodItems[index];
            return ViewAllFoodCard(
              name: food['name']!,
              imageUrl: food['imageUrl']!,
              price: food['price']!,
            );
          },
        ),
      ),
    );
  }
}

class ViewAllFoodCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String price;

  const ViewAllFoodCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  _ViewAllFoodCardState createState() => _ViewAllFoodCardState();
}

class _ViewAllFoodCardState extends State<ViewAllFoodCard> {
  bool isFavourite = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<void> toggleFavourite() async {
    setState(() {
      isFavourite = !isFavourite;
    });

    if (isFavourite) {
      await _databaseRef.child('favourites').push().set({
        'name': widget.name,
        'price': widget.price,
        'image': 'assets/${widget.imageUrl}.png',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.name} added to favourites!')),
      );
    } else {
      final snapshot = await _databaseRef.child('favourites').get();
      if (snapshot.exists) {
        for (var child in snapshot.children) {
          if (child.child('name').value == widget.name) {
            await child.ref.remove();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.name} removed from favourites!')),
            );
            break;
          }
        }
      }
    }
  }

  Future<void> addToCart() async {
    try {
      await _databaseRef.child('cart').push().set({
        'name': widget.name,
        'price': widget.price,
        'quantity': 1, 
        'image': 'assets/${widget.imageUrl}.png',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.name} added to cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${widget.name} to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productName: widget.name,
              productPrice: widget.price,
              productImage: 'assets/${widget.imageUrl}.png',
            ),
          ),
        );
      },
      child: Card(
        color: const Color(0xFFF9F9F9),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: toggleFavourite,
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/${widget.imageUrl}.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                '₹ ${widget.price}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: addToCart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/grocery-store.png', 
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
