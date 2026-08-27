import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/investigation_provider.dart';
import 'providers/matchmaking_provider.dart';
import 'ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlackBoxApp());
}

class BlackBoxApp extends StatelessWidget {
  const BlackBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvestigationProvider()),
        ChangeNotifierProvider(create: (_) => MatchmakingProvider()),
      ],
      child: MaterialApp(
        title: 'Black Box: Air Crash Bureau',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
