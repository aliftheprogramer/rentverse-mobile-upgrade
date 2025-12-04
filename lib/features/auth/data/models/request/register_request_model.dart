// lib/features/auth/data/models/request/register_request_model.dart

import 'package:rentverse/features/auth/domain/entity/register_request_enity.dart';

class RegisterRequestModel extends RegisterRequestEntity {
  RegisterRequestModel({
    required super.email,
    required super.password,
    required super.name,
    required super.phone,
    required super.role,
    // Parameter lain sesuai kebutuhan
  });

  factory RegisterRequestModel.fromEntity(RegisterRequestEntity entity) {
    return RegisterRequestModel(
      email: entity.email,
      password: entity.password,
      name: entity.name,
      phone: entity.phone,
      role: entity.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'role': role,
      // Contoh translasi:
      // 'phone_number': phone (Jika API minta snake_case)
    };
  }
}
