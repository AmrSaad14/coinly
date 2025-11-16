import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final TextEditingController _kioskNameController = TextEditingController();
  final TextEditingController _kioskLocationController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'إلكترونيات',
    'ملابس',
    'أطعمة ومشروبات',
    'أثاث ومنزل',
    'رياضة وصحة',
    'كتب وقرطاسية',
    'ألعاب وترفيه',
    'مستحضرات تجميل',
    'مجوهرات وإكسسوارات',
    'أخرى',
  ];

  @override
  void dispose() {
    _kioskNameController.dispose();
    _kioskLocationController.dispose();
    super.dispose();
  }

  void _createStore() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار تصنيف الكشك'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // TODO: Implement store creation logic with Firebase
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الكشك بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen
        AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'إنشاء كشك',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome message
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store,
                          size: 64,
                          color: AppColors.primaryTeal,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'مرحباً بك في كوينلي!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أنشئ كشكك الآن وابدأ في عرض منتجاتك',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Kiosk Name
                  _buildTextField(
                    controller: _kioskNameController,
                    label: 'اسم الكشك',
                    prefixIcon: Icons.storefront,
                    hint: 'مثال: كشك الإلكترونيات',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم الكشك';
                      }
                      if (value.length < 3) {
                        return 'اسم الكشك يجب أن يكون 3 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Kiosk Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'تصنيف الكشك',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.category,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryTeal,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Kiosk Location
                  _buildTextField(
                    controller: _kioskLocationController,
                    label: 'موقع الكشك',
                    prefixIcon: Icons.location_on,
                    hint: 'مثال: شارع التحرير، القاهرة',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال موقع الكشك';
                      }
                      if (value.length < 5) {
                        return 'الموقع يجب أن يكون 5 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Create Store Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createStore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'إنشاء الكشك',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip button
                  TextButton(
                    onPressed: () {
                      // Skip store creation and go to home
                      AppRouter.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.home,
                      );
                    },
                    child: Text(
                      'تخطي الآن، سأقوم بإنشائه لاحقاً',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
