import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoriteItemsPage extends StatelessWidget {
  const FavoriteItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
      ),
      body: FutureBuilder(
        future: _databaseRef.child('favourites').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No favorite items found.'));
          }

          final favourites = snapshot.data!.children.map((e) => e.value as Map).toList();

          return ListView.builder(
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final fav = favourites[index];
              return ListTile(
                leading: Image.asset(fav['image'], width: 50, height: 50),
                title: Text(fav['name']),
                subtitle: Text('₹ ${fav['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
