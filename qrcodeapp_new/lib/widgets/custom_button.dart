// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double? fontSize; // حجم الخط اختياري
  final double? iconSize; // حجم الأيقونة اختياري

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // حساب الأحجام بناءً على الشاشة
    double buttonHeight = screenHeight * 0.07; // 7% من ارتفاع الشاشة
    double iconSize = this.iconSize ?? screenWidth * 0.06; // 6% من عرض الشاشة
    double textSize = this.fontSize ?? screenWidth * 0.035; // 3.5% من عرض الشاشة

    // الحد الأقصى والأدنى للأحجام
    buttonHeight = buttonHeight.clamp(50.0, 70.0); // بين 50 و 70
    iconSize = iconSize.clamp(20.0, 30.0); // بين 20 و 30
    textSize = textSize.clamp(14.0, 18.0); // بين 14 و 18

    return SizedBox(
      width: double.infinity, // يأخذ كل العرض المتاح
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, // 3% من عرض الشاشة
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize),
            SizedBox(width: screenWidth * 0.02), // 2% من عرض الشاشة
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis, // لو النص طويل
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}