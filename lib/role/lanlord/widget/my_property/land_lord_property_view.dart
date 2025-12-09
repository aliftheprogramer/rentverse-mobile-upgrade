import 'package:flutter/material.dart';
import 'package:rentverse/role/lanlord/widget/my_property/listing_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/submission_tab.dart';

class LandLordPropertyView extends StatelessWidget {
  const LandLordPropertyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'My Property',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
        bottom: const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Color(0xFF1CD8D2),
          labelColor: Color(0xFF1CD8D2),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: 'Submission'),
            Tab(text: 'My Listing'),
            Tab(text: 'Request'),
            Tab(text: 'Payment'),
          ],
        ),
      ),
      body: TabBarView(
        children: const [
          SubmissionTab(),
          ListingTab(),
          _PlaceholderTab(label: 'Request'),
          _PlaceholderTab(label: 'Payment'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1CD8D2),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$label is coming soon'));
  }
}
