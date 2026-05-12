// Data model for a session row.
import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  const SessionModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.token,
    required this.expiresAt,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String username;
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, token];
}
