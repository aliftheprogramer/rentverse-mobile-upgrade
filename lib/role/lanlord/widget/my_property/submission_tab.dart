import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/role/lanlord/cubit/property/cubit.dart';
import 'package:rentverse/role/lanlord/cubit/property/state.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';

class SubmissionTab extends StatelessWidget {
  const SubmissionTab({super.key});

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

        if (state.items.isEmpty) {
          return const EmptyState(message: 'No submissions yet');
        }

        final submissions = state.items
            .where((item) => !item.isVerified)
            .toList();

        if (submissions.isEmpty) {
          return const EmptyState(message: 'No submissions yet');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: submissions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = submissions[index];
            return PropertyCard(item: item, showStatusBadge: false);
          },
        );
      },
    );
  }
}
