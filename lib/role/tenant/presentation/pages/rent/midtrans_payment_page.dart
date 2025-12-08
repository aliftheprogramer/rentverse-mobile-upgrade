import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/role/tenant/presentation/widget/midtrans/card_property.dart';
import 'package:rentverse/role/tenant/presentation/widget/receipt_booking/property_rent_details.dart';
import 'package:url_launcher/url_launcher.dart';

class MidtransPaymentPage extends StatefulWidget {
  const MidtransPaymentPage({
    super.key,
    required this.booking,
    required this.redirectUrl,
  });

  final BookingResponseEntity booking;
  final String redirectUrl;

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  String _selectedOnline = 'Online Virtual Account';
  String _selectedBank = 'Bank BRI';
  String _selectedAtm = 'ATM Virtual Account';

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final billingPeriodLabel = booking.billingPeriod?.label ?? 'Monthly';
    final priceLabel = _formatCurrency(booking.amount, booking.currency);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardProperty(
              property: booking.property,
              billingPeriod: billingPeriodLabel,
              startDate: booking.checkIn,
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Property & Rent Details',
              child: PropertyRentDetailsCard(
                location: booking.property?.address ?? '-',
                startDate: _fmtDate(booking.checkIn),
                billingPeriod: billingPeriodLabel,
                propertyType: booking.property?.title ?? '-',
                priceLabel: priceLabel,
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Select Payment Method',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Online Banking',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _MethodTile(
                    title: 'Online Virtual Account',
                    isSelected: _selectedOnline == 'Online Virtual Account',
                    onTap: () => setState(
                      () => _selectedOnline = 'Online Virtual Account',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DropdownMethod(
                    value: _selectedBank,
                    items: const ['Bank BRI', 'Bank Mandiri', 'Bank BCA'],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedBank = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ATM',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _MethodTile(
                    title: 'ATM Virtual Account',
                    isSelected: _selectedAtm == 'ATM Virtual Account',
                    onTap: () =>
                        setState(() => _selectedAtm = 'ATM Virtual Account'),
                  ),
                  const SizedBox(height: 8),
                  _MethodTile(
                    title: 'ATM',
                    isSelected: _selectedAtm == 'ATM',
                    onTap: () => setState(() => _selectedAtm = 'ATM'),
                  ),
                  const SizedBox(height: 8),
                  _MethodTile(
                    title: 'ATM Virtual Account',
                    isSelected: _selectedAtm == 'ATM Virtual Account 2',
                    onTap: () =>
                        setState(() => _selectedAtm = 'ATM Virtual Account 2'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                priceLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF00B0FF),
                ),
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1CD8D2), Color(0xFF0097F6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _launchPayment,
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchPayment() async {
    final uri = Uri.tryParse(widget.redirectUrl);
    if (uri == null) {
      _showSnack('Invalid payment URL');
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnack('Cannot open payment link');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00B0FF)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? const Color(0xFF00B0FF) : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMethod extends StatelessWidget {
  const _DropdownMethod({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

String _fmtDate(DateTime? date) {
  if (date == null) return '-';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _formatCurrency(int amount, String currency) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: currency.isEmpty ? 'Rp ' : '$currency ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
