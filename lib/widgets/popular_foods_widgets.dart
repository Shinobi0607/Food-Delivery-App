import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_ordering_app/pages/product_details_page.dart';

class PopularFoodsWidgets extends StatelessWidget {
  final String searchQuery;

  const PopularFoodsWidgets({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    
    final allFoodItems = [
      {'name': 'Burger', 'imageUrl': 'burger', 'price': '100.00'},
      {'name': 'Pizza', 'imageUrl': 'pizza', 'price': '250.00'},
      {'name': 'Chicken Bucket', 'imageUrl': 'chicken-bucket', 'price': '100.00'},
      {'name': 'Ice Cream', 'imageUrl': 'ice-cream', 'price': '50.00'},
      {'name': 'Dosa', 'imageUrl': 'dosa', 'price': '80.00'},
      {'name': 'Egg', 'imageUrl': 'egg', 'price': '60.00'},
      {'name': 'Salad', 'imageUrl': 'salad', 'price': '120.00'},
      {'name': 'Soft Drink', 'imageUrl': 'soft-drink', 'price': '30.00'},
    ];

    
    final filteredFoodItems = searchQuery.isEmpty
        ? allFoodItems
        : allFoodItems
            .where((food) =>
                food['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredFoodItems.length,
        itemBuilder: (context, index) {
          final food = filteredFoodItems[index];
          return PopularFoodTiles(
            name: food['name']!,
            imageUrl: food['imageUrl']!,
            price: food['price']!,
          );
        },
      ),
    );
  }
}

class PopularFoodTiles extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String price;

  const PopularFoodTiles({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  _PopularFoodTilesState createState() => _PopularFoodTilesState();
}

class _PopularFoodTilesState extends State<PopularFoodTiles> {
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
        SnackBar(
          content: Text('${widget.name} added to cart!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add ${widget.name} to cart: $e'),
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: const Color(0xFFF9F9F9),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 170,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/${widget.imageUrl}.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: toggleFavourite,
                        child: Icon(
                          isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavourite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹ ${widget.price}',
                  textAlign: TextAlign.center,
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: addToCart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Image.asset(
                        'assets/grocery-store.png', 
                        height: 16,
                        width: 16,
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
      ),
    );
  }
}
