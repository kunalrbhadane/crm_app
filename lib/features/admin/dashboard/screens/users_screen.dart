import 'package:crm_app/core/models/user_model.dart';
import 'package:crm_app/features/admin/dashboard/user_provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color cardBlueHeader = const Color(0xFF4285F4);
  final Color bgGrey = const Color(0xFFF8F9FA);
  final Color orangeAccent = const Color(0xFFFB8C00);


  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch users when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });

    _scrollController.addListener(_onScroll);
  }


   @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Trigger Load More when reaching bottom
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // -200 means trigger slightly before hitting exact bottom
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (!provider.isLoadingMore && provider.hasMoreData) {
        provider.loadMoreUsers();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Users", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {
               // Refresh Button
               Provider.of<UserProvider>(context, listen: false).fetchUsers(isRefresh: true);
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Your Add User Logic
             showDialog(context: context, builder: (context) => const AddUserDialog());
          },
          backgroundColor: const Color(0xFF1565C0),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // 1. Loading State
          if (userProvider.isLoading && userProvider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (userProvider.error != null && userProvider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${userProvider.error}", style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => userProvider.fetchUsers(), 
                    child: const Text("Retry")
                  )
                ],
              ),
            );
          }

          // 3. Data State
           return RefreshIndicator(
            onRefresh: () async {
              await userProvider.fetchUsers(isRefresh: true);
            },
            child: SingleChildScrollView(
              controller: _scrollController, // Attach Controller
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Stats ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildTopStatCard(
                          Icons.group, "Total", "${userProvider.summary.totalUsers}", Colors.blue.shade50, Colors.blue
                        )
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTopStatCard(
                          Icons.check_circle, "Active", "${userProvider.summary.activeUsers}", Colors.green.shade50, Colors.green
                        )
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  const Text("All Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // --- List ---
                  if (userProvider.users.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No users found.")))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userProvider.users.length,
                      itemBuilder: (context, index) {
                        final user = userProvider.users[index];
                        return _buildUserCard(user,userProvider);
                      },
                    ),

                  // --- Pagination Loading Spinner ---
                  if (userProvider.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  
                  // Bottom Padding
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper: Format Date String ---
  String _formatDate(String isoString) {
    try {
      if (isoString.isEmpty) return "N/A";
      DateTime date = DateTime.parse(isoString);
      // Simple custom format: Jan 05, 2026
      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
    } catch (e) {
      return isoString;
    }
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
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
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

  // --- Helper: User Card (Takes UserModel) ---
  Widget _buildUserCard(UserModel user, UserProvider userProvider) {

      bool isDeleting = userProvider.isDeleting(user.id);

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Active / Inactive Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: user.isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2), 
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: user.isActive ? Colors.greenAccent : Colors.redAccent, size: 8),
                      const SizedBox(width: 6),
                      Text(
                        user.isActive ? "Active" : "Inactive", 
                        style: TextStyle(
                          color: user.isActive ? Colors.greenAccent : Colors.redAccent, 
                          fontSize: 12, 
                          fontWeight: FontWeight.bold
                        )
                      ),
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
                    Text("Created: ${_formatDate(user.createdAt)}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
                            builder: (context) => EditUserDialog(userId: user.id,name: user.name, email: user.email)
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
                    // Disable/Enable Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: userProvider.isToggling(user.id) 
                            ? null // Disable click while loading
                            : () {
                                userProvider.toggleUserStatus(user.id, context);
                              },
                        style: ElevatedButton.styleFrom(
                          // Dynamic Color: Orange if Active (to disable), Green if Inactive (to enable)
                          backgroundColor: user.isActive ? orangeAccent : Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: userProvider.isToggling(user.id)
                            ? const SizedBox(
                                height: 16, 
                                width: 16, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    user.isActive ? Icons.block : Icons.check_circle_outline, 
                                    size: 16, 
                                    color: Colors.white
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.isActive ? "Disable" : "Enable", 
                                    style: const TextStyle(color: Colors.white)
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Delete Icon
                     Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isDeleting
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(user.id, user.name);
                              },
                            ),
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


//--------Delete Button Function--------

  Future<void> _showDeleteConfirmation(String userId, String userName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete "$userName"?\nThis action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Call Provider
                Provider.of<UserProvider>(context, listen: false).deleteUser(userId, context);
              },
            ),
          ],
        );
      },
    );
  }
}

// ==========================================
// DIALOG 1: ADD USER
// ==========================================

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF3E5F5), 
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form( // Wrap in Form
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                
                // Fields
                _buildLabel("Full Name"),
                _buildTextField(_nameController, "Full Name", Icons.person_outline),
                const SizedBox(height: 15),
                
                _buildLabel("Email"),
                _buildTextField(_emailController, "Email", Icons.email_outlined, isEmail: true),
                const SizedBox(height: 15),
                
                _buildLabel("Password"),
                _buildTextField(_passwordController, "Password", Icons.lock_outline, isPassword: true),
                const SizedBox(height: 25),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Add User", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await Provider.of<UserProvider>(context, listen: false).addUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pop(context); // Close dialog on success
      }
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, bool isEmail = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: TextFormField( // Changed to TextFormField for validation
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) return '$hint is required';
          if (isEmail && !value.contains('@')) return 'Invalid email';
          if (isPassword && value.length < 6) return 'Min 6 characters';
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
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

class EditUserDialog extends StatefulWidget {
  final String userId; // Add userId
  final String name;
  final String email;
  
  const EditUserDialog({
    super.key, 
    required this.userId, // Required to call API
    required this.name, 
    required this.email
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF3E5F5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
              _buildLabel("Full Name"),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: TextFormField(
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? 'Name required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: Colors.black87),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),

              // Email Field
              _buildLabel("Email"),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: TextFormField(
                  controller: _emailController,
                  validator: (val) => val!.contains('@') ? null : 'Invalid email',
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
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
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

  Future<void> _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await Provider.of<UserProvider>(context, listen: false).updateUser(
        widget.userId,
        _nameController.text.trim(),
        _emailController.text.trim(),
        context
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }
}