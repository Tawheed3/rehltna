import 'package:flutter/material.dart';

/// Shared navigator key — used by GoRouter and NotificationService
/// so the service can navigate without a BuildContext.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
