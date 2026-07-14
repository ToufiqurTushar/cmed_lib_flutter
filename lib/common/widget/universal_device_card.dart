import 'package:flutter/material.dart';

import '../../page/health_screening/npage/auto/enum/screen_enum.dart';

class UniversalDeviceCard extends StatelessWidget {
  final DeviceUiState uiState;
  final VoidCallback? onActionPressed;

  const UniversalDeviceCard({
    super.key,
    required this.uiState,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine whether to display animated elements based on structural type flags
    final showLoading = uiState.type == DeviceUiType.loadingProgress;
    final showActionButton = uiState.type == DeviceUiType.interactiveAction ||
        uiState.type == DeviceUiType.errorFault ||
        uiState.actionButtonLabel != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Standard Visual Anchor Icon
          if(uiState.child != null)
            uiState.child!,

          if(uiState.icon != null)
            Icon(
              uiState.icon,
              size: 64,
              color: uiState.themeColor,
            ),
          const SizedBox(height: 16),

          // Text Header Layer
          Text(
            uiState.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: uiState.themeColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            uiState.subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),

          // Telemetry Reading Output Display Area
          if (uiState.value != null) ...[
            const SizedBox(height: 24),
            Text(
              uiState.value!,
              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: 1.1),
              textAlign: TextAlign.center,
            ),
          ],

          // Execution Loop Linear Indication
          if (showLoading) ...[
            const SizedBox(height: 24),
            LinearProgressIndicator(
              color: uiState.themeColor,
              backgroundColor: uiState.themeColor.withOpacity(0.2),
            ),
          ],

          // Contextual Action Layer
          if (showActionButton && onActionPressed != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uiState.themeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.touch_app),
                label: Text(uiState.actionButtonLabel ?? 'Proceed'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

