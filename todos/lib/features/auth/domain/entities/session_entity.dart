// Auth domain entity — represents an active session.
import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  const SessionEntity({
    required this.token,
    required this.userId,
    required this.username,
    required this.expiresAt,
  });

  final String token;
  final int userId;
  final String username;
  final DateTime expiresAt;

  bool get isExpired => expiresAt.isBefore(DateTime.now());

  @override
  List<Object?> get props => [token, userId, username, expiresAt];
}
