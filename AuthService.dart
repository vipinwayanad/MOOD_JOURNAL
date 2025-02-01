import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user with email, password, and name
  Future<User?> registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Store user details in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'uid': user.uid,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Registration Error: Email already in use');
      } else {
        print('Registration Error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  // Login with email and password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message}');
      return null;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  // Logout the user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Fetch user name from Firestore
  Future<String?> getUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.exists ? userDoc['name'] as String? : null;
    } catch (e) {
      print('Error fetching user name: ${e.toString()}');
      return null;
    }
  }
}
