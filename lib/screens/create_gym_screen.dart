import 'package:escala_mais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/route_providers.dart';

/// Screen for creating a new climbing gym.
class CreateGymScreen extends ConsumerStatefulWidget {
  const CreateGymScreen({super.key});

  @override
  ConsumerState<CreateGymScreen> createState() => _CreateGymScreenState();
}

class _CreateGymScreenState extends ConsumerState<CreateGymScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  bool _isSearchingCep = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _searchCep() async {
    final cep = _cepController.text.trim();
    if (cep.isEmpty || cep.length < 8) return;

    setState(() {
      _isSearchingCep = true;
    });

    final l10n = AppLocalizations.of(context)!;
    final cepService = ref.read(cepServiceProvider);
    final result = await cepService.fetchAddress(cep);

    if (mounted) {
      setState(() {
        _isSearchingCep = false;
      });

      if (result != null) {
        _streetController.text = result.street;
        _neighborhoodController.text = result.neighborhood;
        _cityController.text = result.locality;
        _stateController.text = result.uf;

        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cepNotFound),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  Future<void> _saveGym() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    final locationString = [
      _streetController.text.trim(),
      _numberController.text.trim().isNotEmpty
          ? 'nº ${_numberController.text.trim()}'
          : '',
      _complementController.text.trim(),
      _neighborhoodController.text.trim(),
      _cityController.text.trim(),
      _stateController.text.trim(),
      _cepController.text.trim(),
    ].where((s) => s.isNotEmpty).join(', ');

    if (locationString.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseCompleteAddress),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final createGymNotifier = ref.read(createGymProvider.notifier);

    await createGymNotifier.createGym(
      name: _nameController.text.trim(),
      location: locationString,
    );

    if (mounted) {
      final state = ref.read(createGymProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.error(state.error!)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.gymCreatedSuccessfully),
            backgroundColor: Theme.of(context).colorScheme.success,
          ),
        );
        createGymNotifier.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createGymProvider);
    final isSaving = state.isLoading || _isSearchingCep;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createGym)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.gymName,
                  hintText: l10n.enterGymName,
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterGymName;
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.addressDetails,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.cepLabel,
                        hintText: 'Ex: 01000-000',
                        prefixIcon: const Icon(Icons.pin_drop),
                      ),
                      validator: (value) => (value == null || value.length < 8)
                          ? l10n.validCepRequired
                          : null,
                      onFieldSubmitted: (_) => _searchCep(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSearchingCep ? null : _searchCep,
                      child: _isSearchingCep
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.searchCep),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.streetLabel,
                  prefixIcon: const Icon(Icons.streetview),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? l10n.streetRequired
                    : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.numberLabel,
                        prefixIcon: const Icon(Icons.format_list_numbered),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? l10n.numberRequired
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _complementController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: l10n.complementLabel,
                        hintText: l10n.optional,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _neighborhoodController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.neighborhoodLabel,
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: l10n.cityLabel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _stateController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: l10n.stateLabel),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isSaving ? null : _saveGym,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.saveGym, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
