// lib/features/auth/data/models/request/login_request_model.dart

import 'package:rentverse/features/auth/domain/entity/login_request_entity.dart';

class LoginRequestModel extends LoginRequestEntity {
  LoginRequestModel({required super.email, required super.password});

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(email: entity.email, password: entity.password);
  }

  // Mapper: Mengubah Model menjadi Map/JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
