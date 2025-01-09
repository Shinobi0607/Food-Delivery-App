import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  // Stream to fetch orders from Firebase
  Stream<List<Map<String, dynamic>>> _fetchOrders() {
    final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
    return _databaseRef.child('orders').onValue.map((event) {
      if (event.snapshot.exists) {
        final orders = event.snapshot.children.map((child) {
          final data = child.value as Map<dynamic, dynamic>;
          return {
            'id': child.key,
            'totalPrice': data['totalPrice'] ?? '0.0',
            'timestamp': data['timestamp'] ?? '',
            'status': data['status'] ?? 'confirmed',
            'deliveryFee': data['deliveryFee'] ?? '9',
            'coins': data['coins'] ?? '0',
          };
        }).toList();
        return orders;
      } else {
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                orderId: order['id'],
                totalPrice: order['totalPrice'],
                timestamp: order['timestamp'],
                status: order['status'],
                deliveryFee: order['deliveryFee'],
                coins: order['coins'],
              );
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String totalPrice;
  final String timestamp;
  final String status;
  final String deliveryFee;
  final String coins;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.timestamp,
    required this.status,
    required this.deliveryFee,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #$orderId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total Price and Timestamp
            Text(
              'Total Bill: ₹$totalPrice',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Order Placed At: $timestamp',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 20),

            // Delivery Fee and Coins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee: ₹$deliveryFee',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Coins: $coins',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
