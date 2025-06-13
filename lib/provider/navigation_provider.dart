import 'package:chat_app/screens/chat/home_screen.dart';
import 'package:chat_app/screens/friends_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
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

  // Navigate to the selected screen without animation
  final String routeName;
  switch (index) {
    case 0:
      routeName = '/home';
      break;
    case 1:
      routeName = '/friends';
      break;
    case 2:
      routeName = '/search';
      break;
    case 3:
      routeName = '/profile';
      break;
    default:
      return;
  }

  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => _getRouteWidget(routeName),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

// Helper to get the widget for each route
// Anda perlu mendefinisikan fungsi ini dan mengembalikan widget yang sesuai
Widget _getRouteWidget(String routeName) {
  // Implementasikan logika untuk mengembalikan widget yang sesuai
  // berdasarkan routeName
  // Contoh (perlu disesuaikan dengan aplikasi Anda):
  switch (routeName) {
    case '/home':
      return HomeScreen(); // Ganti dengan widget screen aktual
    case '/friends':
      return FriendsScreen(); // Ganti dengan widget screen aktual
    case '/search':
      return SearchScreen(); // Ganti dengan widget screen aktual
    case '/profile':
      return ProfileScreen(); // Ganti dengan widget screen aktual
    default:
      return Container(); // Fallback
  }
}
