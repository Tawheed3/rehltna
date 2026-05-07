import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Shimmer for a single horizontal trip card (used in search results,
/// subcategory screen, and category screen).
class ItemCardShimmer extends StatelessWidget {
  const ItemCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase;
    final highlight = isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // image placeholder
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 12),
            // text placeholders
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 14, width: double.infinity, color: Colors.white),
                    Container(height: 10, width: 120, color: Colors.white),
                    Row(
                      children: [
                        Container(height: 22, width: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                        const SizedBox(width: 8),
                        Container(height: 22, width: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A list of [ItemCardShimmer] cards — drop this wherever items are loading.
class ItemListShimmer extends StatelessWidget {
  final int count;
  const ItemListShimmer({Key? key, this.count = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, __) => const ItemCardShimmer(),
    );
  }
}
