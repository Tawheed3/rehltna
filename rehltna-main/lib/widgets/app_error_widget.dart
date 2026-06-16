import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum AppErrorType { network, server, empty, auth, unknown }

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final AppErrorType type;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const AppErrorWidget({
    Key? key,
    this.message,
    this.type = AppErrorType.unknown,
    this.onRetry,
    this.retryLabel,
  }) : super(key: key);

  // Convenience constructors
  const AppErrorWidget.network({Key? key, VoidCallback? onRetry})
      : this(key: key, type: AppErrorType.network, onRetry: onRetry);

  const AppErrorWidget.server({Key? key, String? message, VoidCallback? onRetry})
      : this(key: key, type: AppErrorType.server, message: message, onRetry: onRetry);

  const AppErrorWidget.empty({Key? key, String? message})
      : this(key: key, type: AppErrorType.empty, message: message);

  _Config get _cfg {
    switch (type) {
      case AppErrorType.network:
        return _Config(
          icon: Icons.wifi_off_rounded,
          color: AppColors.warning,
          title: 'لا يوجد اتصال بالإنترنت',
          subtitle: 'تحقق من اتصالك وحاول مجدداً',
        );
      case AppErrorType.server:
        return _Config(
          icon: Icons.cloud_off_rounded,
          color: AppColors.error,
          title: 'خطأ في الخادم',
          subtitle: message ?? 'حدث خطأ غير متوقع، حاول مجدداً',
        );
      case AppErrorType.empty:
        return _Config(
          icon: Icons.inbox_rounded,
          color: AppColors.textLight,
          title: message ?? 'لا توجد بيانات',
          subtitle: 'لا يوجد محتوى لعرضه حالياً',
        );
      case AppErrorType.auth:
        return _Config(
          icon: Icons.lock_outline_rounded,
          color: AppColors.primary,
          title: 'انتهت الجلسة',
          subtitle: 'سجّل دخولك مجدداً للمتابعة',
        );
      case AppErrorType.unknown:
        return _Config(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
          title: 'حدث خطأ',
          subtitle: message ?? 'يرجى المحاولة مجدداً',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cfg.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(cfg.icon, size: 52, color: cfg.color),
            ),
            const SizedBox(height: 20),
            Text(
              cfg.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cfg.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : AppColors.textLight,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 160,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(retryLabel ?? 'حاول مجدداً'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Config {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _Config({required this.icon, required this.color, required this.title, required this.subtitle});
}
