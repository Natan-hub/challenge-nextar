class UserModel {
  final String email;
  final String name;
  final int id;

  UserModel({
    required this.email,
    required this.name,
    required this.id,
  });

  // Método para criar um objeto UserModel a partir do Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      id: data['id'] ?? 0,
    );
  }
}
