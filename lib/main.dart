import 'package:flutter/material.dart';
import 'package:expatrio/router/app_router.dart';
import 'package:expatrio/core/service_locator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  
  runApp(const ExpatrioApp());
}

class ExpatrioApp extends StatelessWidget {
  const ExpatrioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expatrio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C853)), // Green for progress
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
