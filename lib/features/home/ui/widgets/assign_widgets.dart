import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:coinly/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignPointsWidget extends StatefulWidget {
  const AssignPointsWidget({super.key});

  @override
  State<AssignPointsWidget> createState() => _AssignPointsWidgetState();
}

class _AssignPointsWidgetState extends State<AssignPointsWidget> {
  final TextEditingController _pointsLimitController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _pointsLimitController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String? _validatePoints(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    final points = int.tryParse(value);
    if (points == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    if (points > 500) {
      return 'الحد الأقصى للنقاط هو 500';
    }
    if (points < 0) {
      return 'يجب أن يكون الرقم أكبر من أو يساوي صفر';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      });
    }
  }

  void _onAssignTap() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار تاريخ البداية والنهاية'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب أن يكون تاريخ النهاية بعد تاريخ البداية'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final pointsLimit = int.tryParse(_pointsLimitController.text) ?? 0;

      // TODO: Implement the actual assignment logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تعيين الحد الأقصى للنقاط: $pointsLimit\nمن ${_startDateController.text} إلى ${_endDateController.text}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اعداد هدف الفريق',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              Text(
                'تعيين المبلغ بالنقاط',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                controller: _pointsLimitController,
                hint: 'حد النقاط',
                keyboardType: TextInputType.number,
                validator: _validatePoints,
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                controller: _startDateController,
                hint: 'تاريخ البداية',
                validator: _validateDate,
                readOnly: true,
                onTap: () => _selectStartDate(context),
                suffixIcon: Icons.calendar_today,
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                controller: _endDateController,
                hint: 'تاريخ النهاية',
                validator: _validateDate,
                readOnly: true,
                onTap: () => _selectEndDate(context),
                suffixIcon: Icons.calendar_today,
              ),
              SizedBox(height: 10.h),
              CustomButton(
                width: double.infinity,
                text: 'تعيين',
                onTap: _onAssignTap,
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
