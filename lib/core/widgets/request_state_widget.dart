import 'package:flutter/material.dart';

import 'empty_state_widget.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

class RequestStateWidget extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final VoidCallback? onRetry;
  final Widget child;
  final Widget? loading;
  final Widget? empty;
  final Widget? error;

  const RequestStateWidget({
    super.key,
    required this.child,
    this.isLoading = false,
    this.errorMessage,
    this.isEmpty = false,
    this.onRetry,
    this.loading,
    this.empty,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loading ?? const LoadingWidget(isExpanded: true);
    }

    if (errorMessage != null && errorMessage!.trim().isNotEmpty) {
      return error ??
          AppErrorWidget(
            message: errorMessage!,
            onRetry: onRetry,
            title: 'Error',
          );
    }

    if (isEmpty) {
      return empty ??
          const EmptyStateWidget(
            title: 'Sin resultados',
            message: 'Aun no hay informacion para mostrar.',
          );
    }

    return child;
  }
}
