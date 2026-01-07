import 'package:crm_app/features/user/enquiries/provider/enquiri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewEnquiryScreen extends StatefulWidget {
  const NewEnquiryScreen({super.key});
  @override
  State<NewEnquiryScreen> createState() => _NewEnquiryScreenState();
}

class _NewEnquiryScreenState extends State<NewEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _otherEnquiryController = TextEditingController();
  
  String? _selectedEnquiryType;
  String? _selectedCourse;
  String? _selectedService;
  bool _isLoading = false;

  final List<String> _courses = [
    'Web Development',
    'Data Science',
    'UI/UX Design',
    'Digital Marketing',
    'Mobile App Development',
    'Python Programming',
    'Full Stack Development'
  ];

  final List<String> _services = [
    'Website Development',
    'Mobile App',
    'SEO Services',
    'Branding',
    'E-commerce Solution',
    'Custom Software',
    'Maintenance & Support'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _otherEnquiryController.dispose();
    super.dispose();
  }

  Future<void> _submitEnquiry() async {
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final enquiryData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'enquiryType': (_selectedEnquiryType ?? 'Other').toLowerCase(),
          if (_selectedEnquiryType == 'Student' && _selectedCourse != null)
            'course': _selectedCourse,
          if (_selectedEnquiryType == 'Client' && _selectedService != null)
            'service': _selectedService,
          // MODIFIED: Changed key from 'otherDetails' to 'notes' to match the model
          if (_selectedEnquiryType == 'Other')
            'notes': _otherEnquiryController.text.trim(),
          'message': _messageController.text.trim(),
          'status': 'New',
        };

        await Provider.of<EnquiriProvider>(context, listen: false).createEnquiry(enquiryData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Enquiry submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A89F5),
        elevation: 0,
        title: const Text('New Enquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          child: Form(
            key: _formKey,
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
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@') ? 'Please enter a valid email' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be exactly 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdownField(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  icon: Icons.message_outlined,
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEnquiry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A89F5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text(
                            'Submit Enquiry',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
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
                  _selectedCourse = null;
                  _selectedService = null;
                });
              },
            ),
          ),
        ),
        if (_selectedEnquiryType == 'Student') ...[
          const SizedBox(height: 20),
          InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.school_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text('Select Course'),
                value: _selectedCourse,
                isDense: true,
                isExpanded: true,
                items: _courses.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCourse = newValue;
                  });
                },
              ),
            ),
          ),
        ],
        if (_selectedEnquiryType == 'Client') ...[
          const SizedBox(height: 20),
          InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.business_center_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text('Select Service'),
                value: _selectedService,
                isDense: true,
                isExpanded: true,
                items: _services.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
              ),
            ),
          ),
        ],
        if (_selectedEnquiryType == 'Other') ...[
          const SizedBox(height: 20),
          _buildTextField(
            controller: _otherEnquiryController,
            label: 'Please specify',
            icon: Icons.edit_note_outlined,
            validator: (value) => value == null || value.isEmpty ? 'Please specify your enquiry type' : null,
          ),
        ],
      ],
    );
  }
}