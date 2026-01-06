import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color cardBlueHeader = const Color(0xFF4285F4); // Lighter blue for card top
  final Color bgGrey = const Color(0xFFF8F9FA);
  final Color orangeAccent = const Color(0xFFFB8C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Simplified back for demo
        ),
        title: const Text("Users", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (context) => const AddUserDialog()
            );
          },
          backgroundColor: const Color(0xFF1565C0), // Darker blue button
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Stats Row ---
            Row(
              children: [
                Expanded(child: _buildTopStatCard(Icons.group, "Total", "7", Colors.blue.shade50, Colors.blue)),
                const SizedBox(width: 15),
                Expanded(child: _buildTopStatCard(Icons.check_circle, "Active", "7", Colors.green.shade50, Colors.green)),
              ],
            ),
            
            const SizedBox(height: 25),
            const Text("All Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // --- User Cards ---
            _buildUserCard(
              name: "onkar",
              email: "onkar@gmail.com",
              date: "Jan 05, 2026",
            ),
            _buildUserCard(
              name: "kunal",
              email: "kunal@gmail.com",
              date: "Jan 05, 2026",
            ),
            _buildUserCard(
              name: "vaibhav more",
              email: "vaibhav@gmail.com",
              date: "Jan 05, 2026",
            ),
            // Add padding at bottom for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // --- Helper: Top Stat Card ---
  Widget _buildTopStatCard(IconData icon, String label, String count, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(count, style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // --- Helper: User Card ---
  Widget _buildUserCard({required String name, required String email, required String date}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          // Blue Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBlueHeader,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    Text(email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: const [
                      Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                      SizedBox(width: 6),
                      Text("Active", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // White Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Created: $date", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Action Buttons Row
                Row(
                  children: [
                    // Edit Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                           showDialog(
                            context: context, 
                            builder: (context) => EditUserDialog(name: name, email: email)
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Edit"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryBlue,
                          side: BorderSide(color: primaryBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Disable Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.block, size: 16, color: Colors.white),
                        label: const Text("Disable", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Delete Icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// DIALOG 1: ADD USER
// ==========================================

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF3E5F5), // Light Purple tint background from image
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                ),
                const SizedBox(width: 10),
                const Text("Add New User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel("Full Name"),
            _buildTextField("Full Name", Icons.person_outline),
            const SizedBox(height: 15),
            _buildLabel("Email"),
            _buildTextField("Email", Icons.email_outlined),
             const SizedBox(height: 15),
            _buildLabel("Password"),
            _buildTextField("Password", Icons.lock_outline, isPassword: true),
            const SizedBox(height: 25),
            
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Add User", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 14)),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}

// ==========================================
// DIALOG 2: EDIT USER
// ==========================================

class EditUserDialog extends StatelessWidget {
  final String name;
  final String email;
  
  const EditUserDialog({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF3E5F5), // Light Purple tint
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.edit, color: Colors.blue),
                ),
                const SizedBox(width: 10),
                const Text("Edit User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Name Field
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: const Text("Full Name", style: TextStyle(color: Colors.black54, fontSize: 14)),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            
            const SizedBox(height: 15),

            // Email Field
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: const Text("Email", style: TextStyle(color: Colors.black54, fontSize: 14)),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 25),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}