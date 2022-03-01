/// This class will hold all of the user's information. Before sending them to the database
class UserModel {
  String? uid;
  String? email;
  String? redditService;
  String? movieService;
  String? weatherService;


  UserModel({this.uid, this.email, this.redditService, this.movieService, this.weatherService});

  factory UserModel.fromMap(map) {
    return UserModel(uid: map['uid'], email: map['email'], redditService: map['redditService'], movieService: map['movieService'], weatherService: map['weatherService']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'redditService': redditService,
      'movieService': movieService,
      'weatherService': weatherService
    };
  }
}