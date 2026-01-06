import 'package:flutter/material.dart';

class NewEnquiryScreen extends StatefulWidget {
  const NewEnquiryScreen({super.key});
  @override
  State<NewEnquiryScreen> createState() => _NewEnquiryScreenState();
}

class _NewEnquiryScreenState extends State<NewEnquiryScreen> {

  String? _selectedEnquiryType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A89F5),
        elevation: 0,
        title: const Text('New Enquiry', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Submit Your Enquiry',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 8),
              const Text(
                'Fill in the details and we\'ll get back to you soon.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),
              _buildTextField(label: 'Full Name', icon: Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField(label: 'Email Address', icon: Icons.email_outlined),
              const SizedBox(height: 20),
              _buildTextField(label: 'Phone Number', icon: Icons.phone_outlined),
              const SizedBox(height: 20),
              
              _buildDropdownField(),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Message',
                icon: Icons.message_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A89F5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Enquiry',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  
  Widget _buildDropdownField() {
    return InputDecorator(
      decoration: InputDecoration(
       
        prefixIcon: const Icon(Icons.category_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
    
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
         
          hint: const Text('Enquiry Type'),
          
          value: _selectedEnquiryType,
          isDense: true,
          isExpanded: true,
          items: ['Student', 'Client', 'Other']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
       
          onChanged: (newValue) {
            setState(() {
              _selectedEnquiryType = newValue;
            });
          },
        ),
      ),
    );
  }
}