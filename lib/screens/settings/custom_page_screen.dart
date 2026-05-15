import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/custom_page_model.dart';
import '../../data/services/settings_service.dart';

class CustomPageScreen extends StatelessWidget {
  final CustomPageModel page;

  const CustomPageScreen({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);
    final content = page.getContent(ss.languageCode);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          page.getTitle(ss.languageCode),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: content.isNotEmpty
            ? HtmlWidget(
          content,
          textStyle: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
            height: 1.8,
          ),
        )
            : Center(
          child: Text(
            ss.languageCode == 'ar' ? 'لا يوجد محتوى' : 'No content available',
            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}