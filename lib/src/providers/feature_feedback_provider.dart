import 'package:flutter/foundation.dart';
import '../models/feature_request.dart';
import '../services/feature_feedback_service.dart';

class FeatureFeedbackProvider extends ChangeNotifier {
  final FeatureFeedbackService _service;
  List<FeatureRequest> _featureRequests = [];
  bool _isLoading = false;
  String? _error;

  FeatureFeedbackProvider(this._service) {
    _initializeStream();
  }

  List<FeatureRequest> get featureRequests => _featureRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _initializeStream() {
    _service.getFeatureRequests().listen(
      (requests) {
        _featureRequests = requests;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> addFeatureRequest({
    required String title,
    required String description,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.createFeatureRequest(
        title: title,
        description: description,
        userId: userId,
      );

      _error = null;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        _error = 'You don\'t have permission to access this feature. Please check your account settings or contact support.';
      } else {
        _error = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVote({
    required String featureId,
    required String userId,
    required bool isUpvote,
  }) async {
    try {
      await _service.updateVote(
        featureId: featureId,
        userId: userId,
        isUpvote: isUpvote,
      );
      _error = null;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        _error = 'You don\'t have permission to access this feature. Please check your account settings or contact support.';
      } else {
        _error = e.toString();
      }
      notifyListeners();
    }
  }

  Future<void> updateStatus({
    required String featureId,
    required String status,
  }) async {
    try {
      await _service.updateStatus(
        featureId: featureId,
        status: status,
      );
      _error = null;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        _error = 'You don\'t have permission to access this feature. Please check your account settings or contact support.';
      } else {
        _error = e.toString();
      }
      notifyListeners();
    }
  }

  Future<void> deleteFeatureRequest(String featureId) async {
    try {
      await _service.deleteFeatureRequest(featureId);
      _error = null;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        _error = 'You don\'t have permission to access this feature. Please check your account settings or contact support.';
      } else {
        _error = e.toString();
      }
      notifyListeners();
    }
  }

  void loadFeatureRequests() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _featureRequests = await _service.getFeatureRequestsFuture();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        _error = 'You don\'t have permission to access this feature. Please check your account settings or contact support.';
      } else {
        _error = e.toString();
      }
      _isLoading = false;
      notifyListeners();
    }
  }
} 