import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((
  ref,
) {
  return NavigationNotifier();
});

// Navigation utility function to avoid repeating code across screens
void handleNavigation(BuildContext context, WidgetRef ref, int index) {
  ref.read(navigationProvider.notifier).setIndex(index);

  // Navigate to the selected screen
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacementNamed('/home');
      break;
    case 1:
      Navigator.of(context).pushReplacementNamed('/friends');
      break;
    case 2:
      Navigator.of(context).pushReplacementNamed('/search');
      break;
    case 3:
      Navigator.of(context).pushReplacementNamed('/profile');
      break;
    default:
      break;
  }
}
