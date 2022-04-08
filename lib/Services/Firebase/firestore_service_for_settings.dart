import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durood_together_app/Models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServiceForSettings {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<UserProfile> getUserData() {
    return _db
        .collection("User")
        .doc(auth.currentUser?.uid)
        .snapshots()
        .map((snapshot) => UserProfile.fromFirestore(snapshot.data()));
  }

  Future<void> saveName(String name) async {
    final checkDoc = await _db
        .collection('User')
        .doc(auth.currentUser?.uid)
        .get();
    if(checkDoc.exists) {
      await _db
          .collection('User')
          .doc(auth.currentUser?.uid)
          .update(
        {
          "name": name,
        },
      );
    }
    else{
      await _db
          .collection('User')
          .doc(auth.currentUser?.uid)
          .set(
        {
          "name": name,
          "city": "",
          "country": "",
        },
      );
    }
  }

  Future<void> saveLocation(String country, String city) async {
    if (country != "" && city != "") {
      final checkDoc = await _db
          .collection('User')
          .doc(auth.currentUser?.uid)
          .get();
      if(checkDoc.exists) {
        await _db
            .collection('User')
            .doc(auth.currentUser?.uid)
            .update(
          {
            "city": city,
            "country": country,
          },
        );
      }else{
        await _db
            .collection('User')
            .doc(auth.currentUser?.uid)
            .set(
          {
            "name": "",
            "city": city,
            "country": country,
          },
        );
      }
    }
  }
}
