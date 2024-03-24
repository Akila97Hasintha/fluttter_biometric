import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getDeviceIdByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('deviceInfo') 
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        
        return querySnapshot.docs.first['deviceId'];
      } else {
        
        return null;
      }
    } catch (e) {
      print('Error getting device ID: $e');
      throw e;
    }
  }
}
