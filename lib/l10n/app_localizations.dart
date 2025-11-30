import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Escala Mais'**
  String get appTitle;

  /// Title for the routes list screen
  ///
  /// In en, this message translates to:
  /// **'Climbing Routes'**
  String get climbingRoutes;

  /// Message shown when there are no routes
  ///
  /// In en, this message translates to:
  /// **'No routes yet'**
  String get noRoutesYet;

  /// Hint message for creating first route
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first route'**
  String get tapToCreateFirstRoute;

  /// Error message when routes fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading routes'**
  String get errorLoadingRoutes;

  /// Button text to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title for route detail screen
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// Message when a route is not found
  ///
  /// In en, this message translates to:
  /// **'Route not found'**
  String get routeNotFound;

  /// Button to go back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Message when image is not found
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// Route difficulty grade
  ///
  /// In en, this message translates to:
  /// **'Grade: {grade}'**
  String grade(String grade);

  /// Creation date label
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String created(String date);

  /// Error message when a route fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading route'**
  String get errorLoadingRoute;

  /// Title for create route screen
  ///
  /// In en, this message translates to:
  /// **'Create Route'**
  String get createRoute;

  /// Message when no image is selected
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// Option to take a photo with camera
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Option to choose image from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Validation message for image selection
  ///
  /// In en, this message translates to:
  /// **'Please select an image'**
  String get pleaseSelectImage;

  /// Error message prefix
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// Success message when route is created
  ///
  /// In en, this message translates to:
  /// **'Route created successfully!'**
  String get routeCreatedSuccessfully;

  /// Hint to add photo
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// Hint for photo source options
  ///
  /// In en, this message translates to:
  /// **'Camera or Gallery'**
  String get cameraOrGallery;

  /// Label for route name field
  ///
  /// In en, this message translates to:
  /// **'Route Name *'**
  String get routeName;

  /// Hint for route name field
  ///
  /// In en, this message translates to:
  /// **'Enter route name'**
  String get enterRouteName;

  /// Validation message for route name
  ///
  /// In en, this message translates to:
  /// **'Please enter a route name'**
  String get pleaseEnterRouteName;

  /// Label for difficulty grade field
  ///
  /// In en, this message translates to:
  /// **'Difficulty Grade (Optional)'**
  String get difficultyGradeOptional;

  /// Hint for grade field
  ///
  /// In en, this message translates to:
  /// **'e.g., 5.10a, V4, 6a+'**
  String get gradeHint;

  /// Button to save route
  ///
  /// In en, this message translates to:
  /// **'Save Route'**
  String get saveRoute;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title for dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeTitle;

  /// Subtitle for dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Toggle application theme'**
  String get darkModeSubtitle;

  /// Title for reset database option
  ///
  /// In en, this message translates to:
  /// **'Reset Database'**
  String get resetDatabaseTitle;

  /// Subtitle for reset database option
  ///
  /// In en, this message translates to:
  /// **'Delete all saved routes and restore initial data'**
  String get resetDatabaseSubtitle;

  /// Title for terms of use option
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUseTitle;

  /// Subtitle for terms of use option
  ///
  /// In en, this message translates to:
  /// **'View application terms and policies'**
  String get termsOfUseSubtitle;

  /// Title for database reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset'**
  String get confirmResetTitle;

  /// Body message for database reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all routes and revert to the initial state?'**
  String get confirmResetMessage;

  /// Cancel button text in dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Reset button text in dialogs
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// Close button text in dialogs
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Success message after database reset
  ///
  /// In en, this message translates to:
  /// **'Database successfully reset!'**
  String get resetSuccess;

  /// Failure message after database reset
  ///
  /// In en, this message translates to:
  /// **'Failed to reset database.'**
  String get resetFailure;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
