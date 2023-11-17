import 'package:chkv16/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase user
  User? get currentUser => _auth.currentUser;

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await _auth.setPersistence(Persistence.LOCAL);
      await _firestore.enablePersistence();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream of products
  Stream<List<Product>> getProductsStream() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }
}
