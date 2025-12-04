//lib/features/auth/data/models/response/user_model.dart

import 'package:rentverse/features/auth/domain/entity/user_entity.dart';

import 'profile_model.dart';
import 'role_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phone,
    super.avatarUrl,
    required super.isVerified,
    super.createdAt,
    super.roles,
    super.tenantProfile,
    super.landlordProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,

      // Parse DateTime
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      // Parse List Roles
      roles: json['roles'] != null
          ? (json['roles'] as List)
                .map((e) => UserRoleModel.fromJson(e))
                .toList()
          : null,

      // Parse Tenant Profile (Nullable)
      tenantProfile: json['tenantProfile'] != null
          ? TenantProfileModel.fromJson(json['tenantProfile'])
          : null,

      // Parse Landlord Profile (Nullable)
      landlordProfile: json['landlordProfile'] != null
          ? LandlordProfileModel.fromJson(json['landlordProfile'])
          : null,
    );
  }

  // Penting untuk menyimpan user session ke SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),

      // Convert list roles ke json
      'roles': roles?.map((e) => (e as UserRoleModel).toJson()).toList(),

      // Convert profiles ke json
      'tenantProfile': tenantProfile != null
          ? (tenantProfile as TenantProfileModel).toJson()
          : null,
      'landlordProfile': landlordProfile != null
          ? (landlordProfile as LandlordProfileModel).toJson()
          : null,
    };
  }
}
