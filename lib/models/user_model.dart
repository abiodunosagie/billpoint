/// USER MODEL
/// This class represents a User object in your app
/// Think of it as a blueprint for user data
///
/// WHY DO WE NEED THIS?
/// - APIs send/receive JSON data (like {"name": "John", "email": "john@email.com"})
/// - We need to convert JSON to Dart objects (and vice versa)
/// - This makes it easy to work with user data in your app

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.address,
    this.profileImage,
  });

  /// FROM JSON - Convert API response to UserModel object
  ///
  /// When API returns: {"id": "123", "username": "john", "email": "john@email.com"}
  /// This method converts it to: UserModel object you can use in your app
  ///
  /// Example usage:
  /// ```
  /// Map<String, dynamic> json = {"id": "123", "username": "john"};
  /// UserModel user = UserModel.fromJson(json);
  /// print(user.username); // Output: john
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '', // Handle different API response formats
      username: json['username'] ?? json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      address: json['address'],
      profileImage: json['profileImage'] ?? json['avatar'],
    );
  }

  /// TO JSON - Convert UserModel object to JSON
  ///
  /// When you need to SEND data to API:
  /// UserModel user = UserModel(username: "john", email: "john@email.com");
  /// Map<String, dynamic> json = user.toJson();
  /// // Now you can send 'json' to the API
  ///
  /// Returns: {"username": "john", "email": "john@email.com"}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImage': profileImage,
    };
  }

  /// EMPTY USER - Useful for initial state
  /// When app starts and no user is logged in yet
  static UserModel empty() {
    return UserModel(
      id: '',
      username: '',
      email: '',
    );
  }

  /// Copy With - Create a new user object with some fields changed
  /// Useful for updating user data without modifying the original
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? address,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
