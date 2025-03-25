import 'package:flutter_test/flutter_test.dart';

import 'models/feature_request_test.dart';
import 'services/feature_feedback_service_test.dart';
import 'providers/feature_feedback_provider_test.dart';
import 'widgets/feature_feedback_widget_test.dart';

void main() {
  group('Models', () {
    testFeatureRequest();
  });
  
  group('Services', () {
    testFeatureFeedbackService();
  });
  
  group('Providers', () {
    testFeatureFeedbackProvider();
  });
  
  group('Widgets', () {
    testFeatureFeedbackWidget();
  });
} 