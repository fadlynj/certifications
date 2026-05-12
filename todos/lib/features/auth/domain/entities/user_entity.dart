// Auth domain entity — never exposes password data.
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  final int id;
  final String username;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, username, createdAt];
}
