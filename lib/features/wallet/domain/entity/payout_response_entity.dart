class PayoutResponseEntity {
  final String id;
  final String walletId;
  final String amount;
  final String status;
  final String bankName;
  final String accountNo;
  final String accountName;
  final String? notes;
  final DateTime? createdAt;

  const PayoutResponseEntity({
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
}
