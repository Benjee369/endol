import 'package:endol/constants/app_colors.dart';
import 'package:endol/constants/fonts.dart';
import 'package:endol/providers/budget_provider.dart';
import 'package:endol/providers/current_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../endol/endol_splash/screens/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BudgetProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: AppColors.thatBrown,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: Fonts.medium,
          splashColor: AppColors.lightBrown.withOpacity(0.15),
          textTheme: GoogleFonts.workSansTextTheme(),
        ),
      ),
    );
  }
}
