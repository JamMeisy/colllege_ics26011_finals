import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> checkIfAdmin() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.email!;

      try {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(userId).get();

        if (userSnapshot.exists) {
          bool userIsAdmin = userSnapshot['isAdmin'] ?? false;
          return userIsAdmin;
        }
      } catch (e) {
        print('Error fetching user document: $e');
      }
    }
    return false;
  }
}
