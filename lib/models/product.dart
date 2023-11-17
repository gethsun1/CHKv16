import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double quantity;
  final double pricePerKG;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.pricePerKG,
    required this.image,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0.0,
      pricePerKG: data['pricePerKG'] ?? 0.0,
      image: data['image'] ?? '',
    );
  }
}
