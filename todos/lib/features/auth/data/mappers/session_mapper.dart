// Maps between drift Session rows, SessionModel and SessionEntity.
import '../../../../database/app_database.dart';
import '../../domain/entities/session_entity.dart';
import '../models/session_model.dart';

class SessionMapper {
  const SessionMapper._();

  /// Drift row + username (joined) → data model
  static SessionModel fromRow(Session row, String username) => SessionModel(
    id: row.id,
    userId: row.userId,
    username: username,
    token: row.token,
    expiresAt: row.expiresAt,
    createdAt: row.createdAt,
  );

  /// Data model → domain entity
  static SessionEntity toEntity(SessionModel model) => SessionEntity(
    token: model.token,
    userId: model.userId,
    username: model.username,
    expiresAt: model.expiresAt,
  );

  /// Data needed to insert a new session row
  static SessionsCompanion toInsertCompanion({
    required int userId,
    required String token,
    required DateTime expiresAt,
  }) => SessionsCompanion.insert(
    userId: userId,
    token: token,
    expiresAt: expiresAt,
  );
}
