import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';

// WHY: Main dashboard showing quick access to all features
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Dawah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push(AppRouter.about),
          ),
        ],
      ),
      body: Column(
        children: [
          // Donation Message Card
          _buildDonationMessage(),

          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                _buildFeatureCard(
                  context,
                  title: 'Prayer Times',
                  icon: Icons.access_time,
                  color: Colors.green,
                  onTap: () => context.push(AppRouter.prayerTimes),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Prayer Tracker',
                  icon: Icons.check_circle_outline,
                  color: Colors.blue,
                  onTap: () => context.push(AppRouter.tracker),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Quran',
                  icon: Icons.menu_book,
                  color: Colors.teal,
                  onTap: () => context.push(AppRouter.quran),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Adhkar',
                  icon: Icons.favorite,
                  color: Colors.orange,
                  onTap: () => context.push(AppRouter.adhkar),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Qibla Direction',
                  icon: Icons.compass_calibration,
                  color: Colors.purple,
                  onTap: () => context.push(AppRouter.qibla),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.volunteer_activism, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppConstants.donationMessage,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}