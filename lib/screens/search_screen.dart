import 'package:chat_app/provider/navigation_provider.dart';
import 'package:chat_app/themes/app_theme.dart';
import 'package:chat_app/widgets/app_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/provider/auth_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationProvider.notifier).setIndex(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState['user'];

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: context.scaffoldBackground,
        title: Text(
          'Search',
          style: TextStyle(
            color: context.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search people, groups, and others...',
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
          ],
        ),
      ),
      bottomNavigationBar: AppBottombar(
        onTap: (index) => handleNavigation(context, ref, index),
      ),
    );
  }
}
