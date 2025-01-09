import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_ordering_app/pages/food_order_page.dart';
import 'package:food_ordering_app/route.dart';

class BestFoodTiles extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String nickname;
  final String price;
  final String review;

  BestFoodTiles({
    required this.name,
    required this.imageUrl,
    required this.nickname,
    required this.price,
    required this.review,
  });

  
  Future<void> addToCart(BuildContext context) async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

    try {
      
      await databaseRef.child('cart').push().set({
        'name': name,
        'price': price,
        'quantity': 1, 
        'image': 'assets/$imageUrl.jpeg',
      });

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name added to cart!'),
        ),
      );
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add $name to cart: $e'),
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
          CustomRoute(
            page: FoodOrderPage(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              margin: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Image.asset(
                    'assets/$imageUrl.jpeg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),

                  
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  
                  Text(
                    '₹ $price',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
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
                    onPressed: () => addToCart(context),
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BestFoodsWidget extends StatelessWidget {
  const BestFoodsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BestFoodTiles(
          name: 'Deluxe Breakfast',
          imageUrl: 'ic_best_food_1',
          nickname: 'breakfast',
          price: '210.00',
          review: '4.8',
        ),
        BestFoodTiles(
          name: 'Grilled Chicken',
          imageUrl: 'ic_best_food_8',
          nickname: 'grilled-chicken',
          price: '210.00',
          review: '4.8',
        ),
        BestFoodTiles(
          name: 'Tropical Salad',
          imageUrl: 'ic_best_food_10',
          nickname: 'salad',
          price: '210.00',
          review: '4.8',
        ),
        BestFoodTiles(
          name: 'British Cuisine',
          imageUrl: 'ic_best_food_5',
          nickname: 'cuisine',
          price: '210.00',
          review: '4.8',
        ),
      ],
    );
  }
}
