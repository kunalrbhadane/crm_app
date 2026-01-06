import 'package:crm_app/features/admin/dashboard/screens/users_screen.dart';
import 'package:flutter/material.dart';

class EnquiriesDashboardScreen extends StatefulWidget {
  const EnquiriesDashboardScreen({super.key});

  @override
  State<EnquiriesDashboardScreen> createState() => _EnquiriesDashboardScreenState();
}

class _EnquiriesDashboardScreenState extends State<EnquiriesDashboardScreen> {
  // Key to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State Variables for Filters
  String _selectedTimePeriod = 'Today';
  String _selectedEnquiryType = 'All Types';
  String _selectedRoleType = 'All Types';

  // Colors
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color drawerBlue = const Color(0xFF4285F4); // Lighter blue for drawer bg
  final Color bgGrey = const Color(0xFFF8F9FA);
  final Color greenAccent = const Color(0xFF4CAF50);
  final Color orangeAccent = const Color(0xFFFFB74D);
  final Color cardBgCream = const Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key here
      backgroundColor: bgGrey,
      
      // --- THE DRAWER (Sidebar) ---
      drawer: _buildDrawer(),
      
      body: Column(
        children: [
          // --- Top Blue Section ---
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
            child: Column(
              children: [
                // Custom App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Button - Now opens the Drawer
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
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
                      onPressed: () => _showSnack("Notifications clicked"),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Stats: Today's Enquiries
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
                        children: const [
                          Text("Today's Enquiries", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          SizedBox(height: 4),
                          Text("1", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  onTap: () => _showSnack("Opening Today's Enquiries..."),
                ),
                const SizedBox(height: 15),

                // Stats: Students & Clients
                Row(
                  children: [
                    Expanded(
                      child: _buildClickableStatCard(
                        child: _buildStatSmallContent(Icons.school, "Students", "27"),
                        onTap: () => _showSnack("Opening Students List..."),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildClickableStatCard(
                        child: _buildStatSmallContent(Icons.business, "Clients", "28"),
                        onTap: () => _showSnack("Opening Clients List..."),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Scrollable Content ---
          Expanded(
            child: SingleChildScrollView(
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
                            Material(
                              color: greenAccent,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => _showSnack("Exporting..."),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.download, color: Colors.white, size: 16),
                                      SizedBox(width: 5),
                                      Text("Export", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 10),

                        _buildSectionTitle(Icons.access_time, "Time Period"),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _buildSelectableChip("All", _selectedTimePeriod, (val) => setState(() => _selectedTimePeriod = val)),
                            _buildSelectableChip("Today", _selectedTimePeriod, (val) => setState(() => _selectedTimePeriod = val)),
                            _buildSelectableChip("This Week", _selectedTimePeriod, (val) => setState(() => _selectedTimePeriod = val)),
                            _buildSelectableChip("This Month", _selectedTimePeriod, (val) => setState(() => _selectedTimePeriod = val)),
                            ActionChip(
                              avatar: const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black54),
                              label: const Text("Select Date", style: TextStyle(color: Colors.black54, fontSize: 13)),
                              backgroundColor: const Color(0xFFF5F5F5),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildSectionTitle(Icons.category, "Enquiry Type"),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _buildSelectableChip("All Types", _selectedEnquiryType, (val) => setState(() => _selectedEnquiryType = val)),
                            _buildSelectableChip("Student", _selectedEnquiryType, (val) => setState(() => _selectedEnquiryType = val), icon: Icons.school_outlined),
                            _buildSelectableChip("Client", _selectedEnquiryType, (val) => setState(() => _selectedEnquiryType = val), icon: Icons.business_outlined),
                            _buildSelectableChip("Other", _selectedEnquiryType, (val) => setState(() => _selectedEnquiryType = val), icon: Icons.help_outline),
                          ],
                        ),
                         const SizedBox(height: 20),

                        _buildSectionTitle(Icons.category, "Enquiry Type"),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _buildSelectableChip("All Types", _selectedRoleType, (val) => setState(() => _selectedRoleType = val)),
                            _buildSelectableChip("Student", _selectedRoleType, (val) => setState(() => _selectedRoleType = val), icon: Icons.school_outlined),
                            _buildSelectableChip("Client", _selectedRoleType, (val) => setState(() => _selectedRoleType = val), icon: Icons.business_outlined),
                            _buildSelectableChip("Other", _selectedRoleType, (val) => setState(() => _selectedRoleType = val), icon: Icons.help_outline),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: greenAccent, size: 20),
                                const SizedBox(width: 5),
                                const Text("1 results", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTimePeriod = 'Today';
                                  _selectedEnquiryType = 'All Types';
                                  _selectedRoleType = 'All Types';
                                });
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
                  const Text("All Enquiries (1)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // Enquiry List Item
                  Material(
                    color: cardBgCream,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: orangeAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.apartment, color: Colors.orange),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("vaibhav more", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: orangeAccent.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text("CLIENT", style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: const [
                                Icon(Icons.phone, size: 16, color: Colors.grey),
                                SizedBox(width: 8),
                                Text("9699551565", style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: orangeAccent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.work_outline, size: 16, color: Colors.deepOrange),
                                  SizedBox(width: 6),
                                  Text("App Development", style: TextStyle(color: Colors.deepOrange, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Divider(color: Colors.black12),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Row(
                                   children: const [
                                     Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                     SizedBox(width: 4),
                                     Text("shantanu", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                   ],
                                 ),
                                 Row(
                                   children: const [
                                     Icon(Icons.access_time, size: 16, color: Colors.grey),
                                     SizedBox(width: 4),
                                     Text("4 hours ago", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                   ],
                                 ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DRAWER WIDGET (Sidebar) ---
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: drawerBlue,
      elevation: 0,
      width: 280, // Adjust width as needed
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header: Circle Grid Icon
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

            // Menu Item 1: Enquiries (Selected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Highlight background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                  title: const Text(
                    "Enquiries",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Already on Enquiries
                    Navigator.pop(context); 
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Menu Item 2: Users
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: const Icon(Icons.people_alt_rounded, color: Colors.white),
                title: const Text(
                  "Users",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsersScreen()),
                  );
                },
              ),
            ),

            const Spacer(),

            // Footer: Admin Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // Slightly transparent container
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: drawerBlue, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Admin",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "admin@example.com",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(milliseconds: 800)));
  }

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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildSelectableChip(String label, String currentSelection, Function(String) onSelect, {IconData? icon}) {
    bool isSelected = label == currentSelection;
    return GestureDetector(
      onTap: () => onSelect(label),
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
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}