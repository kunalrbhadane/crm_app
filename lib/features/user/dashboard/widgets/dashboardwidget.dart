import 'package:crm_app/core/providers/navigation_provider.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/features/user/dashboard/provider/dashboard_provider.dart';
import 'package:crm_app/features/user/enquiries/screens/new_enquiry_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class DashboardHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue, 
      elevation: 0,
      title: const Text(
        'My Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class WelcomeHeaderWidget extends StatelessWidget {
  final String userName;
  const WelcomeHeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      height: 290,
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.primaryBlue, 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          const Text(
            'Welcome back,',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCardWidget extends StatelessWidget {
  final bool isLoading;
  final Map<String, dynamic>? summary;

  const StatsCardWidget({
    super.key,
    required this.isLoading,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    // We get the counts from the summary map, providing '0' as a default.
    // The API response summary keys are assumed here.
    // Helper to get count from multiple potential keys
    String getCount(List<String> keys) {
      for (final key in keys) {
        if (summary?.containsKey(key) == true) {
          return (summary![key] ?? 0).toString();
        }
      }
      return '0';
    }

    final totalCount = getCount(['totalEnquiries', 'total', 'all']);
    final clientCount = getCount(['clientEnquiries', 'clients', 'client_count', 'client']);
    final studentCount = getCount(['studentEnquiries', 'students', 'student_count', 'student']);

    return Container(
      width: 360,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 107, 153, 232),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            width: 1.5, color: const Color.fromARGB(110, 191, 209, 234)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCounter('Total', isLoading ? '' : totalCount, Icons.list_alt_outlined, isLoading),
          _buildVerticalDivider(),
          _buildCounter('Client', isLoading ? '' : clientCount, Icons.business_outlined, isLoading),
          _buildVerticalDivider(),
          _buildCounter('Student', isLoading ? '' : studentCount, Icons.school_outlined, isLoading),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  // MODIFIED: _buildCounter now handles the loading state
  Widget _buildCounter(String label, String count, IconData icon, bool isLoading) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        if (isLoading)
          // Show a small loading indicator while fetching
          const SizedBox(
            height: 28, // Matches text height
            width: 28,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.0,
            ),
          )
        else
          // Show the count when loaded
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // MODIFIED: Added onTap navigation
          Expanded(
            child: _actionButton(
              context: context,
              icon: Icons.add,
              label: 'New Enquiry',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewEnquiryScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _actionButton(
              context: context,
              icon: Icons.history,
              label: 'History',
              onTap: () {}, // No action yet for History
            ),
          ),
        ],
      ),
    );
  }

  // MODIFIED: _actionButton is now wrapped in an InkWell and takes onTap
  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryBlueLight,
              child: Icon(icon, color: Colors.blueAccent, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class EnquiriesSectionWidget extends StatelessWidget {
  const EnquiriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Enquiries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<NavigationProvider>(context, listen: false).setIndex(1);
                },
                child:
                    const Text('View All', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                 return const Center(child: CircularProgressIndicator());
              }
              
              if (provider.enquiries.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      'No enquiries found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.enquiries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
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
                            Text(
                              enquiry.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
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
                         if (enquiry.enquiryType.toLowerCase() == 'other' && enquiry.notes != null && enquiry.notes!.isNotEmpty)
                        Text(
                          "Details: ${enquiry.notes}",
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),

                        if (enquiry.course != null)
                           Text(
                            "Course: ${enquiry.course}",
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
              );
            },
          )
        ],
      ),
    );
  }
}