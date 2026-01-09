import 'package:crm_app/core/models/enquiry_model.dart';
import 'package:crm_app/core/services/pdf_export_service.dart';
import 'package:crm_app/features/admin/dashboard/enquiry_provider/enquiry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'users_screen.dart'; // Ensure you have this file created from previous steps

class EnquiriesDashboardScreen extends StatefulWidget {
  const EnquiriesDashboardScreen({super.key});

  @override
  State<EnquiriesDashboardScreen> createState() => _EnquiriesDashboardScreenState();
}

class _EnquiriesDashboardScreenState extends State<EnquiriesDashboardScreen> {
  // Key to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Scroll Controller for Pagination
  final ScrollController _scrollController = ScrollController();

  // Colors
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color drawerBlue = const Color(0xFF4285F4);
  final Color bgGrey = const Color(0xFFF8F9FA);
  final Color greenAccent = const Color(0xFF4CAF50);
  final Color orangeAccent = const Color(0xFFFFB74D);
  final Color cardBgCream = const Color(0xFFFFF8E1);

  @override
  void initState() {
    super.initState();
    
    // 1. Fetch Initial Data (List + Counts)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnquiryProvider>(context, listen: false).fetchData(isRefresh: true);
    });
    
    // 2. Add Scroll Listener for Pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        Provider.of<EnquiryProvider>(context, listen: false).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  // Helper to map API date filter to Readable String for PDF
  String _getReadableFilterName(String apiValue) {
    switch (apiValue) {
      case 'today': return 'Today';
      case 'week': return 'This Week';
      case 'month': return 'This Month';
      default: return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      backgroundColor: bgGrey,
      
      // --- SIDEBAR DRAWER ---
      drawer: _buildDrawer(),
      
      body: Consumer<EnquiryProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // ===============================================
              // 1. TOP BLUE SECTION (STATS)
              // ===============================================
              Container(
                color: primaryBlue,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                child: Column(
                  children: [
                    // --- App Bar ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const Text(
                          "Enquiries",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                          onPressed: () {}, // Notification logic
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // --- Main Stat: Total Enquiries (Dynamic) ---
                    _buildClickableStatCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_today, color: Colors.white),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getFilterLabel(provider.currentDateFilter), 
                                style: const TextStyle(color: Colors.white70, fontSize: 12)
                              ),
                              const SizedBox(height: 4),
                              // DYNAMIC TOTAL COUNT
                              Text(
                                "${provider.summary.totalEnquiries}", 
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                              ),
                            ],
                          )
                        ],
                      ),
                      onTap: () {}, // Can add specific filter action
                    ),
                    const SizedBox(height: 15),

                    // --- Sub Stats: Students & Clients (Dynamic) ---
                    Row(
                      children: [
                        Expanded(
                          child: _buildClickableStatCard(
                            child: _buildStatSmallContent(
                              Icons.school, 
                              "Students", 
                              "${provider.summary.students}" // Dynamic
                            ),
                            onTap: () => provider.setEnquiryType('Student'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildClickableStatCard(
                            child: _buildStatSmallContent(
                              Icons.business, 
                              "Clients", 
                              "${provider.summary.clients}" // Dynamic
                            ),
                            onTap: () => provider.setEnquiryType('Client'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ===============================================
              // 2. SCROLLABLE CONTENT (FILTERS + LIST)
              // ===============================================
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => provider.fetchData(isRefresh: true),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Filter & Sort Card ---
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                                        child: Icon(Icons.tune, color: primaryBlue),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Filter & Sort", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Text("Refine your results", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Export Button
                                                                    GestureDetector(
                                    onTap: () async {
                                      // Trigger PDF Generation
                                      if (provider.enquiries.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("No data to export"))
                                        );
                                        return;
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Generating PDF..."))
                                      );

                                      try {
                                        await PdfExportService.generateAndPrintPdf(
                                          data: provider.enquiries,
                                          timeFilter: _getReadableFilterName(provider.currentDateFilter),
                                          typeFilter: provider.currentEnquiryType,
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Error: $e"))
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(color: greenAccent, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.download, color: Colors.white, size: 16),
                                          SizedBox(width: 5),
                                          Text("Export", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(),

                              // --- Time Period Filters ---
                              _buildSectionTitle(Icons.access_time, "Time Period"),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10, runSpacing: 10,
                                children: [
                                  _buildFilterChip("All", provider.currentDateFilter == 'all', () => provider.setDateFilter('All')),
                                  _buildFilterChip("Today", provider.currentDateFilter == 'today', () => provider.setDateFilter('Today')),
                                  _buildFilterChip("This Week", provider.currentDateFilter == 'week', () => provider.setDateFilter('This Week')),
                                  _buildFilterChip("This Month", provider.currentDateFilter == 'month', () => provider.setDateFilter('This Month')),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // --- Enquiry Type Filters ---
                              _buildSectionTitle(Icons.category, "Enquiry Type"),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10, runSpacing: 10,
                                children: [
                                  _buildFilterChip("All Types", provider.currentEnquiryType == 'All Types', () => provider.setEnquiryType('All Types')),
                                  _buildFilterChip("Student", provider.currentEnquiryType == 'Student', () => provider.setEnquiryType('Student'), icon: Icons.school_outlined),
                                  _buildFilterChip("Client", provider.currentEnquiryType == 'Client', () => provider.setEnquiryType('Client'), icon: Icons.business_outlined),
                                  _buildFilterChip("Other", provider.currentEnquiryType == 'Other', () => provider.setEnquiryType('Other'), icon: Icons.help_outline),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              const Divider(),
                              
                              // Results & Reset
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: greenAccent, size: 20),
                                      const SizedBox(width: 5),
                                      // Dynamic count from pagination total
                                      // (Assuming totalCount is exposed in provider, otherwise use enquiries.length)
                                      Text("${provider.enquiries.length} shown", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Reset Filters
                                      provider.setDateFilter('Today');
                                      provider.setEnquiryType('All Types');
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.refresh, color: Colors.red, size: 20),
                                        SizedBox(width: 5),
                                        Text("Reset", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),
                        const Text("All Enquiries", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),

                        // --- Enquiry List ---
                        if (provider.isLoading && provider.enquiries.isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
                        else if (provider.enquiries.isEmpty)
                           const Center(child: Padding(padding: EdgeInsets.all(30), child: Text("No enquiries found.")))
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Scroll handled by parent
                            itemCount: provider.enquiries.length + (provider.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Loading Spinner at bottom
                              if (index == provider.enquiries.length) {
                                return const Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()));
                              }
                              
                              final enquiry = provider.enquiries[index];
                              return _buildEnquiryCard(enquiry);
                            },
                          ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  // 1. Enquiry Card Item
  Widget _buildEnquiryCard(EnquiryModel enquiry) {
    // Logic for Client vs Student display
    final bool isClient = enquiry.enquiryType.toLowerCase() == 'client';
    final Color typeColor = isClient ? Colors.orange : const Color(0xFF5B8BD9);
    final IconData typeIcon = isClient ? Icons.apartment : Icons.school;
    
    // Fallback for Service/Course
    String workInfo = "General Inquiry";
    if (enquiry.service != null) workInfo = enquiry.service!;
    if (enquiry.course != null) workInfo = enquiry.course!;
    
    IconData workIcon = isClient ? Icons.work_outline : Icons.menu_book;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Cream/Peach background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
             // Show message in snackbar for demo
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message: ${enquiry.message}")));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Icon + Name + Type
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(typeIcon, color: typeColor),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(enquiry.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              enquiry.enquiryType.toUpperCase(), 
                              style: TextStyle(color: typeColor, fontSize: 10, fontWeight: FontWeight.bold)
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                
                // Phone
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(enquiry.phone, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 10),

                // Course/Service Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(workIcon, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          workInfo, 
                          style: const TextStyle(color: Colors.black87, fontSize: 12), 
                          overflow: TextOverflow.ellipsis
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(color: Colors.black12),
                const SizedBox(height: 5),

                // Footer: Email + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                       child: Row(
                         children: [
                           const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                           const SizedBox(width: 4),
                           Flexible(
                             child: Text(
                               enquiry.email, 
                               style: const TextStyle(color: Colors.grey, fontSize: 12), 
                               overflow: TextOverflow.ellipsis
                             )
                           ),
                         ],
                       ),
                     ),
                     Row(
                       children: [
                         const Icon(Icons.access_time, size: 16, color: Colors.grey),
                         const SizedBox(width: 4),
                         Text(_formatDate(enquiry.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                       ],
                     ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 2. Sidebar Drawer
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: drawerBlue,
      elevation: 0,
      width: 280, 
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 35),
            ),
            const SizedBox(height: 15),
            const Text(
              "Admin Panel",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),

            // Item 1: Enquiries (Active)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                  title: const Text(
                    "Enquiries",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Item 2: Users
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: const Icon(Icons.people_alt_rounded, color: Colors.white),
                title: const Text(
                  "Users",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  // Navigate to UsersScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsersScreen()),
                  );
                },
              ),
            ),

            const Spacer(),
              
              
            // Footer
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            //   child: Container(
            //     padding: const EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.15),
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           height: 45,
            //           width: 45,
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.circle,
            //           ),
            //           child: Icon(Icons.person, color: drawerBlue, size: 24),
            //         ),
            //         const SizedBox(width: 12),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisSize: MainAxisSize.min,
            //           children: const [
            //             Text(
            //               "Admin",
            //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            //             ),
            //             Text(
            //               "admin@example.com",
            //               style: TextStyle(color: Colors.white70, fontSize: 11),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // 3. Filter Chip
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap, {IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? null : Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Stat Card Container
  Widget _buildClickableStatCard({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
          child: child,
        ),
      ),
    );
  }

  // 5. Stat Card Content
  Widget _buildStatSmallContent(IconData icon, String title, String count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  // 6. Section Title
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  // 7. Date Text Logic
  String _getFilterLabel(String apiValue) {
    if (apiValue == 'today') return "Today's Enquiries";
    if (apiValue == 'week') return "This Week's Enquiries";
    if (apiValue == 'month') return "This Month's Enquiries";
    return "Total Enquiries";
  }

  // 8. Date Formatter
  String _formatDate(String isoString) {
    try {
      if (isoString.isEmpty) return "";
      DateTime date = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inHours < 24) {
        return "${diff.inHours} hrs ago";
      }
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "";
    }
  }
}