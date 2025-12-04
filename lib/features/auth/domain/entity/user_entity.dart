// lib/features/auth/domain/entity/user_entity.dart

import 'package:equatable/equatable.dart';
import 'package:rentverse/features/auth/domain/entity/profile_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime? createdAt;

  // Relasi ke Role (List karena User bisa punya banyak role di tabel user_roles)
  final List<UserRoleEntity>? roles;

  // Profile Khusus (Nullable)
  final TenantProfileEntity? tenantProfile;
  final LandlordProfileEntity? landlordProfile;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.avatarUrl,
    required this.isVerified,
    this.createdAt,
    this.roles,
    this.tenantProfile,
    this.landlordProfile,
  });

  // --- LOGIC GETTERS (Sangat berguna untuk UI) ---

  bool get isTenant => _hasRole('TENANT');
  bool get isLandlord => _hasRole('LANDLORD');
  bool get isAdmin => _hasRole('ADMIN');

  // Helper private untuk cek nama role
  bool _hasRole(String roleName) {
    return roles?.any((r) => r.role?.name == roleName) ?? false;
  }

  // Ambil Score Trust berdasarkan Role yang sedang aktif
  double get trustScore {
    if (isTenant) return tenantProfile?.ttiScore ?? 0.0;
    if (isLandlord) return landlordProfile?.lrsScore ?? 0.0;
    return 0.0;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    isVerified,
    createdAt,
    roles,
    tenantProfile,
    landlordProfile,
  ];
}

// Entity untuk Table user_roles (Pivot)
class UserRoleEntity extends Equatable {
  final String? roleId;
  final RoleEntity? role; // Nested Role Object

  const UserRoleEntity({this.roleId, this.role});

  @override
  List<Object?> get props => [roleId, role];
}

// Entity untuk Table roles
class RoleEntity extends Equatable {
  final String? id;
  final String? name; // "TENANT", "LANDLORD", "ADMIN" [cite: 9]

  const RoleEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
