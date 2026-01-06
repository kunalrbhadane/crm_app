import 'package:crm_app/features/auth/login/screens/Login.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // State to track selection. Defaults to 'User' based on the image.
  String selectedRole = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Choose your role",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "below",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Image(
                            image: AssetImage('assets/images/arrow_left.png'),
                            width: 50,
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF5B8BD9),
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Admin Card (Unselected) ---
              _buildRoleCard(
                role: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                isSelected: selectedRole == 'Admin',
                onTap: () => setState(() => selectedRole = 'Admin'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFFB74D),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "or",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // --- User Card (Selected) ---
              _buildRoleCard(
                role: 'User',
                icon: Icons.person,
                isSelected: selectedRole == 'User',
                onTap: () => setState(() => selectedRole = 'User'),
              ),

              SizedBox(height: 60),

              const Center(
                child: Image(
                  image: AssetImage('assets/images/bottom_right.png'),
                  width: 50,
                  height: 20,
                ),
              ),

              const SizedBox(height: 20),

              // --- Get Started Button ---
              SizedBox(
                height: 65,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(role: selectedRole)
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A), // Dark black/grey
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Get started",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              // --- Bottom Left Sparkles ---
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFF5252),
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for the Role Card ---
  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // The specific blue color from the image
    final Color cardBlue = const Color(0xFF4A89F5);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: cardBlue,
              borderRadius: BorderRadius.circular(24),
              // Thick black border if selected, none if not
              border: isSelected
                  ? Border.all(color: Colors.black, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 40),
                // Icon Circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Lighter blue overlay
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(icon, color: Colors.white, size: 40),
                ),
                const Spacer(),
                // Text
                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // The Checkmark (Only shows if selected)
          if (isSelected)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.check, size: 16, color: cardBlue),
              ),
            ),
        ],
      ),
    );
  }
}
