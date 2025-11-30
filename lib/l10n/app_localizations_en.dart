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

  @override
  String get settings => 'Settings';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Toggle application theme';

  @override
  String get resetDatabaseTitle => 'Reset Database';

  @override
  String get resetDatabaseSubtitle =>
      'Delete all saved routes and restore initial data';

  @override
  String get termsOfUseTitle => 'Terms of Use';

  @override
  String get termsOfUseSubtitle => 'View application terms and policies';

  @override
  String get confirmResetTitle => 'Confirm Reset';

  @override
  String get confirmResetMessage =>
      'Are you sure you want to delete all routes and revert to the initial state?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get resetButton => 'Reset';

  @override
  String get closeButton => 'Close';

  @override
  String get resetSuccess => 'Database successfully reset!';

  @override
  String get resetFailure => 'Failed to reset database.';

  @override
  String get climbingGyms => 'Climbing Gyms';

  @override
  String get noGymsYet => 'No gyms registered yet';

  @override
  String get tapToCreateFirstGym =>
      'Tap the + button to register the first gym';

  @override
  String get noLocationProvided => 'Location not provided';

  @override
  String get createGym => 'Register Gym';

  @override
  String get gymName => 'Gym Name *';

  @override
  String get enterGymName => 'Enter gym name';

  @override
  String get pleaseEnterGymName => 'Please enter the gym name';

  @override
  String get gymLocationOptional => 'Location (Optional)';

  @override
  String get enterGymLocation => 'e.g.: New York, NY';

  @override
  String get saveGym => 'Save Gym';

  @override
  String get gymCreatedSuccessfully => 'Gym registered successfully!';

  @override
  String get deleteRoute => 'Delete Route';

  @override
  String get confirmDeleteRouteTitle => 'Confirm Deletion';

  @override
  String confirmDeleteRouteMessage(String routeName) {
    return 'Are you sure you want to delete the route \'$routeName\'? This action cannot be undone.';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String get routeDeletedSuccessfully => 'Route deleted successfully!';

  @override
  String get errorDeletingRoute => 'Error deleting route';
}
