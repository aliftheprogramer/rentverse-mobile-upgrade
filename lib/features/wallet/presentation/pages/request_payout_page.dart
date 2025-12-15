import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/wallet/domain/usecase/request_payout_usecase.dart';
import 'package:rentverse/features/wallet/presentation/cubit/payout_cubit.dart';

class RequestPayoutPage extends StatefulWidget {
  const RequestPayoutPage({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (_) => PayoutCubit(sl<RequestPayoutUseCase>()),
      child: const RequestPayoutPage(),
    );
  }

  @override
  State<RequestPayoutPage> createState() => _RequestPayoutPageState();
}

class _RequestPayoutPageState extends State<RequestPayoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _accountNoCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _bankCtrl.dispose();
    _accountNoCtrl.dispose();
    _accountNameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Amount must be a number';
    if (parsed < 50000) return 'Minimum withdrawal is 50,000';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Payout')),
      body: BlocConsumer<PayoutCubit, PayoutState>(
        listener: (context, state) {
          if (state.status == PayoutStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.status == PayoutStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final loading = state.status == PayoutStatus.loading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: 'Rp ',
                    ),
                    validator: _validateAmount,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bankCtrl,
                    decoration: const InputDecoration(labelText: 'Bank Name'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Bank name required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountNoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Account Number',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Account number required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Account Name',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Account name required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
                              final params = RequestPayoutParams(
                                amount: int.parse(_amountCtrl.text.trim()),
                                bankName: _bankCtrl.text.trim(),
                                accountNo: _accountNoCtrl.text.trim(),
                                accountName: _accountNameCtrl.text.trim(),
                                notes: _notesCtrl.text.trim().isEmpty
                                    ? null
                                    : _notesCtrl.text.trim(),
                              );
                              context.read<PayoutCubit>().submit(params);
                            },
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Request'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
