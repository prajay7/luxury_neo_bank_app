import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/obsidian_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI to immersive luxury dark styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF08090C),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ObsidianWealthApp());
}

/// Root Application for Obsidian Wealth
class ObsidianWealthApp extends StatelessWidget {
  const ObsidianWealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obsidian Wealth',
      debugShowCheckedModeBanner: false,
      theme: ObsidianTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
