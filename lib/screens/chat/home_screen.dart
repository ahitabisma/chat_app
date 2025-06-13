import 'package:chat_app/provider/navigation_provider.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/themes/app_theme.dart';
import 'package:chat_app/widgets/app_bottombar.dart';
import 'package:chat_app/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/provider/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Chat Dummy Data
  List<Map<String, dynamic>> chats = [
    {
      'name': 'Sarah Wilson',
      'message': 'Hey! How are you doing today?',
      'time': '2:30 PM',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'Design Team',
      'message': 'Nice. The new mockups look great!',
      'time': '1:45 PM',
      'timestamp': DateTime.now().subtract(
        const Duration(hours: 1, minutes: 15),
      ),
      'avatar': 'https://randomuser.me/api/portraits/men/10.jpg',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Michael Chen',
      'message': 'Let\'s meet tomorrow at 3 PM',
      'time': '11:20 AM',
      'timestamp': DateTime.now().subtract(
        const Duration(hours: 3, minutes: 40),
      ),
      'avatar': 'https://randomuser.me/api/portraits/men/15.jpg',
      'unread': 0,
      'online': true,
    },
    {
      'name': 'Anna Taylor',
      'message': 'Can you review my PR?',
      'time': '10:00 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'avatar': 'https://randomuser.me/api/portraits/women/20.jpg',
      'unread': 5,
      'online': false,
    },
    {
      'name': 'Marketing Team',
      'message': 'The campaign is ready to launch',
      'time': 'Yesterday',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'avatar': 'https://randomuser.me/api/portraits/women/25.jpg',
      'unread': 3,
      'online': true,
    },
    {
      'name': 'John Smith',
      'message': 'Let me know when you\'re free',
      'time': 'Yesterday',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      'avatar': 'https://randomuser.me/api/portraits/men/20.jpg',
      'unread': 0,
      'online': false,
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get sortedChats {
    return List.from(chats)..sort((a, b) {
      // First sort by unread count (descending)
      int unreadCompare = b['unread'].compareTo(a['unread']);
      if (unreadCompare != 0) return unreadCompare;

      // Then sort by timestamp (most recent first)
      return b['timestamp'].compareTo(a['timestamp']);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationProvider.notifier).setIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState['user'];

    // Theme
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: context.onSecondary,
        title: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(color: context.onSurface, fontSize: 14),
                ),
                Text(
                  'Username',
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            color: context.onSurface,
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your chat...',
                hintStyle: TextStyle(color: context.onSurface),
                prefixIcon: Icon(Icons.search, color: context.onSurface),
                filled: true,
                fillColor: context.onSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
              ),
              style: TextStyle(color: context.onSurface),
            ),
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return ChatListItem(chat: chat);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottombar(
        onTap: (index) => handleNavigation(context, ref, index),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(Icons.add, color: context.scaffoldBackground),
        onPressed: () {},
      ),
    );
  }
}
