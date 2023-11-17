import 'package:flutter/material.dart';
import 'package:chkv16/widgets/product_card.dart';
import 'package:chkv16/models/product.dart';
import 'package:chkv16/services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _firebaseService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Product> products = snapshot.data ?? [];

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
