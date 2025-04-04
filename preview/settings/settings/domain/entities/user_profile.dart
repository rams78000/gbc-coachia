/// Entité représentant le profil de l'utilisateur
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? company;
  final String? position;
  final String? address;
  final DateTime registrationDate;
  final DateTime? lastLoginDate;
  final Map<String, dynamic>? additionalInfo;
  
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.company,
    this.position,
    this.address,
    required this.registrationDate,
    this.lastLoginDate,
    this.additionalInfo,
  });
  
  /// Copie le profil avec de nouvelles valeurs
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    String? company,
    String? position,
    String? address,
    DateTime? registrationDate,
    DateTime? lastLoginDate,
    Map<String, dynamic>? additionalInfo,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      company: company ?? this.company,
      position: position ?? this.position,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
