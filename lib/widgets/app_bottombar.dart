import 'package:chat_app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/navigation_provider.dart';

class AppBottombar extends ConsumerWidget {
  final Function(int index) onTap;

  const AppBottombar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: context.scaffoldBackground,
      selectedItemColor: context.primary,
      unselectedItemColor: context.onSurface,
      selectedLabelStyle: TextStyle(color: context.onSurface),
      unselectedLabelStyle: TextStyle(color: context.onSurface),
      currentIndex: currentIndex,
      onTap: (index) => onTap(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: Icon(Icons.person_3), label: 'Friends'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
