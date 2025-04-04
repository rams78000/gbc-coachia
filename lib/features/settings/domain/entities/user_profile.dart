import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? companyName;
  final String? position;
  final String? address;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.companyName,
    this.position,
    this.address,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Copie avec modification
  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? companyName,
    String? position,
    String? address,
    String? profileImageUrl,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyName: companyName ?? this.companyName,
      position: position ?? this.position,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
  
  // Pour comparaison d'égalité
  @override
  List<Object?> get props => [
    id, 
    name, 
    email, 
    phoneNumber, 
    companyName, 
    position, 
    address, 
    profileImageUrl, 
    createdAt, 
    updatedAt
  ];
  
  // Profile vide par défaut
  factory UserProfile.empty() {
    final now = DateTime.now();
    return UserProfile(
      id: '',
      name: '',
      email: '',
      createdAt: now,
      updatedAt: now,
    );
  }
  
  // Profile exemple (pour le développement)
  factory UserProfile.example() {
    final now = DateTime.now();
    return UserProfile(
      id: '1',
      name: 'Marie Dupont',
      email: 'marie.dupont@example.com',
      phoneNumber: '+33 6 12 34 56 78',
      companyName: 'Freelance Design',
      position: 'Designer UI/UX',
      address: '15 rue des Entrepreneurs, 75015 Paris',
      profileImageUrl: 'https://i.pravatar.cc/150?img=5',
      createdAt: now.subtract(const Duration(days: 180)),
      updatedAt: now,
    );
  }
}
