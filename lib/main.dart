import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// ============================================================
/// MAIN ENTRY POINT - RIVERPOD SETUP
/// ============================================================
///
/// WHAT IS RIVERPOD?
/// Riverpod is a state management solution for Flutter that's:
/// - Type-safe (catches errors at compile time)
/// - Testable (easy to write unit tests)
/// - No BuildContext needed (can use anywhere)
/// - Composable (providers can depend on other providers)
///
/// WHY WRAP WITH ProviderScope?
/// - ProviderScope is the root widget that enables Riverpod
/// - ALL providers in your app must be under a ProviderScope
/// - Think of it as the "container" that holds all your state
///
/// Without ProviderScope, Riverpod won't work!
void main() {
  runApp(
    // ProviderScope enables Riverpod for the entire app
    const ProviderScope(
      child: App(),
    ),
  );
}
