// Data model — mirrors the drift-generated `User` row.
// Kept separate from the domain entity to respect the Clean Architecture boundary.
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String username;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, username, createdAt];
}
