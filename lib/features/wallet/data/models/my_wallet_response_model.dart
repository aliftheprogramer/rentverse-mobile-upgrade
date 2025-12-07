import 'package:rentverse/features/wallet/domain/entity/my_wallet_response_entity.dart';

class MyWalletResponseModel {
  final WalletModel data;

  MyWalletResponseModel({required this.data});

  factory MyWalletResponseModel.fromJson(Map<String, dynamic> json) {
    return MyWalletResponseModel(
      data: WalletModel.fromJson((json['data'] as Map<String, dynamic>? ?? {})),
    );
  }

  WalletEntity toEntity() => data.toEntity();
}

class WalletModel {
  final String id;
  final String userId;
  final String balance;
  final String currency;
  final DateTime? updatedAt;
  final List<WalletTransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.updatedAt,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final txs = (json['transactions'] as List<dynamic>? ?? [])
        .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return WalletModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      balance: json['balance']?.toString() ?? '0',
      currency: json['currency'] as String? ?? '',
      updatedAt: _parseDate(json['updatedAt'] as String?),
      transactions: txs,
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      updatedAt: updatedAt,
      transactions: transactions.map((e) => e.toEntity()).toList(),
    );
  }
}

class WalletTransactionModel {
  final String id;
  final String? type;
  final String? amount;
  final String? currency;
  final String? description;
  final DateTime? createdAt;

  WalletTransactionModel({
    required this.id,
    this.type,
    this.amount,
    this.currency,
    this.description,
    this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String?,
      amount: json['amount']?.toString(),
      currency: json['currency'] as String?,
      description: json['description'] as String?,
      createdAt: _parseDate(json['createdAt'] as String?),
    );
  }

  WalletTransactionEntity toEntity() {
    return WalletTransactionEntity(
      id: id,
      type: type,
      amount: amount,
      currency: currency,
      description: description,
      createdAt: createdAt,
    );
  }
}

DateTime? _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}
