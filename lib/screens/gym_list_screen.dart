import 'package:escala_mais/screens/gym_route_list_screen.dart';
import 'package:escala_mais/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/route_providers.dart';
import 'create_gym_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen displaying a list of all climbing gyms.
class GymListScreen extends ConsumerWidget {
  const GymListScreen({super.key});

  Future<void> _openGoogleMaps(
    BuildContext context,
    String address,
    AppLocalizations l10n,
  ) async {
    final encoded = Uri.encodeComponent(address);

    final geoUrl = Uri.parse('geo:0,0?q=$encoded');

    if (await canLaunchUrl(geoUrl)) {
      await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final googleMapsIOS = Uri.parse('comgooglemaps://?q=$encoded');

    if (await canLaunchUrl(googleMapsIOS)) {
      await launchUrl(googleMapsIOS, mode: LaunchMode.externalApplication);
      return;
    }

    final appleMapsUrl = Uri.parse('http://maps.apple.com/?q=$encoded');

    if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final webUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );

    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.mapAppError),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String gymName,
    String gymId,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.confirmDeleteGymTitle),
          content: Text(l10n.confirmDeleteGymMessage(gymName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.deleteButton),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final repository = ref.read(gymRepositoryProvider);
        await repository.deleteGym(gymId);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.gymDeletedSuccessfully),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorDeletingGym}: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gymsAsync = ref.watch(gymsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.climbingGyms),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: gymsAsync.when(
        data: (gyms) {
          if (gyms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noGymsYet,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToCreateFirstGym,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: gyms.length,
            itemBuilder: (context, index) {
              final gym = gyms[index];
              final hasAddress =
                  gym.location != null && gym.location!.isNotEmpty;

              return Dismissible(
                key: Key(gym.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await _showDeleteConfirmation(
                    context,
                    gym.name,
                    gym.id,
                    ref,
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(gym.name),
                    subtitle: Text(gym.location ?? l10n.noLocationProvided),

                    trailing: IconButton(
                      icon: Icon(
                        Icons.map,
                        color: hasAddress
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[400],
                      ),
                      onPressed: hasAddress
                          ? () => _openGoogleMaps(context, gym.location!, l10n)
                          : null,
                      tooltip: hasAddress
                          ? l10n.openInMaps
                          : l10n.noLocationProvided,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GymRouteListScreen(
                            gymId: gym.id,
                            gymName: gym.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.error(error.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGymScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
