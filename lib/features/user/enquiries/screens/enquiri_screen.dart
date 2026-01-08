import 'package:crm_app/core/theme/app_theme.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'week';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnquiriProvider>(context, listen: false).fetchEnquiries(refresh: true, filter: _selectedFilter);
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<EnquiriProvider>(context, listen: false).fetchEnquiries(filter: _selectedFilter);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String value) {
    setState(() {
      _selectedFilter = value;
    });
    Provider.of<EnquiriProvider>(context, listen: false).fetchEnquiries(refresh: true, filter: value == 'all' ? '' : value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search enquires...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.filter_list, color: AppTheme.primaryBlue),
                    onSelected: _onFilterChanged,
                    
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(value: 'week', child: Text('Week')),
                      const PopupMenuItem<String>(value: 'month', child: Text('Month')),
                      const PopupMenuItem<String>(value: 'year', child: Text('Year')),
                      const PopupMenuItem<String>(value: 'all', child: Text('Time')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<EnquiriProvider>(
              builder: (context, provider, child) {
               
                final filteredList = provider.enquiries.where((e) {
                  final query = _searchQuery;
                  if (query.isEmpty) return true;
                  return e.name.toLowerCase().contains(query) ||
                         e.enquiryType.toLowerCase().contains(query) ||
                         (e.course != null && e.course!.toLowerCase().contains(query));
                }).toList();

                if (provider.isLoading && provider.enquiries.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (filteredList.isEmpty) {
                   if (provider.isLoading) {
                     return const Center(child: CircularProgressIndicator());
                   }
                  return const Center(
                    child: Text(
                      'No enquiries found',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => provider.fetchEnquiries(refresh: true, filter: _selectedFilter == 'all' ? '' : _selectedFilter),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredList.length + (provider.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == filteredList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final enquiry = filteredList[index];
                      
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
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
                                Expanded(
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
                                    color: AppTheme.primaryBlueLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    enquiry.enquiryType,
                                    style: const TextStyle(
                                      color: AppTheme.primaryBlueText,
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
          ),
        ],
      ),
    );
  }
}