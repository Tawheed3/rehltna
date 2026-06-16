// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:qrcodeapp_new/screens/create_qr_screen.dart';
import 'package:qrcodeapp_new/screens/sales_history_screen.dart';
import 'package:qrcodeapp_new/screens/scan_qr_screen.dart';
import 'package:qrcodeapp_new/screens/saved_items_screen.dart';
import 'package:qrcodeapp_new/screens/sell_screen.dart';
import 'package:qrcodeapp_new/screens/settings_screen.dart';
import 'package:qrcodeapp_new/screens/read_only_scan_screen.dart';
import 'package:qrcodeapp_new/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Text(
          'QR Code Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06, // 6% من عرض الشاشة
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2C3E50),
      ),
      body: SafeArea(
        child: SingleChildScrollView( // للشاشات الصغيرة
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // 5% من عرض الشاشة
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار
                Container(
                  height: screenHeight * 0.2, // 20% من ارتفاع الشاشة
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: screenHeight * 0.15, // 15% من ارتفاع الشاشة
                    color: const Color(0xFF2C3E50).withOpacity(0.2),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // عنوان الترحيب
                Text(
                  'مرحباً بك في مدير QR Code',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // 6% من عرض الشاشة
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'اختر ما تريد القيام به',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // 4% من عرض الشاشة
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),

                // الأزرار - هنستخدم LayoutBuilder عشان نحدد التوزيع
                LayoutBuilder(
                  builder: (context, constraints) {
                    // لو الشاشة عرضها أقل من 400 بكسل، نخلي الأزرار في عمود واحد
                    if (constraints.maxWidth < 400) {
                      return Column(
                        children: [
                          CustomButton(
                            icon: Icons.qr_code_2_rounded,
                            label: 'إنشاء QR',
                            color: const Color(0xFF3498DB),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateBarcodeScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'مسح وتخزين',
                            color: const Color(0xFF2ECC71),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.remove_red_eye_rounded,
                            label: 'مسح فقط',
                            color: const Color(0xFF9B59B6),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReadQRScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.shopping_cart_rounded,
                            label: 'بيع منتج',
                            color: Colors.red,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SellScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.folder_rounded,
                            label: 'المخزون',
                            color: const Color(0xFFE67E22),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SavedItemsScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.receipt_long,
                            label: 'سجل المبيعات',
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SalesHistoryScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.settings_rounded,
                            label: 'الإعدادات',
                            color: const Color(0xFF95A5A6),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    // للشاشات المتوسطة والكبيرة
                    else {
                      return Column(
                        children: [
                          // الصف الأول
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  icon: Icons.qr_code_2_rounded,
                                  label: 'إنشاء QR',
                                  color: const Color(0xFF3498DB),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CreateBarcodeScreen()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: CustomButton(
                                  icon: Icons.qr_code_scanner_rounded,
                                  label: 'مسح وتخزين',
                                  color: const Color(0xFF2ECC71),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),

                          // الصف الثاني
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  icon: Icons.remove_red_eye_rounded,
                                  label: 'مسح فقط',
                                  color: const Color(0xFF9B59B6),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ReadQRScreen()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: CustomButton(
                                  icon: Icons.folder_rounded,
                                  label: 'المخزون',
                                  color: const Color(0xFFE67E22),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SavedItemsScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            icon: Icons.receipt_long,
                            label: 'سجل المبيعات',
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SalesHistoryScreen()),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),

                          // الصف الثالث - زر الإعدادات بمفرده
                          CustomButton(
                            icon: Icons.settings_rounded,
                            label: 'الإعدادات',
                            color: const Color(0xFF95A5A6),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}