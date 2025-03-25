import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_feedback_widget.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';

// Generate the mock class
@GenerateMocks([FeatureFeedbackProvider])
import 'feature_feedback_widget_test.mocks.dart';

void main() {
  group('FeatureFeedbackWidget', () {
    late MockFeatureFeedbackProvider mockProvider;

    setUp(() {
      mockProvider = MockFeatureFeedbackProvider();
    });

    testWidgets('should display feature requests', (WidgetTester tester) async {
      // Setup the mock
      when(mockProvider.featureRequests).thenReturn([
        FeatureRequest(
          id: 'test-1',
          title: 'Feature 1',
          description: 'Description 1',
          userId: 'user-1',
          createdAt: DateTime.now(),
          upvotes: 5,
          downvotes: 2,
        ),
        FeatureRequest(
          id: 'test-2',
          title: 'Feature 2',
          description: 'Description 2',
          userId: 'user-2',
          createdAt: DateTime.now(),
          upvotes: 10,
          downvotes: 1,
          status: 'approved',
        ),
      ]);
      when(mockProvider.isLoading).thenReturn(false);
      when(mockProvider.error).thenReturn(null);
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
            value: mockProvider,
            child: FeatureFeedbackWidget(
              userId: 'current-user',
              collectionPath: 'test-collection',
            ),
          ),
        ),
      );
      
      // Verify the widget shows feature requests
      expect(find.text('Feature 1'), findsOneWidget);
      expect(find.text('Feature 2'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // Upvotes for Feature 1
      expect(find.text('10'), findsOneWidget); // Upvotes for Feature 2
    });

    testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
      // Setup the mock
      when(mockProvider.featureRequests).thenReturn([]);
      when(mockProvider.isLoading).thenReturn(true);
      when(mockProvider.error).thenReturn(null);
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
            value: mockProvider,
            child: FeatureFeedbackWidget(
                userId: 'current-user',
              collectionPath: 'test-collection',
            ),
          ),
        ),
      );
      
      // Verify the loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when there is an error', (WidgetTester tester) async {
      // Setup the mock
      when(mockProvider.featureRequests).thenReturn([]);
      when(mockProvider.isLoading).thenReturn(false);
      when(mockProvider.error).thenReturn('Test error message');
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
            value: mockProvider,
            child: FeatureFeedbackWidget(
              userId: 'current-user',
              collectionPath: 'test-collection',
            ),
          ),
        ),
      );
      
      // Verify the error message is shown
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should allow adding a new feature request', (WidgetTester tester) async {
      // Setup the mock
      when(mockProvider.featureRequests).thenReturn([]);
      when(mockProvider.isLoading).thenReturn(false);
      when(mockProvider.error).thenReturn(null);
      when(mockProvider.addFeatureRequest(
        title: anyNamed('title'),
        description: anyNamed('description'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => {});
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
            value: mockProvider,
            child: FeatureFeedbackWidget(
              userId: 'current-user',
              collectionPath: 'test-collection',
            ),
          ),
        ),
      );
      
      // Find and tap the add button
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      
      // Fill in the form
      await tester.enterText(find.byKey(Key('titleField')), 'New Feature Title');
      await tester.enterText(find.byKey(Key('descriptionField')), 'New Feature Description');
      
      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      
      // Verify the provider method was called with the correct arguments
      verify(mockProvider.addFeatureRequest(
        title: 'New Feature Title',
        description: 'New Feature Description',
        userId: 'current-user',
      )).called(1);
    });

    testWidgets('should allow upvoting a feature request', (WidgetTester tester) async {
      // Setup the mock
      when(mockProvider.featureRequests).thenReturn([
        FeatureRequest(
          id: 'test-1',
          title: 'Feature 1',
          description: 'Description 1',
          userId: 'user-1',
          createdAt: DateTime.now(),
          upvotes: 5,
          downvotes: 2,
        ),
      ]);
      when(mockProvider.isLoading).thenReturn(false);
      when(mockProvider.error).thenReturn(null);
      when(mockProvider.updateVote(
        featureId: anyNamed('featureId'),
        userId: anyNamed('userId'),
        isUpvote: anyNamed('isUpvote'),
      )).thenAnswer((_) async => {});
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
            value: mockProvider,
            child: FeatureFeedbackWidget(
              userId: 'current-user',
              collectionPath: 'test-collection',
            ),
          ),
        ),
      );
      
      // Find and tap the upvote button
      final upvoteButton = find.byIcon(Icons.thumb_up);
      expect(upvoteButton, findsOneWidget);
      await tester.tap(upvoteButton);
      await tester.pump();
      
      // Verify the provider method was called with the correct arguments
      verify(mockProvider.updateVote(
        featureId: 'test-1',
        userId: 'current-user',
        isUpvote: true,
      )).called(1);
    });
  });
}

void testFeatureFeedbackWidget() => main(); 