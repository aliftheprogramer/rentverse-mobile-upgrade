class WalletEntity {
  final String id;
  final String userId;
  final String balance;
  final String currency;
  final DateTime? updatedAt;
  final List<WalletTransactionEntity> transactions;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.updatedAt,
    required this.transactions,
  });
}

class WalletTransactionEntity {
  final String id;
  final String? type;
  final String? amount;
  final String? currency;
  final String? description;
  final DateTime? createdAt;

  const WalletTransactionEntity({
    required this.id,
    this.type,
    this.amount,
    this.currency,
    this.description,
    this.createdAt,
  });
}
