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
  /// **'Asking price (max {n} EGP)'**
  String askingPrice(String n);

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

  /// No description provided for @gov_PortSaid.
  ///
  /// In en, this message translates to:
  /// **'Port Said'**
  String get gov_PortSaid;

  /// No description provided for @gov_Damietta.
  ///
  /// In en, this message translates to:
  /// **'Damietta'**
  String get gov_Damietta;
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
