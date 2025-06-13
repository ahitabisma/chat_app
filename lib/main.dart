import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/register_screen.dart';
import 'package:chat_app/screens/friends_screen.dart';
import 'package:chat_app/screens/chat/home_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/themes/dark_theme.dart';
import 'package:chat_app/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // ignore: avoid_print
    print('Error loading .env file: $e');
    throw Exception('Failed to load .env file');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // Check authentication status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state to determine which screen to show
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);

    // Debug auth state
    print('Current auth state: ${authState['status']}');
    if (authState['user'] != null) {
      print('User data: ${authState['user']}');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: themeMode,
      home: _buildHomeScreen(authState),
      // home: HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/friends': (context) => const FriendsScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }

  Widget _buildHomeScreen(Map<String, dynamic> authState) {
    final status = authState['status'];

    // Show loading screen while checking authentication
    if (status == AuthState.initial || status == AuthState.loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show home screen if authenticated, otherwise login screen
    if (status == AuthState.authenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
