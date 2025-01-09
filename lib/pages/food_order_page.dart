import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_ordering_app/widgets/cart_items.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  final TextEditingController _addressController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  double _totalPrice = 0.0;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Real-time stream for cart items
  Stream<List<Map<String, dynamic>>> _cartItemsStream() {
    return _databaseRef.child('cart').onValue.map((event) {
      if (event.snapshot.exists) {
        final cartItems = event.snapshot.children.map((child) {
          final data = child.value as Map<dynamic, dynamic>;
          return {
            'id': child.key,
            'name': data['name'],
            'price': double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
            'quantity': data['quantity'] ?? 0,
            'image': data['image'],
          };
        }).toList();

        // Calculate total price
        _totalPrice = cartItems.fold(
          0.0,
          (sum, item) => sum + (item['quantity'] * item['price']),
        );

        return cartItems;
      } else {
        return [];
      }
    });
  }

  // Place an order
  Future<void> _placeOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a delivery address")),
      );
      return;
    }

    try {
      final cartSnapshot = await _databaseRef.child('cart').get();

      if (cartSnapshot.exists) {
        final orderItems = cartSnapshot.children.map((child) {
          final data = child.value as Map<dynamic, dynamic>;
          return {
            'name': data['name'],
            'price': data['price'],
            'quantity': data['quantity'],
            'image': data['image'],
          };
        }).toList();

        // Add the order to the "orders" node
        await _databaseRef.child('orders').push().set({
          'items': orderItems,
          'totalPrice': _totalPrice.toStringAsFixed(2),
          'address': _addressController.text,
          'paymentMethod': 'Cash On Delivery',
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Clear the cart
        await _databaseRef.child('cart').remove();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your order has been placed successfully")),
        );

        _addressController.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3a3737)),
        ),
        title: const Center(
          child: Text(
            "Food Item Carts",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _cartItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          final cartItems = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Food Cart",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 11),
                  ...cartItems.map((item) {
                    return CartItems(
                      name: item['name'],
                      price: item['price'],
                      image: item['image'],
                      quantity: item['quantity'],
                      incrementQuantity: () async {
                        final newQuantity = item['quantity'] + 1;
                        await _databaseRef
                            .child('cart')
                            .child(item['id'])
                            .update({'quantity': newQuantity});
                      },
                      decrementQuantity: () async {
                        final newQuantity = item['quantity'] - 1;
                        if (newQuantity > 0) {
                          await _databaseRef
                              .child('cart')
                              .child(item['id'])
                              .update({'quantity': newQuantity});
                        }
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 15),

                  // Address Input
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFe6e1e1), width: 1),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      fillColor: Colors.white,
                      hintText: "Add Your Delivery Address",
                      filled: true,
                      suffixIcon: const Icon(Icons.delivery_dining, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Method Section
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.delivery_dining, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          "Cash On Delivery",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Total Calculation Section
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "₹${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  Divider(color: Colors.grey.shade400),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹${_totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Place Order Button
                  InkWell(
                    onTap: _placeOrder,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B2CFD),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Center(
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
