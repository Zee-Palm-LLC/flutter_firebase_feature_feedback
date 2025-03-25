import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../providers/feature_feedback_provider.dart';
import '../services/feature_feedback_service.dart';
import '../models/feature_request.dart';

class FeatureFeedbackWidget extends StatelessWidget {
  final String userId;
  final String collectionPath;
  final bool isDeveloper;
  final Color primaryColor;
  final Color secondaryColor;
  final Color? backgroundColor;
  final Color? textColor;

  const FeatureFeedbackWidget({
    super.key,
    required this.userId,
    required this.collectionPath,
    this.isDeveloper = false,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.red,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualBackgroundColor = backgroundColor ?? theme.cardColor;
    final actualTextColor =
        textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return ChangeNotifierProvider(
      create: (context) => FeatureFeedbackProvider(
        FeatureFeedbackService(collectionPath: collectionPath),
      ),
      child: _FeatureFeedbackContent(
        userId: userId,
        isDeveloper: isDeveloper,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        backgroundColor: actualBackgroundColor,
        textColor: actualTextColor,
      ),
    );
  }
}

class _FeatureFeedbackContent extends StatelessWidget {
  final String userId;
  final bool isDeveloper;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color textColor;

  const _FeatureFeedbackContent({
    required this.userId,
    required this.isDeveloper,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FeatureFeedbackProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Platform.isIOS 
                ? const CupertinoActivityIndicator() 
                : const CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return ErrorDisplay(
            message: provider.error!,
            textColor: textColor,
            backgroundColor: backgroundColor,
            primaryColor: primaryColor,
            onRetry: () => provider.loadFeatureRequests(),
            onBack: () => Navigator.of(context).pop(),
          );
        }

        return Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AdaptiveButton(
                onPressed: () => _showAddFeatureSheet(context),
                label: 'Request New Feature',
                icon: Icons.add,
                color: primaryColor,
                textColor: Colors.white,
              ),
            ),
            Expanded(
              child: provider.featureRequests.isEmpty
                  ? Center(
                      child: Text(
                        'No feature requests yet. Be the first to suggest one!',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.featureRequests.length,
                      itemBuilder: (context, index) {
                        final request = provider.featureRequests[index];
                        return _FeatureRequestCard(
                          request: request,
                          userId: userId,
                          isDeveloper: isDeveloper,
                          primaryColor: primaryColor,
                          secondaryColor: secondaryColor,
                          backgroundColor: backgroundColor,
                          textColor: textColor,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showAddFeatureSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final provider = context.read<FeatureFeedbackProvider>();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Request New Feature'),
          message: const Text('Share your ideas to help improve the app'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: titleController,
                    placeholder: 'Feature title',
                    padding: const EdgeInsets.all(12),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: descriptionController,
                    placeholder: 'Describe the feature you would like to see',
                    padding: const EdgeInsets.all(12),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  provider.addFeatureRequest(
                    title: titleController.text,
                    description: descriptionController.text,
                    userId: userId,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Request New Feature',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your ideas to help improve the app',
                  style: TextStyle(color: textColor.withAlpha(153)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Feature title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Describe the feature you would like to see',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: textColor.withAlpha(153)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty) {
                          provider.addFeatureRequest(
                            title: titleController.text,
                            description: descriptionController.text,
                            userId: userId,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    }
  }
}

class _FeatureRequestCard extends StatefulWidget {
  final FeatureRequest request;
  final String userId;
  final bool isDeveloper;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color textColor;

  const _FeatureRequestCard({
    required this.request,
    required this.userId,
    required this.isDeveloper,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<_FeatureRequestCard> createState() => _FeatureRequestCardState();
}

class _FeatureRequestCardState extends State<_FeatureRequestCard> {
  late FeatureRequest _localRequest;

  @override
  void initState() {
    super.initState();
    _localRequest = widget.request;
  }

  @override
  void didUpdateWidget(_FeatureRequestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request != widget.request) {
      _localRequest = widget.request;
    }
  }

  void _handleUpvote() {
    final isUpvoted = _localRequest.upvoterIds.contains(widget.userId);
    final isDownvoted = _localRequest.downvoterIds.contains(widget.userId);
    
    setState(() {
      if (isUpvoted) {
        // Cancel upvote
        _localRequest = _localRequest.copyWith(
          upvoterIds: List.from(_localRequest.upvoterIds)..remove(widget.userId),
          upvotes: _localRequest.upvotes - 1,
        );
      } else {
        // Add upvote
        _localRequest = _localRequest.copyWith(
          upvoterIds: List.from(_localRequest.upvoterIds)..add(widget.userId),
          upvotes: _localRequest.upvotes + 1,
        );
        
        // If previously downvoted, remove downvote
        if (isDownvoted) {
          _localRequest = _localRequest.copyWith(
            downvoterIds: List.from(_localRequest.downvoterIds)..remove(widget.userId),
            downvotes: _localRequest.downvotes - 1,
          );
        }
      }
    });
    
    // Call the backend update
    context.read<FeatureFeedbackProvider>().updateVote(
          featureId: widget.request.id,
          userId: widget.userId,
          isUpvote: true,
        );
  }

  void _handleDownvote() {
    final isUpvoted = _localRequest.upvoterIds.contains(widget.userId);
    final isDownvoted = _localRequest.downvoterIds.contains(widget.userId);
    
    setState(() {
      if (isDownvoted) {
        // Cancel downvote
        _localRequest = _localRequest.copyWith(
          downvoterIds: List.from(_localRequest.downvoterIds)..remove(widget.userId),
          downvotes: _localRequest.downvotes - 1,
        );
      } else {
        // Add downvote
        _localRequest = _localRequest.copyWith(
          downvoterIds: List.from(_localRequest.downvoterIds)..add(widget.userId),
          downvotes: _localRequest.downvotes + 1,
        );
        
        // If previously upvoted, remove upvote
        if (isUpvoted) {
          _localRequest = _localRequest.copyWith(
            upvoterIds: List.from(_localRequest.upvoterIds)..remove(widget.userId),
            upvotes: _localRequest.upvotes - 1,
          );
        }
      }
    });
    
    // Call the backend update
    context.read<FeatureFeedbackProvider>().updateVote(
          featureId: widget.request.id,
          userId: widget.userId,
          isUpvote: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    final hasUpvoted = _localRequest.upvoterIds.contains(widget.userId);
    final hasDownvoted = _localRequest.downvoterIds.contains(widget.userId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withAlpha(13),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator bar at the top
            Container(
              height: 4,
              color: _getStatusColor(_localRequest.status),
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and developer actions row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _localRequest.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getStatusLabel(_localRequest.status),
                              style: TextStyle(
                                color: _getStatusColor(_localRequest.status),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isDeveloper) _buildStatusDropdown(context),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  Text(
                    _localRequest.description,
                    style: TextStyle(
                      color: widget.textColor.withAlpha(179),
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  
                  // Voting controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Upvote button
                      VoteButton(
                        onPressed: _handleUpvote,
                        icon: Icons.arrow_upward,
                        count: _localRequest.upvotes,
                        isActive: hasUpvoted,
                        activeColor: widget.primaryColor,
                        inactiveColor: widget.textColor.withAlpha(128),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Downvote button
                      VoteButton(
                        onPressed: _handleDownvote,
                        icon: Icons.arrow_downward,
                        count: _localRequest.downvotes,
                        isActive: hasDownvoted,
                        activeColor: widget.secondaryColor,
                        inactiveColor: widget.textColor.withAlpha(128),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: widget.textColor.withAlpha(153)),
      onSelected: (value) {
        context.read<FeatureFeedbackProvider>().updateStatus(
              featureId: widget.request.id,
              status: value,
            );
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'pending',
          child: Text('Mark as Pending'),
        ),
        const PopupMenuItem(
          value: 'approved',
          child: Text('Mark as Approved'),
        ),
        const PopupMenuItem(
          value: 'rejected',
          child: Text('Mark as Rejected'),
        ),
        const PopupMenuItem(
          value: 'implemented',
          child: Text('Mark as Implemented'),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.grey.shade400;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'implemented':
        return Colors.blue;
      default:
        return Colors.grey.shade400;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Not Planned';
      case 'implemented':
        return 'Implemented';
      default:
        return 'Pending Review';
    }
  }
}

class VoteButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final int count;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const VoteButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.count,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  State<VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isActive;
  late int _count;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    _count = widget.count;
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }
  
  @override
  void didUpdateWidget(VoteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update these values when they actually change from external state
    if (oldWidget.isActive != widget.isActive) {
      _isActive = widget.isActive;
    }
    if (oldWidget.count != widget.count) {
      _count = widget.count;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Optimistically update the UI
    setState(() {
      if (_isActive) {
        _count--;
      } else {
        _count++;
      }
      _isActive = !_isActive;
    });
    
    // Play animation
    _controller.forward().then((_) => _controller.reverse());
    
    // Call the actual action
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              _isActive ? widget.activeColor.withAlpha(26) : Colors.transparent,
          border: Border.all(
            color: _isActive ? widget.activeColor : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                widget.icon,
                size: 16,
                color: _isActive ? widget.activeColor : widget.inactiveColor,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                _count.toString(),
                key: ValueKey<int>(_count),
                style: TextStyle(
                  color: _isActive ? widget.activeColor : widget.inactiveColor,
                  fontWeight: _isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widgets

class ErrorDisplay extends StatelessWidget {
  final String message;
  final Color textColor;
  final Color backgroundColor;
  final Color primaryColor;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const ErrorDisplay({
    super.key,
    required this.message,
    required this.textColor,
    required this.backgroundColor,
    required this.primaryColor,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Error title
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Error message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: textColor.withAlpha(153),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button
              AdaptiveButton(
                onPressed: onBack,
                label: 'Go Back',
                icon: Icons.arrow_back,
                color: Colors.grey.shade200,
                textColor: textColor,
              ),
              
              const SizedBox(width: 16),
              
              // Retry button
              AdaptiveButton(
                onPressed: onRetry,
                label: 'Try Again',
                icon: Icons.refresh,
                color: primaryColor,
                textColor: Colors.white,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Help text
          Text(
            'If this problem persists, please contact support.',
            style: TextStyle(
              color: textColor.withAlpha(153),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AdaptiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;

  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.add, color: textColor, size: 16),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: textColor)),
          ],
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
