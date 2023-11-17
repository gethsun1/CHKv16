import 'dart:io';

import 'package:chkv16/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  _ProductEntryScreenState createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<String> _uploadImage(File imageFile) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _addProductToFirestore(Product product) async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': product.name,
      'quantity': product.quantity,
      'pricePerKG': product.pricePerKG,
      'image': product.image,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Product Quantity'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price Per KG'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  _imageFile = image;
                });
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Upload Product Image'),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                double quantity = double.parse(_quantityController.text);
                double pricePerKG = double.parse(_priceController.text);

                if (_imageFile != null) {
                  String imageUrl = await _uploadImage(File(_imageFile!.path));
                  Product product = Product(
                    id: '', // Set to an empty string, as it will be assigned by Firestore
                    name: name,
                    quantity: quantity,
                    pricePerKG: pricePerKG,
                    image: imageUrl,
                  );

                  await _addProductToFirestore(product);

                  _nameController.clear();
                  _quantityController.clear();
                  _priceController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Handle case when no image is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
