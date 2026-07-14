

import 'package:flutter/material.dart';

enum ScreenEnum{
  CONNECT,
  CONNECTING,
  FINGER_OUT,
  FINGER_IN,
  SEARCHING,
  MEASURING,
  RESULT_FOUND,
  DISCONNECTED,
  DEVICE_NOT_FOUND,
  CONNECTED,
  ERROR,
}


/// Standard structural types that dictate how the UI renders
enum DeviceUiType {
  idle,
  interactiveAction,
  loadingProgress,
  successDone,
  errorFault,
}

/// The universal payload the widget uses to draw its components
class DeviceUiState {
  final DeviceUiType type;
  final String title;
  final String subtitle;
  final String? value;
  IconData? icon;
  Widget? child;
  final Color themeColor;
  final String? actionButtonLabel;

  DeviceUiState({
    required this.type,
    required this.title,
    required this.subtitle,
    this.value,
    this.icon,
    this.child,
    required this.themeColor,
    this.actionButtonLabel,
  });
}
