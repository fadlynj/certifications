// Maps between drift-generated User rows and UserModel / UserEntity.
import 'package:drift/drift.dart' show Value;

import '../../../../database/app_database.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  const UserMapper._();

  // Drift row → data model
  static UserModel fromRow(User row) => UserModel(
    id: row.id,
    username: row.username,
    passwordHash: row.passwordHash,
    salt: row.salt,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  // Data model → domain entity (strips sensitive fields)
  static UserEntity toEntity(UserModel model) => UserEntity(
    id: model.id,
    username: model.username,
    createdAt: model.createdAt,
  );

  // Domain data → Drift companion for insert
  static UsersCompanion toInsertCompanion({
    required String username,
    required String passwordHash,
    required String salt,
  }) => UsersCompanion.insert(
    username: username,
    passwordHash: passwordHash,
    salt: salt,
  );

  // Domain data → Drift companion for update (password change)
  static UsersCompanion toUpdatePasswordCompanion({
    required int id,
    required String newPasswordHash,
    required String newSalt,
  }) => UsersCompanion(
    id: Value(id),
    passwordHash: Value(newPasswordHash),
    salt: Value(newSalt),
    updatedAt: Value(DateTime.now()),
  );
}
