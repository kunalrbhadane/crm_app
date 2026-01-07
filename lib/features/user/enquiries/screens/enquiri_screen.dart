import 'package:crm_app/features/user/enquiries/provider/enquiri_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EnquiriScreen extends StatefulWidget {
  const EnquiriScreen({super.key});

  @override
  State<EnquiriScreen> createState() => _EnquiriScreenState();
}

class _EnquiriScreenState extends State<EnquiriScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnquiriProvider>(context, listen: false).fetchEnquiries(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<EnquiriProvider>(context, listen: false).fetchEnquiries();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Consumer<EnquiriProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.enquiries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.enquiries.isEmpty) {
            return const Center(
              child: Text(
                'No enquiries found',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchEnquiries(refresh: true),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: provider.enquiries.length + (provider.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == provider.enquiries.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final enquiry = provider.enquiries[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded( // Added to prevent overflow if name is long
                            child: Text(
                              enquiry.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              enquiry.enquiryType,
                              style: const TextStyle(
                                color: Color(0xFF1976D2),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (enquiry.message.isNotEmpty) ...[
                        Text(
                          enquiry.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (enquiry.course != null)
                        Text(
                          "Course: ${enquiry.course}",
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),

                      // THIS IS THE FIX: Convert to lowercase before comparing
                      if (enquiry.enquiryType.toLowerCase() == 'other' && enquiry.notes != null && enquiry.notes!.isNotEmpty)
                        Text(
                          "Details: ${enquiry.notes}",
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),

                      if (enquiry.service != null)
                        Text(
                          "Service: ${enquiry.service}",
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),

                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            enquiry.createdAt != null
                                ? DateFormat('MMM d, yyyy').format(enquiry.createdAt!)
                                : 'N/A',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}