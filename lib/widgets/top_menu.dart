import 'package:flutter/material.dart';

class TopMenuTiles extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String nickname;

  TopMenuTiles({
    required this.name,
    required this.imageUrl,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodCategoryPage(
              categoryName: name,
              imageUrl: imageUrl,
              price: '150.00', 
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 241, 235, 235),
                  offset: Offset(0.0, 0.76),
                  blurRadius: 24,
                )
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              child: SizedBox(
                width: 51,
                height: 51,
                child: Center(
                  child: Image.asset(
                    'assets/$imageUrl.png',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              color: Color.fromARGB(255, 10, 10, 10),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class TopMenus extends StatelessWidget {
  const TopMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TopMenuTiles(
            name: 'Burger',
            imageUrl: 'burger',
            nickname: 'burger',
          ),
          TopMenuTiles(
            name: 'Pizza',
            imageUrl: 'pizza',
            nickname: 'pizza',
          ),
          TopMenuTiles(
            name: 'Drink',
            imageUrl: 'soft-drink',
            nickname: 'drink',
          ),
          TopMenuTiles(
            name: 'Salad',
            imageUrl: 'salad',
            nickname: 'salad',
          ),
          TopMenuTiles(
            name: 'Dessert',
            imageUrl: 'ice-cream',
            nickname: 'dessert',
          ),
          TopMenuTiles(
            name: 'South Indian',
            imageUrl: 'dosa',
            nickname: 'South Indian',
          ),
        ],
      ),
    );
  }
}

class FoodCategoryPage extends StatelessWidget {
  final String categoryName;
  final String imageUrl;
  final String price;

  const FoodCategoryPage({
    super.key,
    required this.categoryName,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 4, 
          itemBuilder: (context, index) {
            return FoodCategoryCard(
              name: categoryName, 
              imageUrl: imageUrl, 
              price: price, 
            );
          },
        ),
      ),
    );
  }
}

class FoodCategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String price;

  const FoodCategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: const Color(0xFFF9F9F9),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Image.asset(
                'assets/$imageUrl.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(width: 16),

              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ $price',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added to cart!')),
                  );
                },
                child: Row(
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
