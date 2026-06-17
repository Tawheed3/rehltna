import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/items_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../home/search_screen.dart';
import '../posts/item_details_screen.dart';

class PastTripsScreen extends StatefulWidget {
  const PastTripsScreen({Key? key}) : super(key: key);

  @override
  State<PastTripsScreen> createState() => _PastTripsScreenState();
}

class _PastTripsScreenState extends State<PastTripsScreen> {
  List<ItemModel> _pastTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPastTrips();
  }

  Future<void> _loadPastTrips() async {
    setState(() => _isLoading = true);
    try {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      await itemsProvider.fetchEndedItems();
      _pastTrips = itemsProvider.getExpiredItems();
    } catch (e) {
      developer.log('[PastTrips] Error: $e', name: 'Response-output', level: 1000);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'الرحلات السابقة',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
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
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadPastTrips,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pastTrips.isEmpty
          ? _buildEmptyState(isDark)
          : RefreshIndicator(
        onRefresh: _loadPastTrips,
        color: Colors.blueGrey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _pastTrips.length,
          itemBuilder: (context, index) {
            final trip = _pastTrips[index];
            return _buildTripCard(trip, isDark, localizations);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history,
              size: 80,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد رحلات سابقة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'الرحلات التي بدأت وانتهت ستظهر هنا',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPastTrips,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(ItemModel trip, bool isDark, AppLocalizations localizations) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              itemId: trip.id,
              categoryColor: Colors.blueGrey,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // الصورة
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blueGrey.withOpacity(0.1),
                child: trip.getBanner('ar').isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: trip.getBanner('ar'),
                  fit: BoxFit.cover,
                  placeholder: (c, url) => Container(color: Colors.blueGrey.withOpacity(0.1)),
                  errorWidget: (context, url, error) {
                    return Container(
                      color: Colors.blueGrey.withOpacity(0.1),
                      child: const Icon(
                        Icons.image,
                        color: Colors.blueGrey,
                        size: 40,
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.blueGrey.withOpacity(0.1),
                  child: const Icon(
                    Icons.image,
                    color: Colors.blueGrey,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // المعلومات
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.getTitle('ar'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.itineraries.isNotEmpty
                                ? trip.itineraries
                                    .map((it) => it.city.getTitle('ar'))
                                    .where((c) => c.isNotEmpty)
                                    .join(' - ')
                                : trip.itemType.getTitle('ar'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.red[300],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'بدأت في: ${_formatDate(trip.startDate)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // عدد الليالي
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${trip.totalNights} ليلة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}