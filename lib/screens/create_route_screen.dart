import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/route_providers.dart';

/// Screen for creating a new climbing route.
class CreateRouteScreen extends ConsumerStatefulWidget {
  final String gymId;
  const CreateRouteScreen({super.key, required this.gymId});

  @override
  ConsumerState<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends ConsumerState<CreateRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGrade;
  File? _selectedImage;
  bool _isSaving = false;

  final List<String> _grades = ['v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool fromCamera) async {
    final imageService = ref.read(imageServiceProvider);
    final image = await imageService.pickImage(fromCamera: fromCamera);

    if (image != null && mounted) {
      setState(() {
        _selectedImage = image;
      });
    } else if (mounted && image == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noImageSelected)));
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRoute() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectImage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final storageService = ref.read(storageServiceProvider);
      final savedImagePath = await storageService.saveImage(_selectedImage!);

      final createRouteNotifier = ref.read(createRouteProvider.notifier);
      await createRouteNotifier.createRoute(
        gymId: widget.gymId,
        name: _nameController.text.trim(),
        grade: _selectedGrade,
        photoPath: savedImagePath,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final state = ref.read(createRouteProvider);
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
              content: Text(l10n.routeCreatedSuccessfully),
              backgroundColor: Theme.of(context).colorScheme.success,
            ),
          );
          createRouteNotifier.reset();
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createRoute)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker section
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.placeholder,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.placeholderIcon.withValues(alpha: 0.5),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 64,
                              color: theme.colorScheme.placeholderIcon,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.tapToAddPhoto,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.placeholderIcon,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.cameraOrGallery,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.placeholderIcon.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.routeName,
                  hintText: l10n.enterRouteName,
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterRouteName;
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              // Grade dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedGrade,
                decoration: InputDecoration(
                  labelText: l10n.difficultyGradeOptional,
                  hintText: l10n.gradeHint,
                  prefixIcon: const Icon(Icons.trending_up),
                ),
                isExpanded: true,
                menuMaxHeight: 300,
                dropdownColor: Theme.of(context).colorScheme.surface,
                items: _grades.map((grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGrade = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Save button
              ElevatedButton(
                onPressed: _isSaving ? null : _saveRoute,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l10n.saveRoute,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
