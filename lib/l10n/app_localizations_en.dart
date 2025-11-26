// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Escala Mais';

  @override
  String get climbingRoutes => 'Climbing Routes';

  @override
  String get noRoutesYet => 'No routes yet';

  @override
  String get tapToCreateFirstRoute =>
      'Tap the + button to create your first route';

  @override
  String get errorLoadingRoutes => 'Error loading routes';

  @override
  String get retry => 'Retry';

  @override
  String get routeDetails => 'Route Details';

  @override
  String get routeNotFound => 'Route not found';

  @override
  String get goBack => 'Go Back';

  @override
  String get imageNotFound => 'Image not found';

  @override
  String grade(String grade) {
    return 'Grade: $grade';
  }

  @override
  String created(String date) {
    return 'Created: $date';
  }

  @override
  String get errorLoadingRoute => 'Error loading route';

  @override
  String get createRoute => 'Create Route';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get pleaseSelectImage => 'Please select an image';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get routeCreatedSuccessfully => 'Route created successfully!';

  @override
  String get tapToAddPhoto => 'Tap to add photo';

  @override
  String get cameraOrGallery => 'Camera or Gallery';

  @override
  String get routeName => 'Route Name *';

  @override
  String get enterRouteName => 'Enter route name';

  @override
  String get pleaseEnterRouteName => 'Please enter a route name';

  @override
  String get difficultyGradeOptional => 'Difficulty Grade (Optional)';

  @override
  String get gradeHint => 'e.g., 5.10a, V4, 6a+';

  @override
  String get saveRoute => 'Save Route';
}
