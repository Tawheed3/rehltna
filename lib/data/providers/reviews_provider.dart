import 'dart:developer' as developer;
import '../models/review_model.dart';
import 'base_provider.dart';

class ReviewsProvider extends BaseProvider {
  List<ReviewModel> _allReviews = [];
  List<ReviewModel> _tripReviews = [];
  Map<int, List<ReviewModel>> _tripReviewsCache = {};
  bool _isSubmitting = false;
  bool _hasLoadedAllReviews = false;
  int _currentTripId = 0;

  List<ReviewModel> get allReviews => _allReviews;
  List<ReviewModel> get tripReviews => _tripReviews;
  bool get isSubmitting => _isSubmitting;
  bool get hasLoadedAllReviews => _hasLoadedAllReviews;

  // ==================== جلب كل المراجعات ====================

  Future<void> fetchAllReviews() async {
    if (_hasLoadedAllReviews && _allReviews.isNotEmpty) {
      return;
    }

    startLoading();

    final data = await getRequest('reviews');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      _allReviews = (data['data'] as List)
          .map((item) => ReviewModel.fromJson(item))
          .toList();
      _hasLoadedAllReviews = true;
      developer.log('✅ Loaded ${_allReviews.length} reviews for homepage', name: BaseProvider.logTag);
    }

    stopLoading();
  }

  // ==================== جلب مراجعات رحلة محددة ====================

  Future<void> fetchTripReviews(int tripId, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _tripReviewsCache.remove(tripId);
    }

    if (_currentTripId != tripId) {
      _tripReviews = [];
      _currentTripId = tripId;
      notifyListeners();
    }

    if (_tripReviewsCache.containsKey(tripId)) {
      _tripReviews = _tripReviewsCache[tripId]!;
      developer.log('📋 Using cached reviews for trip $tripId (${_tripReviews.length})', name: BaseProvider.logTag);
      notifyListeners();
      return;
    }

    startLoading();

    final data = await getRequest('items/$tripId/reviews');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      _tripReviews = (data['data'] as List)
          .map((item) => ReviewModel.fromJson(item))
          .toList();
      _tripReviewsCache[tripId] = _tripReviews;
      developer.log('✅ Loaded ${_tripReviews.length} reviews for trip $tripId', name: BaseProvider.logTag);
    } else {
      _tripReviews = [];
      _tripReviewsCache[tripId] = [];
    }

    stopLoading();
    notifyListeners();
  }

  // ==================== إرسال مراجعة (زائر) ====================

  Future<bool> submitReview({
    required String reviewerName,
    required int rating,
    String comment = '', // ✅ تعليق اختياري
    int? itemId, // ✅ itemId ممكن يكون null (تقييم عام)
  }) async {
    _isSubmitting = true;
    notifyListeners();

    final body = <String, dynamic>{
      "reviewer_name": reviewerName,
      "rating": rating,
      "comment": comment,
    };

    // ✅ بنضيف item_id بس لو مش null
    if (itemId != null) {
      body["item_id"] = itemId;
    }

    final data = await postRequest('reviews', body);

    _isSubmitting = false;

    if (data != null && data['code'] == 201) {
      developer.log('✅ Review submitted by guest (itemId: $itemId)', name: BaseProvider.logTag);
      if (itemId != null) {
        _tripReviewsCache.remove(itemId);
      }
      _hasLoadedAllReviews = false;
      if (itemId != null) {
        await fetchTripReviews(itemId, forceRefresh: true);
      }
      await fetchAllReviews();
      notifyListeners();
      return true;
    }

    setError(data?['message'] ?? 'فشل في إرسال المراجعة');
    notifyListeners();
    return false;
  }

  // ==================== إرسال مراجعة (مستخدم مسجل) ====================

  Future<bool> submitReviewLoggedIn({
    required int rating,
    String comment = '', // ✅ تعليق اختياري
    int? itemId, // ✅ itemId ممكن يكون null (تقييم عام)
    required String token,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    final body = <String, dynamic>{
      "rating": rating,
      "comment": comment,
    };

    // ✅ بنضيف item_id بس لو مش null
    if (itemId != null) {
      body["item_id"] = itemId;
    }

    final data = await postRequest('reviews', body, token: token);

    _isSubmitting = false;

    if (data != null && data['code'] == 201) {
      developer.log('✅ Review submitted by logged-in user (itemId: $itemId)', name: BaseProvider.logTag);
      if (itemId != null) {
        _tripReviewsCache.remove(itemId);
      }
      _hasLoadedAllReviews = false;
      if (itemId != null) {
        await fetchTripReviews(itemId, forceRefresh: true);
      }
      await fetchAllReviews();
      notifyListeners();
      return true;
    }

    setError(data?['message'] ?? 'فشل في إرسال المراجعة');
    notifyListeners();
    return false;
  }

  // ==================== حساب المتوسط ====================

  double getAverageRating() {
    if (_tripReviews.isEmpty) return 0;
    double total = _tripReviews.fold(0, (sum, r) => sum + r.rating);
    return total / _tripReviews.length;
  }

  String getAverageRatingDisplay() {
    final avg = getAverageRating();
    return avg.toStringAsFixed(1);
  }

  double getAllReviewsAverageRating() {
    if (_allReviews.isEmpty) return 0;
    double total = _allReviews.fold(0, (sum, r) => sum + r.rating);
    return total / _allReviews.length;
  }

  void clearError() {
    setError('');
    notifyListeners();
  }
}