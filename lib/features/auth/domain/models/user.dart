import 'package:equatable/equatable.dart';

/// App User Model
class AppUser extends Equatable {
  /// Constructor
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
  });

  /// Unique Identifier
  final String uid;
  
  /// Email address
  final String? email;
  
  /// Display name
  final String? displayName;
  
  /// Profile photo URL
  final String? photoURL;
  
  /// Is email verified
  final bool emailVerified;

  /// Create empty user
  factory AppUser.empty() => const AppUser(uid: '');

  /// Copy with
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  List<Object?> get props => [uid, email, displayName, photoURL, emailVerified];
}
