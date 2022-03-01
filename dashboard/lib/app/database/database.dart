import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/app/database/users.dart';

/// This class allows to get and send infotmation to the Firestore Database
class DatabaseService {
  /// String containing user uid
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");

  /// Save user's information
  Future<void> saveUser(String email, String movieService, String redditService, String uid, String weatherService) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'movieService': movieService,
      'redditService': redditService,
      'uid': uid,
      'weatherService': weatherService,
    });
  }

  /// Get user's information as Model AppUserData
  AppUserData _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("User not found.");
    return AppUserData(
      email: data['email'],
      movieService: data['movieService'],
      redditService: data['redditService'],
      uid: snapshot.id,
      weatherService: data['weatherService']
    );
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
}