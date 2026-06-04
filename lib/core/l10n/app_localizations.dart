import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get navTickets;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'TRAVEL SMART'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover Egypt'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore every corner of Egypt...'**
  String get onboardingDesc1;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'STAY INFORMED'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Updates'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Get instant notifications...'**
  String get onboardingDesc2;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'TRAVEL CONFIDENT'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Secure & Reliable'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Book with confidence...'**
  String get onboardingDesc3;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome \nBack.'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the future of travel'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @sectionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get sectionPersonal;

  /// No description provided for @sectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get sectionContact;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @genderError.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender.'**
  String get genderError;

  /// No description provided for @countryError.
  ///
  /// In en, this message translates to:
  /// **'Please select your country.'**
  String get countryError;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get signOutTitle;

  /// No description provided for @signOutMsg.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again...'**
  String get signOutMsg;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @signOutBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutBtn;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @noRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get noRecentSearches;

  /// No description provided for @myTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get myTickets;

  /// No description provided for @digitalWallet.
  ///
  /// In en, this message translates to:
  /// **'Your digital travel wallet'**
  String get digitalWallet;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @tabPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tabPast;

  /// No description provided for @noUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trips'**
  String get noUpcoming;

  /// No description provided for @noActive.
  ///
  /// In en, this message translates to:
  /// **'No trips departing soon'**
  String get noActive;

  /// No description provided for @noPast.
  ///
  /// In en, this message translates to:
  /// **'No past trips'**
  String get noPast;

  /// No description provided for @actionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Action successful.'**
  String get actionSuccess;

  /// No description provided for @tapRefresh.
  ///
  /// In en, this message translates to:
  /// **'Tap the refresh button above'**
  String get tapRefresh;

  /// No description provided for @useRefresh.
  ///
  /// In en, this message translates to:
  /// **'Use the refresh button above'**
  String get useRefresh;

  /// No description provided for @resellTitle.
  ///
  /// In en, this message translates to:
  /// **'Resell Tickets'**
  String get resellTitle;

  /// No description provided for @resellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your unused tickets into cash'**
  String get resellSubtitle;

  /// No description provided for @yourUpcomingTickets.
  ///
  /// In en, this message translates to:
  /// **'Your Upcoming Tickets'**
  String get yourUpcomingTickets;

  /// No description provided for @statAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statAvailable;

  /// No description provided for @statListed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get statListed;

  /// No description provided for @statEstValue.
  ///
  /// In en, this message translates to:
  /// **'Est. Value'**
  String get statEstValue;

  /// No description provided for @listedOnMarket.
  ///
  /// In en, this message translates to:
  /// **'Listed on Marketplace'**
  String get listedOnMarket;

  /// No description provided for @availableForSale.
  ///
  /// In en, this message translates to:
  /// **'Available for Sale'**
  String get availableForSale;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{n} day(s) left'**
  String daysLeft(String n);

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total price:'**
  String get totalPrice;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @listForSale.
  ///
  /// In en, this message translates to:
  /// **'List Ticket for Sale'**
  String get listForSale;

  /// No description provided for @askingPrice.
  ///
  /// In en, this message translates to:
  /// **'Asking price'**
  String get askingPrice;

  /// No description provided for @listTicketBtn.
  ///
  /// In en, this message translates to:
  /// **'List Ticket'**
  String get listTicketBtn;

  /// No description provided for @cancelListing.
  ///
  /// In en, this message translates to:
  /// **'Cancel Listing'**
  String get cancelListing;

  /// No description provided for @cancelListingMsg.
  ///
  /// In en, this message translates to:
  /// **'This booking is currently listed...'**
  String get cancelListingMsg;

  /// No description provided for @cancelListingPrompt.
  ///
  /// In en, this message translates to:
  /// **'This booking is currently listed on the marketplace. Do you want to remove it from sale?'**
  String get cancelListingPrompt;

  /// No description provided for @noResellable.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tickets available for resale.'**
  String get noResellable;

  /// No description provided for @resellRules.
  ///
  /// In en, this message translates to:
  /// **'Only confirmed, upcoming tickets...'**
  String get resellRules;

  /// No description provided for @listingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Listing updated successfully!'**
  String get listingUpdated;

  /// No description provided for @priceMustBePos.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0.'**
  String get priceMustBePos;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price is {n} EGP.'**
  String maxPrice(String n);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @lowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get lowestPrice;

  /// No description provided for @shortestDuration.
  ///
  /// In en, this message translates to:
  /// **'Shortest Duration'**
  String get shortestDuration;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure Time'**
  String get departureTime;

  /// No description provided for @maxPriceText.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPriceText;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @searchIndirectTrips.
  ///
  /// In en, this message translates to:
  /// **'Search Indirect Trips'**
  String get searchIndirectTrips;

  /// No description provided for @noTripsFound.
  ///
  /// In en, this message translates to:
  /// **'No trips found'**
  String get noTripsFound;

  /// No description provided for @searchingConnectingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Searching for connecting routes...'**
  String get searchingConnectingRoutes;

  /// No description provided for @noConnectingRoutes.
  ///
  /// In en, this message translates to:
  /// **'No connecting routes found.'**
  String get noConnectingRoutes;

  /// No description provided for @connectingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Connecting Routes'**
  String get connectingRoutes;

  /// No description provided for @noDirectTripsFound.
  ///
  /// In en, this message translates to:
  /// **'No direct trips found'**
  String get noDirectTripsFound;

  /// No description provided for @trySearchingIndirect.
  ///
  /// In en, this message translates to:
  /// **'Try searching for connecting routes with 1 stop'**
  String get trySearchingIndirect;

  /// No description provided for @fillFromToBeforeReverse.
  ///
  /// In en, this message translates to:
  /// **'Please fill From and To before reversing.'**
  String get fillFromToBeforeReverse;

  /// No description provided for @fillFromToBeforeReturn.
  ///
  /// In en, this message translates to:
  /// **'Please fill From and To before returning.'**
  String get fillFromToBeforeReturn;

  /// No description provided for @selectDepartureGov.
  ///
  /// In en, this message translates to:
  /// **'Please select departure governorate'**
  String get selectDepartureGov;

  /// No description provided for @selectDestinationGov.
  ///
  /// In en, this message translates to:
  /// **'Please select destination governorate'**
  String get selectDestinationGov;

  /// No description provided for @destMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'Destination must differ from departure'**
  String get destMustDiffer;

  /// No description provided for @destGovMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'Destination governorate must differ from departure'**
  String get destGovMustDiffer;

  /// No description provided for @selectDepartureDate.
  ///
  /// In en, this message translates to:
  /// **'Please select departure date'**
  String get selectDepartureDate;

  /// No description provided for @selectReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a return date'**
  String get selectReturnDate;

  /// No description provided for @returnDateBeforeDep.
  ///
  /// In en, this message translates to:
  /// **'Return date cannot be before departure'**
  String get returnDateBeforeDep;

  /// No description provided for @dateCannotBeEarlier.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be earlier than previous leg'**
  String get dateCannotBeEarlier;

  /// No description provided for @useStandardSearchSingleTrip.
  ///
  /// In en, this message translates to:
  /// **'Please use the Standard Search for a single trip.'**
  String get useStandardSearchSingleTrip;

  /// No description provided for @loadingStations.
  ///
  /// In en, this message translates to:
  /// **'Loading stations...'**
  String get loadingStations;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @fromGov.
  ///
  /// In en, this message translates to:
  /// **'From Governorate'**
  String get fromGov;

  /// No description provided for @toGov.
  ///
  /// In en, this message translates to:
  /// **'To Governorate'**
  String get toGov;

  /// No description provided for @multiDestNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Choose one of these options only after completing your full trip plan.'**
  String get multiDestNote;

  /// No description provided for @stepByStepReverse.
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step Reverse'**
  String get stepByStepReverse;

  /// No description provided for @directReturn.
  ///
  /// In en, this message translates to:
  /// **'Direct Return'**
  String get directReturn;

  /// No description provided for @fillFromToBeforeAdding.
  ///
  /// In en, this message translates to:
  /// **'Please fill From and To before adding a new trip.'**
  String get fillFromToBeforeAdding;

  /// No description provided for @addAnotherDestination.
  ///
  /// In en, this message translates to:
  /// **'Add another destination'**
  String get addAnotherDestination;

  /// No description provided for @undoAutoGeneratedTrips.
  ///
  /// In en, this message translates to:
  /// **'Undo Auto-Generated Trips'**
  String get undoAutoGeneratedTrips;

  /// No description provided for @searchMultiDestination.
  ///
  /// In en, this message translates to:
  /// **'Search Multi-Destination'**
  String get searchMultiDestination;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @selectOutbound.
  ///
  /// In en, this message translates to:
  /// **'Select Outbound Trip'**
  String get selectOutbound;

  /// No description provided for @selectReturn.
  ///
  /// In en, this message translates to:
  /// **'Select Return Trip'**
  String get selectReturn;

  /// No description provided for @outboundSummary.
  ///
  /// In en, this message translates to:
  /// **'Outbound Summary'**
  String get outboundSummary;

  /// No description provided for @arrivesAt.
  ///
  /// In en, this message translates to:
  /// **'Arrives at: {time}'**
  String arrivesAt(String time);

  /// No description provided for @noOutbound.
  ///
  /// In en, this message translates to:
  /// **'No outbound trips available.'**
  String get noOutbound;

  /// No description provided for @noReturn.
  ///
  /// In en, this message translates to:
  /// **'No return trips found for your date.'**
  String get noReturn;

  /// No description provided for @step1Seats.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select Outbound Seats'**
  String get step1Seats;

  /// No description provided for @step2Seats.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Return Seats'**
  String get step2Seats;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @roundTripSummary.
  ///
  /// In en, this message translates to:
  /// **'Round Trip Summary'**
  String get roundTripSummary;

  /// No description provided for @outbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get outbound;

  /// No description provided for @returnTrip.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnTrip;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @proceedToPassenger.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Passenger Details'**
  String get proceedToPassenger;

  /// No description provided for @nSeats.
  ///
  /// In en, this message translates to:
  /// **'{n} Seats'**
  String nSeats(String n);

  /// No description provided for @actionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Action successful.'**
  String get actionSuccessful;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noUpcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trips'**
  String get noUpcomingTrips;

  /// No description provided for @noActiveTrips.
  ///
  /// In en, this message translates to:
  /// **'No trips departing soon'**
  String get noActiveTrips;

  /// No description provided for @noPastTrips.
  ///
  /// In en, this message translates to:
  /// **'No past trips'**
  String get noPastTrips;

  /// No description provided for @refreshTickets.
  ///
  /// In en, this message translates to:
  /// **'Tap the refresh button above'**
  String get refreshTickets;

  /// No description provided for @resellTickets.
  ///
  /// In en, this message translates to:
  /// **'Resell Tickets'**
  String get resellTickets;

  /// No description provided for @turnTicketsIntoCash.
  ///
  /// In en, this message translates to:
  /// **'Turn your unused tickets into cash'**
  String get turnTicketsIntoCash;

  /// No description provided for @listTicketForSale.
  ///
  /// In en, this message translates to:
  /// **'List Ticket for Sale'**
  String get listTicketForSale;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @listed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get listed;

  /// No description provided for @estValue.
  ///
  /// In en, this message translates to:
  /// **'Est. Value'**
  String get estValue;

  /// No description provided for @listedOnMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Listed on Marketplace'**
  String get listedOnMarketplace;

  /// No description provided for @priceGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0.'**
  String get priceGreaterThanZero;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @txDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get txDeposit;

  /// No description provided for @txTicketPurchase.
  ///
  /// In en, this message translates to:
  /// **'Ticket Purchase'**
  String get txTicketPurchase;

  /// No description provided for @txRedemption.
  ///
  /// In en, this message translates to:
  /// **'Redemption'**
  String get txRedemption;

  /// No description provided for @txReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get txReward;

  /// No description provided for @txChallengeReward.
  ///
  /// In en, this message translates to:
  /// **'Challenge Reward'**
  String get txChallengeReward;

  /// No description provided for @txBookingEarned.
  ///
  /// In en, this message translates to:
  /// **'Booking Reward'**
  String get txBookingEarned;

  /// No description provided for @txStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get txStatusAvailable;

  /// No description provided for @txStatusSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get txStatusSpent;

  /// No description provided for @txStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get txStatusExpired;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @whereToGoToday.
  ///
  /// In en, this message translates to:
  /// **'Where would you like to go today?'**
  String get whereToGoToday;

  /// No description provided for @searchTrip.
  ///
  /// In en, this message translates to:
  /// **'Search Trip'**
  String get searchTrip;

  /// No description provided for @multiDestination.
  ///
  /// In en, this message translates to:
  /// **'Multi-Destination'**
  String get multiDestination;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// No description provided for @roundTripToggle.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTripToggle;

  /// No description provided for @transportType.
  ///
  /// In en, this message translates to:
  /// **'Transport Type'**
  String get transportType;

  /// No description provided for @anyStation.
  ///
  /// In en, this message translates to:
  /// **'Any station'**
  String get anyStation;

  /// No description provided for @travelDate.
  ///
  /// In en, this message translates to:
  /// **'Travel date'**
  String get travelDate;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return date'**
  String get returnDate;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @walletActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get walletActive;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @chargeWallet.
  ///
  /// In en, this message translates to:
  /// **'Charge Wallet'**
  String get chargeWallet;

  /// No description provided for @walletChargedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wallet charged successfully!'**
  String get walletChargedSuccess;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @simulatedPayment.
  ///
  /// In en, this message translates to:
  /// **'Simulated payment • No real charge'**
  String get simulatedPayment;

  /// No description provided for @sellAllTickets.
  ///
  /// In en, this message translates to:
  /// **'Sell All Tickets'**
  String get sellAllTickets;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @loyaltyHub.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Hub'**
  String get loyaltyHub;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get signOutConfirm;

  /// No description provided for @signOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your account.'**
  String get signOutBody;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @walletChargedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Wallet charged successfully!'**
  String get walletChargedSuccessfully;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @amountEgp.
  ///
  /// In en, this message translates to:
  /// **'Amount (EGP)'**
  String get amountEgp;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @amountMustBeRange.
  ///
  /// In en, this message translates to:
  /// **'Amount must be 10–10,000 EGP'**
  String get amountMustBeRange;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @mustBe16Digits.
  ///
  /// In en, this message translates to:
  /// **'Must be 16 digits'**
  String get mustBe16Digits;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get expiry;

  /// No description provided for @formatMmYy.
  ///
  /// In en, this message translates to:
  /// **'Format: MM/YY'**
  String get formatMmYy;

  /// No description provided for @threeDigitsRequired.
  ///
  /// In en, this message translates to:
  /// **'3 digits required'**
  String get threeDigitsRequired;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// No description provided for @pts.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get pts;

  /// No description provided for @noExpiringPoints.
  ///
  /// In en, this message translates to:
  /// **'No expiring points right now'**
  String get noExpiringPoints;

  /// No description provided for @ptsExpired.
  ///
  /// In en, this message translates to:
  /// **'{n} pts have expired'**
  String ptsExpired(String n);

  /// No description provided for @ptsExpireTomorrow.
  ///
  /// In en, this message translates to:
  /// **'{n} pts expire tomorrow'**
  String ptsExpireTomorrow(String n);

  /// No description provided for @ptsExpireInDays.
  ///
  /// In en, this message translates to:
  /// **'{n} pts expire in {d} days'**
  String ptsExpireInDays(String n, String d);

  /// No description provided for @ptsExpireInMonthsDays.
  ///
  /// In en, this message translates to:
  /// **'{n} pts expire in {m} and {d}'**
  String ptsExpireInMonthsDays(String n, String m, String d);

  /// No description provided for @ptsExpireInMonths.
  ///
  /// In en, this message translates to:
  /// **'{n} pts expire in {m}'**
  String ptsExpireInMonths(String n, String m);

  /// No description provided for @oneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get oneMonth;

  /// No description provided for @monthsPlural.
  ///
  /// In en, this message translates to:
  /// **'{m} months'**
  String monthsPlural(String m);

  /// No description provided for @oneDay.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get oneDay;

  /// No description provided for @daysPlural.
  ///
  /// In en, this message translates to:
  /// **'{d} days'**
  String daysPlural(String d);

  /// No description provided for @pointsPending.
  ///
  /// In en, this message translates to:
  /// **'Points are pending until departure and expire 4 months after departure.'**
  String get pointsPending;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get manageAccount;

  /// No description provided for @planYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Journey'**
  String get planYourJourney;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure date'**
  String get departureDate;

  /// No description provided for @subCityOptional.
  ///
  /// In en, this message translates to:
  /// **'Sub-city (optional — any station)'**
  String get subCityOptional;

  /// No description provided for @govHint.
  ///
  /// In en, this message translates to:
  /// **'{title} (e.g. Cairo, Luxor)'**
  String govHint(String title);

  /// No description provided for @popularRoutes.
  ///
  /// In en, this message translates to:
  /// **'🔥 Popular Routes'**
  String get popularRoutes;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @gov_Cairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get gov_Cairo;

  /// No description provided for @gov_Alexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get gov_Alexandria;

  /// No description provided for @gov_Giza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get gov_Giza;

  /// No description provided for @gov_Aswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get gov_Aswan;

  /// No description provided for @gov_Luxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get gov_Luxor;

  /// No description provided for @gov_Minya.
  ///
  /// In en, this message translates to:
  /// **'Minya'**
  String get gov_Minya;

  /// No description provided for @gov_Beheira.
  ///
  /// In en, this message translates to:
  /// **'Beheira'**
  String get gov_Beheira;

  /// No description provided for @gov_Qena.
  ///
  /// In en, this message translates to:
  /// **'Qena'**
  String get gov_Qena;

  /// No description provided for @gov_Sohag.
  ///
  /// In en, this message translates to:
  /// **'Sohag'**
  String get gov_Sohag;

  /// No description provided for @gov_Asyut.
  ///
  /// In en, this message translates to:
  /// **'Asyut'**
  String get gov_Asyut;

  /// No description provided for @gov_Fayoum.
  ///
  /// In en, this message translates to:
  /// **'Fayoum'**
  String get gov_Fayoum;

  /// No description provided for @gov_BeniSuef.
  ///
  /// In en, this message translates to:
  /// **'Beni Suef'**
  String get gov_BeniSuef;

  /// No description provided for @gov_Sharqia.
  ///
  /// In en, this message translates to:
  /// **'Sharqia'**
  String get gov_Sharqia;

  /// No description provided for @gov_Dakahlia.
  ///
  /// In en, this message translates to:
  /// **'Dakahlia'**
  String get gov_Dakahlia;

  /// No description provided for @gov_Gharbiya.
  ///
  /// In en, this message translates to:
  /// **'Gharbiya'**
  String get gov_Gharbiya;

  /// No description provided for @gov_KafrElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Kafr El Sheikh'**
  String get gov_KafrElSheikh;

  /// No description provided for @gov_Monufia.
  ///
  /// In en, this message translates to:
  /// **'Monufia'**
  String get gov_Monufia;

  /// No description provided for @gov_Qalyubia.
  ///
  /// In en, this message translates to:
  /// **'Qalyubia'**
  String get gov_Qalyubia;

  /// No description provided for @gov_Ismailia.
  ///
  /// In en, this message translates to:
  /// **'Ismailia'**
  String get gov_Ismailia;

  /// No description provided for @gov_Suez.
  ///
  /// In en, this message translates to:
  /// **'Suez'**
  String get gov_Suez;

  /// No description provided for @gov_Damietta.
  ///
  /// In en, this message translates to:
  /// **'Damietta'**
  String get gov_Damietta;

  /// No description provided for @gov_Matrouh.
  ///
  /// In en, this message translates to:
  /// **'Matrouh'**
  String get gov_Matrouh;

  /// No description provided for @gov_PortSaid.
  ///
  /// In en, this message translates to:
  /// **'Port Said'**
  String get gov_PortSaid;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @pointsHistory.
  ///
  /// In en, this message translates to:
  /// **'Points History'**
  String get pointsHistory;

  /// No description provided for @noChallengesFound.
  ///
  /// In en, this message translates to:
  /// **'No challenges found.'**
  String get noChallengesFound;

  /// No description provided for @noPointHistory.
  ///
  /// In en, this message translates to:
  /// **'No point history.'**
  String get noPointHistory;

  /// No description provided for @activeChallenges.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeChallenges;

  /// No description provided for @completedChallenges.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedChallenges;

  /// No description provided for @uploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo...'**
  String get uploadingPhoto;

  /// No description provided for @photoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded'**
  String get photoUploaded;

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Photo upload failed: {msg}'**
  String photoUploadFailed(String msg);

  /// No description provided for @skipAndSave.
  ///
  /// In en, this message translates to:
  /// **'Skip & Save'**
  String get skipAndSave;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family Name'**
  String get familyName;

  /// No description provided for @familyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your family / tribal name'**
  String get familyNameHint;

  /// No description provided for @emailAddressValid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailAddressValid;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneNumberRequired;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @fixedDetails.
  ///
  /// In en, this message translates to:
  /// **'Fixed Details'**
  String get fixedDetails;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @countryCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Country cannot be changed.'**
  String get countryCannotBeChanged;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @pointsBalanceIs.
  ///
  /// In en, this message translates to:
  /// **'Points Balance: {n}'**
  String pointsBalanceIs(String n);

  /// No description provided for @expiringSoonCard.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon: {n} pts ({date})'**
  String expiringSoonCard(String n, String date);

  /// No description provided for @earnedPointsPending.
  ///
  /// In en, this message translates to:
  /// **'Earned points are pending until departure and expire 4 months after departure.'**
  String get earnedPointsPending;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @addTripsToCart.
  ///
  /// In en, this message translates to:
  /// **'Add trips to your cart to checkout later.'**
  String get addTripsToCart;

  /// No description provided for @checkoutWallet.
  ///
  /// In en, this message translates to:
  /// **'Checkout (Wallet)'**
  String get checkoutWallet;

  /// No description provided for @checkoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Checkout successful!\nYour wallet has been deducted.'**
  String get checkoutSuccess;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @nationalIdOptional.
  ///
  /// In en, this message translates to:
  /// **'National ID Number  (optional)'**
  String get nationalIdOptional;

  /// No description provided for @nationalIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 29901011234567'**
  String get nationalIdHint;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createPasswordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @directTrip.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directTrip;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Stops'**
  String stopsCount(String count);

  /// No description provided for @hideStops.
  ///
  /// In en, this message translates to:
  /// **'Hide Stops'**
  String get hideStops;

  /// No description provided for @showStops.
  ///
  /// In en, this message translates to:
  /// **'Show Stops'**
  String get showStops;

  /// No description provided for @routeStops.
  ///
  /// In en, this message translates to:
  /// **'Route Stops'**
  String get routeStops;

  /// No description provided for @howManyPassengers.
  ///
  /// In en, this message translates to:
  /// **'How many passengers?'**
  String get howManyPassengers;

  /// No description provided for @perSeat.
  ///
  /// In en, this message translates to:
  /// **'per seat'**
  String get perSeat;

  /// No description provided for @seatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{n} seats available'**
  String seatsAvailable(String n);

  /// No description provided for @continueWithNPassengers.
  ///
  /// In en, this message translates to:
  /// **'Continue with {n} Passenger(s)'**
  String continueWithNPassengers(String n);

  /// No description provided for @useLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'💎 Use Loyalty Points'**
  String get useLoyaltyPoints;

  /// No description provided for @noPointsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any points yet. Complete trips to earn points!'**
  String get noPointsYet;

  /// No description provided for @pointsCantBeApplied.
  ///
  /// In en, this message translates to:
  /// **'Points can\'t be applied — cart total is too low (10 EGP minimum final price).'**
  String get pointsCantBeApplied;

  /// No description provided for @needMorePoints.
  ///
  /// In en, this message translates to:
  /// **'You need at least 20 pts to redeem (= 1.00 EGP off). You currently have {points} pts. Keep booking to earn more!'**
  String needMorePoints(String points);

  /// No description provided for @ptsLabel.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get ptsLabel;

  /// No description provided for @pointsInfo.
  ///
  /// In en, this message translates to:
  /// **'ℹ️ 20 pts = 1.00 EGP'**
  String get pointsInfo;

  /// No description provided for @pointsUsed.
  ///
  /// In en, this message translates to:
  /// **'Points used'**
  String get pointsUsed;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @remainingAfter.
  ///
  /// In en, this message translates to:
  /// **'Remaining after'**
  String get remainingAfter;

  /// No description provided for @finalTotal.
  ///
  /// In en, this message translates to:
  /// **'Final total'**
  String get finalTotal;

  /// No description provided for @ptsValue.
  ///
  /// In en, this message translates to:
  /// **'{n} pts'**
  String ptsValue(String n);

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @fullSeats.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get fullSeats;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @ticketDetails.
  ///
  /// In en, this message translates to:
  /// **'Ticket Details'**
  String get ticketDetails;

  /// No description provided for @ticketClass.
  ///
  /// In en, this message translates to:
  /// **'{className} Class'**
  String ticketClass(String className);

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @bookingRef.
  ///
  /// In en, this message translates to:
  /// **'Booking Ref'**
  String get bookingRef;

  /// No description provided for @passengersAndSeats.
  ///
  /// In en, this message translates to:
  /// **'Passengers & Seats'**
  String get passengersAndSeats;

  /// No description provided for @tapPassengerInfo.
  ///
  /// In en, this message translates to:
  /// **'Tap on a passenger to view their boarding pass'**
  String get tapPassengerInfo;

  /// No description provided for @idNum.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String idNum(String id);

  /// No description provided for @seatNum.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String seatNum(String seat);

  /// No description provided for @seat.
  ///
  /// In en, this message translates to:
  /// **'seat(s)'**
  String get seat;

  /// No description provided for @pax.
  ///
  /// In en, this message translates to:
  /// **'pax'**
  String get pax;

  /// No description provided for @passengerDetails.
  ///
  /// In en, this message translates to:
  /// **'Passenger Details'**
  String get passengerDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailOptional;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @passengerN.
  ///
  /// In en, this message translates to:
  /// **'Passenger {n}'**
  String passengerN(String n);

  /// No description provided for @seatLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat: {n}'**
  String seatLabel(String n);

  /// No description provided for @passengersCount.
  ///
  /// In en, this message translates to:
  /// **'{n} Passenger(s)'**
  String passengersCount(String n);

  /// No description provided for @selectSeats.
  ///
  /// In en, this message translates to:
  /// **'Select Seats'**
  String get selectSeats;

  /// No description provided for @selectedSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected: '**
  String get selectedSeatsLabel;

  /// No description provided for @seatsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} seats'**
  String seatsCount(String n);

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @noSeatsSelected.
  ///
  /// In en, this message translates to:
  /// **'No seats selected'**
  String get noSeatsSelected;

  /// No description provided for @travellingWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Travelling with family?'**
  String get travellingWithFamily;

  /// No description provided for @autoFill.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill'**
  String get autoFill;

  /// No description provided for @autoFilled.
  ///
  /// In en, this message translates to:
  /// **'Auto-filled ✔'**
  String get autoFilled;

  /// No description provided for @reFill.
  ///
  /// In en, this message translates to:
  /// **'Re-fill'**
  String get reFill;

  /// No description provided for @fillSeat1Info.
  ///
  /// In en, this message translates to:
  /// **'Fill seat 1, then copy name & phone to all other seats.'**
  String get fillSeat1Info;

  /// No description provided for @addEntireJourneyToCart.
  ///
  /// In en, this message translates to:
  /// **'Add Entire Journey to Cart'**
  String get addEntireJourneyToCart;

  /// No description provided for @buildJourney.
  ///
  /// In en, this message translates to:
  /// **'Build Journey'**
  String get buildJourney;

  /// No description provided for @suggestedTransferRoute.
  ///
  /// In en, this message translates to:
  /// **'Suggested Transfer Route'**
  String get suggestedTransferRoute;

  /// No description provided for @transferAt.
  ///
  /// In en, this message translates to:
  /// **'Transfer at'**
  String get transferAt;

  /// No description provided for @legN.
  ///
  /// In en, this message translates to:
  /// **'Leg {n}'**
  String legN(String n);

  /// No description provided for @journeyAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Journey added to cart successfully!'**
  String get journeyAddedToCart;

  /// No description provided for @bookingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Booking successful!'**
  String get bookingSuccessful;

  /// No description provided for @indirectTripAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Indirect Trip successfully added to Cart!'**
  String get indirectTripAddedToCart;

  /// No description provided for @pleaseSelectSeat.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat'**
  String get pleaseSelectSeat;

  /// No description provided for @selectExactlyNSeats.
  ///
  /// In en, this message translates to:
  /// **'Please pick exactly {n} seats'**
  String selectExactlyNSeats(String n);

  /// No description provided for @canOnlySelectNSeats.
  ///
  /// In en, this message translates to:
  /// **'You can only select {n} seats for this leg.'**
  String canOnlySelectNSeats(String n);

  /// No description provided for @pleaseSelectNPassengers.
  ///
  /// In en, this message translates to:
  /// **'Please select exactly {n} passengers'**
  String pleaseSelectNPassengers(String n);

  /// No description provided for @fillNamePhoneFirst.
  ///
  /// In en, this message translates to:
  /// **'Please fill in Name and Phone for the first passenger first.'**
  String get fillNamePhoneFirst;

  /// No description provided for @filledNSeats.
  ///
  /// In en, this message translates to:
  /// **'Filled {n} seat(s) with \"{name}\"'**
  String filledNSeats(String n, String name);

  /// No description provided for @requiredCountSeats.
  ///
  /// In en, this message translates to:
  /// **'Required: {n} seats. Selected: {m}'**
  String requiredCountSeats(String n, String m);

  /// No description provided for @idTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'ID Type'**
  String get idTypeLabel;

  /// No description provided for @idTypeNationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get idTypeNationalId;

  /// No description provided for @idTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get idTypePassport;

  /// No description provided for @idNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID Number'**
  String get idNumberLabel;

  /// No description provided for @passportNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumberLabel;

  /// No description provided for @activeChallengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Challenges'**
  String get activeChallengesTitle;

  /// No description provided for @challengeProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} trips'**
  String challengeProgressLabel(String current, String goal);

  /// No description provided for @challengeRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward: {points} points'**
  String challengeRewardLabel(String points);

  /// No description provided for @challengeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get challengeMonthly;

  /// No description provided for @challengeOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-Time'**
  String get challengeOneTime;

  /// No description provided for @challengePts.
  ///
  /// In en, this message translates to:
  /// **'+{pts} pts'**
  String challengePts(String pts);

  /// No description provided for @challengeProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal}'**
  String challengeProgress(String current, String goal);

  /// No description provided for @amLabel.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get amLabel;

  /// No description provided for @pmLabel.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pmLabel;

  /// No description provided for @floorLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor {n}'**
  String floorLabel(String n);

  /// No description provided for @standardClass.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardClass;

  /// No description provided for @dateCannotBeToday.
  ///
  /// In en, this message translates to:
  /// **'Travel date cannot be today. Please select a future date.'**
  String get dateCannotBeToday;

  /// No description provided for @selectTravelDate.
  ///
  /// In en, this message translates to:
  /// **'Select Travel Date'**
  String get selectTravelDate;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get filterUnread;

  /// No description provided for @filterMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get filterMarketplace;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @seatLegendAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get seatLegendAvailable;

  /// No description provided for @seatLegendSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get seatLegendSelected;

  /// No description provided for @seatLegendTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get seatLegendTaken;

  /// No description provided for @idTypeNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get idTypeNone;

  /// No description provided for @passportNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. A12345678'**
  String get passportNumberHint;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create\nAccount.'**
  String get signupTitle;

  /// No description provided for @joinFutureOfTravel.
  ///
  /// In en, this message translates to:
  /// **'Join the future of travel'**
  String get joinFutureOfTravel;

  /// No description provided for @ticketMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Ticket Marketplace'**
  String get ticketMarketplace;

  /// No description provided for @findDealsFromTravelers.
  ///
  /// In en, this message translates to:
  /// **'Find great deals from other travelers'**
  String get findDealsFromTravelers;

  /// No description provided for @filtersActive.
  ///
  /// In en, this message translates to:
  /// **'Filters (active)'**
  String get filtersActive;

  /// No description provided for @avgDiscount.
  ///
  /// In en, this message translates to:
  /// **'Avg. Discount'**
  String get avgDiscount;

  /// No description provided for @totalListings.
  ///
  /// In en, this message translates to:
  /// **'Total Listings'**
  String get totalListings;

  /// No description provided for @noListingsFound.
  ///
  /// In en, this message translates to:
  /// **'No listings found.'**
  String get noListingsFound;

  /// No description provided for @tryRemovingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try removing some filters.'**
  String get tryRemovingFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @buyTicket.
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get buyTicket;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @agencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get agencyLabel;

  /// No description provided for @originLabel.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get originLabel;

  /// No description provided for @destinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @areYouSureBuyTicket.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to buy this ticket?'**
  String get areYouSureBuyTicket;

  /// No description provided for @ticketPurchasedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ticket purchased successfully!'**
  String get ticketPurchasedSuccessfully;

  /// No description provided for @listingCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Listing cancelled successfully!'**
  String get listingCancelledSuccessfully;

  /// No description provided for @filterFrom.
  ///
  /// In en, this message translates to:
  /// **'From: {gov}'**
  String filterFrom(String gov);

  /// No description provided for @filterTo.
  ///
  /// In en, this message translates to:
  /// **'To: {gov}'**
  String filterTo(String gov);

  /// No description provided for @filterDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String filterDate(String date);

  /// No description provided for @filterListings.
  ///
  /// In en, this message translates to:
  /// **'Filter Listings'**
  String get filterListings;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @originGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Origin Governorate'**
  String get originGovernorate;

  /// No description provided for @destinationGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Destination Governorate'**
  String get destinationGovernorate;

  /// No description provided for @travelDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Travel Date'**
  String get travelDateFilter;

  /// No description provided for @anyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get anyDate;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @hintCairo.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cairo'**
  String get hintCairo;

  /// No description provided for @hintAlexandria.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alexandria'**
  String get hintAlexandria;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox!'**
  String get emailSentTitle;

  /// No description provided for @emailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'If your email is registered, you will receive a password reset link shortly. Check your spam folder if you don\'t see it.'**
  String get emailSentMessage;

  /// No description provided for @emailSendError.
  ///
  /// In en, this message translates to:
  /// **'Could not send email'**
  String get emailSendError;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssueTitle;

  /// No description provided for @reportIssueHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get reportIssueHeaderTitle;

  /// No description provided for @reportIssueHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue and our team will get back to you.'**
  String get reportIssueHeaderSubtitle;

  /// No description provided for @issueCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue Category'**
  String get issueCategoryLabel;

  /// No description provided for @issueCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get issueCategoryPayment;

  /// No description provided for @issueCategoryTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip Experience'**
  String get issueCategoryTrip;

  /// No description provided for @issueCategoryAppBug.
  ///
  /// In en, this message translates to:
  /// **'App Bug'**
  String get issueCategoryAppBug;

  /// No description provided for @issueCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'Account Issue'**
  String get issueCategoryAccount;

  /// No description provided for @issueCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issueCategoryOther;

  /// No description provided for @issueTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get issueTitleLabel;

  /// No description provided for @issueTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your issue'**
  String get issueTitleHint;

  /// No description provided for @issueTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get issueTitleRequired;

  /// No description provided for @issueDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get issueDescriptionLabel;

  /// No description provided for @issueDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue in detail...'**
  String get issueDescriptionHint;

  /// No description provided for @issueDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get issueDescriptionRequired;

  /// No description provided for @issueDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide at least 10 characters'**
  String get issueDescriptionTooShort;

  /// No description provided for @issueSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get issueSubmitBtn;

  /// No description provided for @issueSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted!'**
  String get issueSubmittedTitle;

  /// No description provided for @issueSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for reaching out. Our support team will review your issue and respond as soon as possible.'**
  String get issueSubmittedBody;

  /// No description provided for @issueDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get issueDone;

  /// No description provided for @requestRefund.
  ///
  /// In en, this message translates to:
  /// **'Request Refund'**
  String get requestRefund;

  /// No description provided for @refundAlreadyRequested.
  ///
  /// In en, this message translates to:
  /// **'Refund Requested'**
  String get refundAlreadyRequested;

  /// No description provided for @refundConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Refund?'**
  String get refundConfirmTitle;

  /// No description provided for @refundConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to request a refund for this booking? Your wallet will be credited once the request is approved.'**
  String get refundConfirmBody;

  /// No description provided for @refundSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Refund request submitted successfully.'**
  String get refundSubmitted;

  /// No description provided for @refundRequesting.
  ///
  /// In en, this message translates to:
  /// **'Submitting refund request...'**
  String get refundRequesting;

  /// No description provided for @refundAccepted.
  ///
  /// In en, this message translates to:
  /// **'Refund Accepted'**
  String get refundAccepted;

  /// No description provided for @refundRejected.
  ///
  /// In en, this message translates to:
  /// **'Refund Rejected'**
  String get refundRejected;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @cancelTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this trip?'**
  String get cancelTripTitle;

  /// No description provided for @cancelTripMsg.
  ///
  /// In en, this message translates to:
  /// **'Your seat hold will be released and inventory restored. This cannot be undone.'**
  String get cancelTripMsg;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep It'**
  String get keepIt;

  /// No description provided for @cancelTripBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Trip'**
  String get cancelTripBtn;

  /// No description provided for @insufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds.'**
  String get insufficientFunds;

  /// No description provided for @insufficientFundsDetail.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds. Your wallet balance is {balance} EGP, but checkout total is {total} EGP.'**
  String insufficientFundsDetail(String balance, String total);

  /// No description provided for @checkoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Checkout failed'**
  String get checkoutFailed;

  /// No description provided for @ticketAddedButCheckoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Ticket added to cart, but checkout failed: {error}'**
  String ticketAddedButCheckoutFailed(String error);

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original price: {price} {currency}'**
  String originalPrice(String price, String currency);

  /// No description provided for @seatsTakenError.
  ///
  /// In en, this message translates to:
  /// **'One or more selected seats were just taken. Please refresh the seat map.'**
  String get seatsTakenError;

  /// No description provided for @chooseCompany.
  ///
  /// In en, this message translates to:
  /// **'Choose Company'**
  String get chooseCompany;

  /// No description provided for @allCompanies.
  ///
  /// In en, this message translates to:
  /// **'All companies'**
  String get allCompanies;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get arrivalTime;

  /// No description provided for @identityDetails.
  ///
  /// In en, this message translates to:
  /// **'Identity Details'**
  String get identityDetails;

  /// No description provided for @identityDetailsWarning.
  ///
  /// In en, this message translates to:
  /// **'Once set, identity details cannot be changed. Please make sure the entered details are correct.'**
  String get identityDetailsWarning;

  /// No description provided for @nationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'National ID is required.'**
  String get nationalIdRequired;

  /// No description provided for @passportNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Passport number is required.'**
  String get passportNumberRequired;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
