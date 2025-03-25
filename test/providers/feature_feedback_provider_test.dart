import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/services/feature_feedback_service.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';

// Generate the mock class
@GenerateMocks([FeatureFeedbackService])
import 'feature_feedback_provider_test.mocks.dart';

void main() {
  group('FeatureFeedbackProvider', () {
    late MockFeatureFeedbackService mockService;
    late FeatureFeedbackProvider provider;

    setUp(() {
      mockService = MockFeatureFeedbackService();
      
      // Mock the stream for getFeatureRequests
      when(mockService.getFeatureRequests()).thenAnswer((_) => 
        Stream.value([
          FeatureRequest(
            id: 'test-1',
            title: 'Feature 1',
            description: 'Description 1',
            userId: 'user-1',
            createdAt: DateTime.now(),
          ),
          FeatureRequest(
            id: 'test-2',
            title: 'Feature 2',
            description: 'Description 2',
            userId: 'user-2',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
          ),
        ])
      );
      
      provider = FeatureFeedbackProvider(mockService);
    });

    test('should initialize with feature requests from service', () async {
      // Provider should initialize automatically in setup
      // Wait for the stream to emit
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(provider.featureRequests.length, 2);
      expect(provider.featureRequests[0].title, 'Feature 1');
      expect(provider.featureRequests[1].title, 'Feature 2');
      expect(provider.error, isNull);
    });

    test('should handle errors when getting feature requests', () async {
      // Create a new mock that throws an error
      final errorMockService = MockFeatureFeedbackService();
      when(errorMockService.getFeatureRequests()).thenAnswer((_) => 
        Stream<List<FeatureRequest>>.error('Test error')
      );
      
      final errorProvider = FeatureFeedbackProvider(errorMockService);
      
      // Wait for the stream to emit
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(errorProvider.error, isNotNull);
      expect(errorProvider.error, contains('Test error'));
    });

    test('should add a feature request', () async {
      when(mockService.createFeatureRequest(
        title: 'New Feature',
        description: 'New Description',
        userId: 'user-new',
      )).thenAnswer((_) async => 
        FeatureRequest(
          id: 'new-id',
          title: 'New Feature',
          description: 'New Description',
          userId: 'user-new',
          createdAt: DateTime.now(),
        )
      );
      
      bool notifyListenersWasCalled = false;
      provider.addListener(() {
        notifyListenersWasCalled = true;
      });
      
      await provider.addFeatureRequest(
        title: 'New Feature',
        description: 'New Description',
        userId: 'user-new',
      );
      
      verify(mockService.createFeatureRequest(
        title: 'New Feature',
        description: 'New Description',
        userId: 'user-new',
      )).called(1);
      
      expect(notifyListenersWasCalled, isTrue);
      expect(provider.error, isNull);
    });

    test('should handle errors when adding a feature request', () async {
      when(mockService.createFeatureRequest(
        title: anyNamed('title'),
        description: anyNamed('description'),
        userId: anyNamed('userId'),
      )).thenThrow('Test error');
      
      await provider.addFeatureRequest(
        title: 'New Feature',
        description: 'New Description',
        userId: 'user-new',
      );
      
      expect(provider.error, contains('Test error'));
    });

    test('should handle permission denied errors with a specific message', () async {
      when(mockService.createFeatureRequest(
        title: anyNamed('title'),
        description: anyNamed('description'),
        userId: anyNamed('userId'),
      )).thenThrow('permission-denied: error');
      
      await provider.addFeatureRequest(
        title: 'New Feature',
        description: 'New Description',
        userId: 'user-new',
      );
      
      expect(provider.error, contains('You don\'t have permission'));
    });

    test('should update vote for a feature request', () async {
      when(mockService.updateVote(
        featureId: 'test-id',
        userId: 'voter-id',
        isUpvote: true,
      )).thenAnswer((_) async => {});
      
      await provider.updateVote(
        featureId: 'test-id',
        userId: 'voter-id',
        isUpvote: true,
      );
      
      verify(mockService.updateVote(
        featureId: 'test-id',
        userId: 'voter-id',
        isUpvote: true,
      )).called(1);
      
      expect(provider.error, isNull);
    });

    test('should update status for a feature request', () async {
      when(mockService.updateStatus(
        featureId: 'test-id',
        status: 'approved',
      )).thenAnswer((_) async => {});
      
      await provider.updateStatus(
        featureId: 'test-id',
        status: 'approved',
      );
      
      verify(mockService.updateStatus(
        featureId: 'test-id',
        status: 'approved',
      )).called(1);
      
      expect(provider.error, isNull);
    });

    test('should delete a feature request', () async {
      when(mockService.deleteFeatureRequest('test-id'))
        .thenAnswer((_) async => {});
      
      await provider.deleteFeatureRequest('test-id');
      
      verify(mockService.deleteFeatureRequest('test-id')).called(1);
      expect(provider.error, isNull);
    });

    test('should load feature requests using Future-based method', () async {
      when(mockService.getFeatureRequestsFuture()).thenAnswer((_) async => [
        FeatureRequest(
          id: 'future-1',
          title: 'Future Feature 1',
          description: 'Future Description 1',
          userId: 'user-f1',
          createdAt: DateTime.now(),
        ),
        FeatureRequest(
          id: 'future-2',
          title: 'Future Feature 2',
          description: 'Future Description 2',
          userId: 'user-f2',
          createdAt: DateTime.now(),
        ),
      ]);
      
      bool loadingStateChanged = false;
      provider.addListener(() {
        if (provider.isLoading) {
          loadingStateChanged = true;
        }
      });
      
      provider.loadFeatureRequests();
      
      verify(mockService.getFeatureRequestsFuture()).called(1);
      expect(loadingStateChanged, isTrue);
      expect(provider.isLoading, isFalse); // Should be false after loading completes
      expect(provider.featureRequests.length, 2);
      expect(provider.featureRequests[0].title, 'Future Feature 1');
      expect(provider.error, isNull);
    });
  });
}

void testFeatureFeedbackProvider() => main(); 