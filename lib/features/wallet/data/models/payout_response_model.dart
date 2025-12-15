import 'package:rentverse/features/wallet/domain/entity/payout_response_entity.dart';

class PayoutResponseModel {
  final PayoutModel data;

  PayoutResponseModel({required this.data});

  factory PayoutResponseModel.fromJson(Map<String, dynamic> json) {
    return PayoutResponseModel(
      data: PayoutModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  PayoutResponseEntity toEntity() => data.toEntity();
}

class PayoutModel {
  final String id;
  final String walletId;
  final String amount;
  final String status;
  final String bankName;
  final String accountNo;
  final String accountName;
  final String? notes;
  final DateTime? createdAt;

  PayoutModel({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.status,
    required this.bankName,
    required this.accountNo,
    required this.accountName,
    this.notes,
    this.createdAt,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'] as String? ?? '',
      walletId: json['walletId'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0',
      status: json['status'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      accountNo: json['accountNo'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: _parseDate(json['createdAt'] as String?),
    );
  }

  PayoutResponseEntity toEntity() {
    return PayoutResponseEntity(
      id: id,
      walletId: walletId,
      amount: amount,
      status: status,
      bankName: bankName,
      accountNo: accountNo,
      accountName: accountName,
      notes: notes,
      createdAt: createdAt,
    );
  }
}

DateTime? _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}
