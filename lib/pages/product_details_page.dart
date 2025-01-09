import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_ordering_app/pages/food_order_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImage;

  const ProductDetailsPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int cartItemCount = 0;
  int itemQuantity = 1;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchCartItemCount();
  }

  
  Future<void> _fetchCartItemCount() async {
    try {
      final snapshot = await _databaseRef.child('cart').get();
      if (snapshot.exists) {
        setState(() {
          cartItemCount = snapshot.children.length;
        });
      } else {
        setState(() {
          cartItemCount = 0;
        });
      }
    } catch (e) {
      print("Error fetching cart item count: $e");
    }
  }

  
  Future<void> _addToCart() async {
    try {
      final cartRef = _databaseRef.child('cart').push();
      await cartRef.set({
        'name': widget.productName,
        'price': widget.productPrice,
        'quantity': itemQuantity,
        'image': widget.productImage,
      });

      await _fetchCartItemCount(); 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.productName} added to cart!")),
      );
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  final List<Map<String, String>> recommendedProducts = [
    {'name': 'Burger', 'imageUrl': 'burger', 'price': '100.00'},
    {'name': 'Pizza', 'imageUrl': 'pizza', 'price': '250.00'},
    {'name': 'Chicken Bucket', 'imageUrl': 'chicken-bucket', 'price': '100.00'},
    {'name': 'Ice Cream', 'imageUrl': 'ice-cream', 'price': '50.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.productName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      widget.productImage,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹ ${widget.productPrice}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Delicious ${widget.productName}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: itemQuantity > 1
                        ? () {
                            setState(() {
                              itemQuantity--;
                            });
                          }
                        : null,
                  ),
                  Text(
                    '$itemQuantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        itemQuantity++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _addToCart,
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              
              const Text(
                "Recommended Products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedProducts.length,
                  itemBuilder: (context, index) {
                    final product = recommendedProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              productName: product['name']!,
                              productPrice: product['price']!,
                              productImage: 'assets/${product['imageUrl']}.png',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/${product['imageUrl']}.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹ ${product['price']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFF34A853),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "View Cart  $cartItemCount items",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FoodOrderPage(),
                  ),
                );
              },
              child: const Text(
                "Checkout",
                style: TextStyle(
                  color: Color(0xFF34A853),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
