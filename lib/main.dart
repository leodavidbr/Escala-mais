import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/route_list_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EscalaMaisApp(),
    ),
  );
}

class EscalaMaisApp extends StatelessWidget {
  const EscalaMaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escala Mais',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt', 'BR'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // If device locale is English, use English
        if (locale != null && locale.languageCode == 'en') {
          return locale;
        }
        // If device locale is pt_BR, use pt_BR
        if (locale != null && 
            locale.languageCode == 'pt' && 
            locale.countryCode == 'BR') {
          return locale;
        }
        // For any other language, default to pt_BR
        return const Locale('pt', 'BR');
      },
      home: const RouteListScreen(),
    );
  }
}
