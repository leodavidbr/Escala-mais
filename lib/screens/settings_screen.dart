import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/route_providers.dart';
import '../theme/theme_mode_notifier.dart';
import '../theme/locale_notifier.dart';

const String _termsOfUseContent = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis 
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore 
eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt 
in culpa qui officia deserunt mollit anim id est laborum.

Section 1: Acceptance
By using this application, you agree to these terms. If you do not agree, do not use the app.

Section 2: Data Usage
We value your privacy. All climbing route data is stored locally on your device 
using a local SQLite database and local file storage. We do not transmit or 
store your personal climbing data on external servers.
''';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.darkModeTitle),
            subtitle: Text(l10n.darkModeSubtitle),
            leading: const Icon(Icons.brightness_6),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (isDark) {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          const Divider(),

          ListTile(
            title: Text(l10n.languageTitle),
            subtitle: Text(l10n.languageSubtitle),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context, ref, l10n),
          ),
          const Divider(),

          ListTile(
            title: Text(l10n.resetDatabaseTitle),
            subtitle: Text(l10n.resetDatabaseSubtitle),
            leading: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.error,
            ),
            onTap: () => _showResetDialog(context, ref, l10n),
          ),
          const Divider(),

          ListTile(
            title: Text(l10n.termsOfUseTitle),
            subtitle: Text(l10n.termsOfUseSubtitle),
            leading: const Icon(Icons.description),
            onTap: () => _showTermsOfUse(context, l10n),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale?>(
              title: Text(l10n.systemDefault),
              value: null,
              groupValue: currentLocale,
              onChanged: (value) {
                ref.read(localeProvider.notifier).setSystemDefault();
                Navigator.of(ctx).pop();
              },
            ),
            RadioListTile<Locale?>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (value) {
                ref.read(localeProvider.notifier).setEnglish();
                Navigator.of(ctx).pop();
              },
            ),
            RadioListTile<Locale?>(
              title: Text(l10n.portuguese),
              value: const Locale('pt', 'BR'),
              groupValue: currentLocale,
              onChanged: (value) {
                ref.read(localeProvider.notifier).setPortuguese();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfUse(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.termsOfUseTitle),
        content: SingleChildScrollView(child: Text(_termsOfUseContent)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.closeButton),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmResetTitle),
        content: Text(l10n.confirmResetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _resetData(context, ref, l10n);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.resetButton),
          ),
        ],
      ),
    );
  }

  Future<void> _resetData(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final gymResetSuccess = await ref
        .read(gymRepositoryProvider)
        .resetDatabase();
    if (gymResetSuccess) {
      await ref.read(routeRepositoryProvider).resetDatabase();

      ref.invalidate(gymsProvider);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.resetSuccess),
          backgroundColor: Theme.of(context).colorScheme.success,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.resetFailure),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
