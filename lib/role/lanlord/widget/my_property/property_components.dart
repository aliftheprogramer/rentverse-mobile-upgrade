import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/features/property/domain/entity/list_property_by_owner.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.item,
    this.showStatusBadge = true,
  });

  final OwnerPropertyEntity item;
  final bool showStatusBadge;

  @override
  Widget build(BuildContext context) {
    final priceText = _formatCurrency(item.currency, item.price);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill(isVerified: item.isVerified),
              const Spacer(),
              if (item.createdAt != null)
                Text(
                  DateFormat('dd MMM yyyy').format(item.createdAt!),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyImage(imageUrl: item.image, title: item.title),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${item.city}${item.address.isNotEmpty ? ' • ${item.address}' : ''}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$priceText /mon',
                      style: const TextStyle(
                        color: Color(0xFF00BFA6),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        InfoBadge(
                          icon: Icons.home_work_outlined,
                          label: item.type,
                        ),
                        InfoBadge(
                          icon: Icons.bookmark_added_outlined,
                          label: '${item.stats.totalBookings}',
                        ),
                        if (showStatusBadge)
                          InfoBadge(
                            icon: item.isVerified
                                ? Icons.verified
                                : Icons.verified_outlined,
                            label: item.isVerified ? 'Verified' : 'Pending',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyImage extends StatelessWidget {
  const PropertyImage({super.key, required this.imageUrl, required this.title});

  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          width: 110,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _PlaceholderBox(title: title),
        ),
      );
    }

    return _PlaceholderBox(title: title);
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final initial = title.isNotEmpty
        ? title.characters.first.toUpperCase()
        : '-';
    return Container(
      width: 110,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE7F9F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1CD8D2)),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0C7B77),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.isVerified});

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final color = isVerified
        ? const Color(0xFF1CD8D2)
        : const Color(0xFFFFC107);
    final text = isVerified ? 'Published' : 'Waiting for Admin approval';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home_work_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class InfoBadge extends StatelessWidget {
  const InfoBadge({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

String _formatCurrency(String currency, num amount) {
  try {
    final symbol = currency.toUpperCase() == 'IDR' ? 'Rp' : currency;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol.isNotEmpty ? '$symbol ' : 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  } catch (_) {
    return '$currency $amount';
  }
}
