import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double indicatorSize;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  const LoadingWidget({
    super.key,
    this.message,
    this.indicatorSize = 26,
    this.isExpanded = false,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: indicatorSize,
            width: indicatorSize,
            child: const CircularProgressIndicator(strokeWidth: 2.6),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );

    if (isExpanded) {
      return Center(child: content);
    }
    return content;
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.25),
              child: LoadingWidget(
                isExpanded: true,
                message: message ?? 'Cargando...',
              ),
            ),
          ),
      ],
    );
  }
}
