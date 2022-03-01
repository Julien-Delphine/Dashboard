/// Stores user's uid
class AppUser {
  final String uid;

  AppUser(this.uid);
}

/// Objects containing user information
class AppUserData {
  /// User email
  final String email;
  /// true if user is subscribed, false if not
  final String movieService;
  /// true if user is subscribed, false if not
  final String redditService;
  /// uid
  final String uid;
  /// true if user is subscribed, false if not
  final String weatherService;

  AppUserData({required this.email, required this.movieService, required this.redditService, required this.uid, required this.weatherService});
}