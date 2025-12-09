import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/role/lanlord/cubit/property/cubit.dart';
import 'package:rentverse/role/lanlord/cubit/property/state.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';

class ListingTab extends StatelessWidget {
  const ListingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandlordPropertyCubit, LandlordPropertyState>(
      builder: (context, state) {
        if (state.status == LandlordPropertyStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LandlordPropertyStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error ?? 'Failed to load properties'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<LandlordPropertyCubit>().load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final listings = state.items.where((item) => item.isVerified).toList();

        if (listings.isEmpty) {
          return const EmptyState(message: 'No listings yet');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: listings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = listings[index];
            return PropertyCard(item: item);
          },
        );
      },
    );
  }
}
