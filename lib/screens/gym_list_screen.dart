import 'package:escala_mais/core/logging/app_logger.dart';
import 'package:escala_mais/screens/gym_route_list_screen.dart';
import 'package:escala_mais/screens/settings_screen.dart';
import 'package:escala_mais/theme/app_theme.dart';
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
    final encodedAddress = Uri.encodeComponent(address);
    logInfo('Opening maps for gym address', {'encodedAddress': encodedAddress});

    final geoUrl = Uri.parse('geo:0,0?q=$encodedAddress');

    final canLaunchGeo = await canLaunchUrl(geoUrl);
    if (!context.mounted) return;

    if (canLaunchGeo) {
      logDebug('Launching geo URL', {'url': geoUrl.toString()});
      await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final googleMapsUrl = Uri.parse(
      'http://googleusercontent.com/maps.google.com/q=$encodedAddress',
    );

    final canLaunchGoogle = await canLaunchUrl(googleMapsUrl);
    if (!context.mounted) return;

    if (canLaunchGoogle) {
      logDebug('Launching Google Maps URL', {'url': googleMapsUrl.toString()});
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final appleMapsUrl = Uri.parse('http://maps.apple.com/?q=$encodedAddress');

    final canLaunchApple = await canLaunchUrl(appleMapsUrl);
    if (!context.mounted) return;

    if (canLaunchApple) {
      logDebug('Launching Apple Maps URL', {'url': appleMapsUrl.toString()});
      await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    logWarning('No map application available for address', {
      'encodedAddress': encodedAddress,
    });

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
    if (!context.mounted) return false;

    if (result == true) {
      try {
        final repository = ref.read(gymRepositoryProvider);
        await repository.deleteGym(gymId);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.gymDeletedSuccessfully),
              backgroundColor: Theme.of(context).colorScheme.success,
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
    logInfo('GymListScreen build called');
    final gymsAsync = ref.watch(gymsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.climbingGyms),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              logInfo('Navigating to SettingsScreen');
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
          logInfo('Loaded gyms data', {'count': gyms.length});
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

          return OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              if (isLandscape) {
                logDebug('Rendering gyms in grid layout', {
                  'count': gyms.length,
                });
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: gyms.length,
                  itemBuilder: (context, index) {
                    final gym = gyms[index];
                    final hasAddress =
                        gym.location != null && gym.location!.isNotEmpty;

                    return Dismissible(
                      key: Key(gym.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        logInfo('Request delete gym (landscape)', {
                          'gymId': gym.id,
                          'gymName': gym.name,
                        });
                        return _showDeleteConfirmation(
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
                        child: ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: Text(gym.name),
                          subtitle: Text(
                            gym.location ?? l10n.noLocationProvided,
                          ),
                          trailing: Builder(
                            builder: (context) => IconButton(
                              icon: Icon(
                                Icons.map,
                                color: hasAddress
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[400],
                              ),
                              onPressed: hasAddress
                                  ? () {
                                      logInfo('Gym map icon tapped', {
                                        'gymId': gym.id,
                                        'gymName': gym.name,
                                      });
                                    _openGoogleMaps(
                                      context,
                                      gym.location!,
                                      l10n,
                                    );
                                  }
                                : null,
                            ),
                          ),
                          onTap: () {
                            logInfo('Navigating to GymRouteListScreen', {
                              'gymId': gym.id,
                              'gymName': gym.name,
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GymRouteListScreen(
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
              }

              logDebug('Rendering gyms in list layout', {'count': gyms.length});
              return ListView.builder(
                itemCount: gyms.length,
                itemBuilder: (context, index) {
                  final gym = gyms[index];
                  final hasAddress =
                      gym.location != null && gym.location!.isNotEmpty;

                  return Dismissible(
                    key: Key(gym.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) {
                      logInfo('Request delete gym (portrait)', {
                        'gymId': gym.id,
                        'gymName': gym.name,
                      });
                      return _showDeleteConfirmation(
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
                        trailing: Builder(
                          builder: (context) => IconButton(
                            icon: Icon(
                              Icons.map,
                              color: hasAddress
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[400],
                            ),
                            onPressed: hasAddress
                                ? () {
                                    logInfo('Gym map icon tapped', {
                                      'gymId': gym.id,
                                      'gymName': gym.name,
                                    });
                                  _openGoogleMaps(context, gym.location!, l10n);
                                }
                                : null,
                          ),
                        ),
                        onTap: () {
                          logInfo('Navigating to GymRouteListScreen', {
                            'gymId': gym.id,
                            'gymName': gym.name,
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GymRouteListScreen(
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.error(error.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logInfo('Navigating to CreateGymScreen');
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
