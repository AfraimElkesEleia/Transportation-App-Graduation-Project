// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navTickets => 'My Tickets';

  @override
  String get navMarket => 'Market';

  @override
  String get navProfile => 'Profile';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get any => 'Any';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noData => 'No data available';

  @override
  String get no => 'No';

  @override
  String get onboardingSubtitle1 => 'TRAVEL SMART';

  @override
  String get onboardingTitle1 => 'Discover Egypt';

  @override
  String get onboardingDesc1 => 'Explore every corner of Egypt...';

  @override
  String get onboardingSubtitle2 => 'STAY INFORMED';

  @override
  String get onboardingTitle2 => 'Real-Time Updates';

  @override
  String get onboardingDesc2 => 'Get instant notifications...';

  @override
  String get onboardingSubtitle3 => 'TRAVEL CONFIDENT';

  @override
  String get onboardingTitle3 => 'Secure & Reliable';

  @override
  String get onboardingDesc3 => 'Book with confidence...';

  @override
  String get loginTitle => 'Welcome \nBack.';

  @override
  String get loginSubtitle => 'Enter the future of travel';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get sectionPersonal => 'Personal Information';

  @override
  String get sectionContact => 'Contact Details';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get genderError => 'Please select your gender.';

  @override
  String get countryError => 'Please select your country.';

  @override
  String get signOutTitle => 'Sign Out?';

  @override
  String get signOutMsg => 'You will need to sign in again...';

  @override
  String get cancelBtn => 'Cancel';

  @override
  String get signOutBtn => 'Sign Out';

  @override
  String get language => 'Language';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get myTickets => 'My Tickets';

  @override
  String get digitalWallet => 'Your digital travel wallet';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabActive => 'Active';

  @override
  String get tabPast => 'Past';

  @override
  String get noUpcoming => 'No upcoming trips';

  @override
  String get noActive => 'No trips departing soon';

  @override
  String get noPast => 'No past trips';

  @override
  String get actionSuccess => 'Action successful.';

  @override
  String get tapRefresh => 'Tap the refresh button above';

  @override
  String get useRefresh => 'Use the refresh button above';

  @override
  String get resellTitle => 'Resell Tickets';

  @override
  String get resellSubtitle => 'Turn your unused tickets into cash';

  @override
  String get yourUpcomingTickets => 'Your Upcoming Tickets';

  @override
  String get statAvailable => 'Available';

  @override
  String get statListed => 'Listed';

  @override
  String get statEstValue => 'Est. Value';

  @override
  String get listedOnMarket => 'Listed on Marketplace';

  @override
  String get availableForSale => 'Available for Sale';

  @override
  String daysLeft(String n) {
    return '$n day(s) left';
  }

  @override
  String get totalPrice => 'Total price:';

  @override
  String get sell => 'Sell';

  @override
  String get listForSale => 'List Ticket for Sale';

  @override
  String askingPrice(String n) {
    return 'Asking price (max $n EGP)';
  }

  @override
  String get listTicketBtn => 'List Ticket';

  @override
  String get cancelListing => 'Cancel Listing';

  @override
  String get cancelListingMsg => 'This booking is currently listed...';

  @override
  String get cancelListingPrompt =>
      'This booking is currently listed on the marketplace. Do you want to remove it from sale?';

  @override
  String get noResellable => 'No upcoming tickets available for resale.';

  @override
  String get resellRules => 'Only confirmed, upcoming tickets...';

  @override
  String get listingUpdated => 'Listing updated successfully!';

  @override
  String get priceMustBePos => 'Price must be greater than 0.';

  @override
  String maxPrice(String n) {
    return 'Max price is $n EGP.';
  }

  @override
  String get all => 'All';

  @override
  String get bus => 'Bus';

  @override
  String get train => 'Train';

  @override
  String get sortBy => 'Sort By';

  @override
  String get lowestPrice => 'Lowest Price';

  @override
  String get shortestDuration => 'Shortest Duration';

  @override
  String get departureTime => 'Departure Time';

  @override
  String get maxPriceText => 'Max Price';

  @override
  String get filters => 'Filters';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get searchIndirectTrips => 'Search Indirect Trips';

  @override
  String get noTripsFound => 'No trips found';

  @override
  String get searchingConnectingRoutes => 'Searching for connecting routes...';

  @override
  String get noConnectingRoutes => 'No connecting routes found.';

  @override
  String get connectingRoutes => 'Connecting Routes';

  @override
  String get noDirectTripsFound => 'No direct trips found';

  @override
  String get trySearchingIndirect =>
      'Try searching for connecting routes with 1 stop';

  @override
  String get fillFromToBeforeReverse =>
      'Please fill From and To before reversing.';

  @override
  String get fillFromToBeforeReturn =>
      'Please fill From and To before returning.';

  @override
  String get selectDepartureGov => 'Please select departure governorate';

  @override
  String get selectDestinationGov => 'Please select destination governorate';

  @override
  String get destMustDiffer => 'Destination must differ from departure';

  @override
  String get destGovMustDiffer =>
      'Destination governorate must differ from departure';

  @override
  String get selectDepartureDate => 'Please select departure date';

  @override
  String get selectReturnDate => 'Please select a return date';

  @override
  String get returnDateBeforeDep => 'Return date cannot be before departure';

  @override
  String get dateCannotBeEarlier => 'Date cannot be earlier than previous leg';

  @override
  String get useStandardSearchSingleTrip =>
      'Please use the Standard Search for a single trip.';

  @override
  String get loadingStations => 'Loading stations...';

  @override
  String get trip => 'Trip';

  @override
  String get fromGov => 'From Governorate';

  @override
  String get toGov => 'To Governorate';

  @override
  String get multiDestNote =>
      'Note: Choose one of these options only after completing your full trip plan.';

  @override
  String get stepByStepReverse => 'Step-by-Step Reverse';

  @override
  String get directReturn => 'Direct Return';

  @override
  String get fillFromToBeforeAdding =>
      'Please fill From and To before adding a new trip.';

  @override
  String get addAnotherDestination => 'Add another destination';

  @override
  String get undoAutoGeneratedTrips => 'Undo Auto-Generated Trips';

  @override
  String get searchMultiDestination => 'Search Multi-Destination';

  @override
  String get roundTrip => 'Round Trip';

  @override
  String get selectOutbound => 'Select Outbound Trip';

  @override
  String get selectReturn => 'Select Return Trip';

  @override
  String get outboundSummary => 'Outbound Summary';

  @override
  String arrivesAt(String time) {
    return 'Arrives at: $time';
  }

  @override
  String get noOutbound => 'No outbound trips available.';

  @override
  String get noReturn => 'No return trips found for your date.';

  @override
  String get step1Seats => 'Step 1: Select Outbound Seats';

  @override
  String get step2Seats => 'Step 2: Select Return Seats';

  @override
  String get previous => 'Previous';

  @override
  String get roundTripSummary => 'Round Trip Summary';

  @override
  String get outbound => 'Outbound';

  @override
  String get returnTrip => 'Return';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get proceedToPassenger => 'Proceed to Passenger Details';

  @override
  String nSeats(String n) {
    return '$n Seats';
  }

  @override
  String get actionSuccessful => 'Action successful.';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get active => 'Active';

  @override
  String get past => 'Past';

  @override
  String get noUpcomingTrips => 'No upcoming trips';

  @override
  String get noActiveTrips => 'No trips departing soon';

  @override
  String get noPastTrips => 'No past trips';

  @override
  String get refreshTickets => 'Tap the refresh button above';

  @override
  String get resellTickets => 'Resell Tickets';

  @override
  String get turnTicketsIntoCash => 'Turn your unused tickets into cash';

  @override
  String get listTicketForSale => 'List Ticket for Sale';

  @override
  String get available => 'Available';

  @override
  String get listed => 'Listed';

  @override
  String get estValue => 'Est. Value';

  @override
  String get listedOnMarketplace => 'Listed on Marketplace';

  @override
  String get priceGreaterThanZero => 'Price must be greater than 0.';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get txDeposit => 'Deposit';

  @override
  String get txTicketPurchase => 'Ticket Purchase';

  @override
  String get txRedemption => 'Redemption';

  @override
  String get txReward => 'Reward';

  @override
  String get welcome => 'Welcome!';

  @override
  String get whereToGoToday => 'Where would you like to go today?';

  @override
  String get searchTrip => 'Search Trip';

  @override
  String get multiDestination => 'Multi-Destination';

  @override
  String get oneWay => 'One Way';

  @override
  String get roundTripToggle => 'Round Trip';

  @override
  String get transportType => 'Transport Type';

  @override
  String get anyStation => 'Any station';

  @override
  String get travelDate => 'Travel date';

  @override
  String get returnDate => 'Return date';

  @override
  String get myWallet => 'My Wallet';

  @override
  String get walletActive => 'Active';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get charge => 'Charge';

  @override
  String get history => 'History';

  @override
  String get chargeWallet => 'Charge Wallet';

  @override
  String get walletChargedSuccess => 'Wallet charged successfully!';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get simulatedPayment => 'Simulated payment • No real charge';

  @override
  String get sellAllTickets => 'Sell All Tickets';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get loyaltyHub => 'Loyalty Hub';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm => 'Sign Out?';

  @override
  String get signOutBody =>
      'You will need to sign in again to access your account.';

  @override
  String get egp => 'EGP';

  @override
  String get walletChargedSuccessfully => 'Wallet charged successfully!';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get amountEgp => 'Amount (EGP)';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get amountMustBeRange => 'Amount must be 10–10,000 EGP';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get mustBe16Digits => 'Must be 16 digits';

  @override
  String get expiry => 'Expiry';

  @override
  String get formatMmYy => 'Format: MM/YY';

  @override
  String get threeDigitsRequired => '3 digits required';

  @override
  String get loyaltyPoints => 'Loyalty Points';

  @override
  String get pts => 'pts';

  @override
  String get noExpiringPoints => 'No expiring points right now';

  @override
  String ptsExpired(String n) {
    return '$n pts have expired';
  }

  @override
  String ptsExpireTomorrow(String n) {
    return '$n pts expire tomorrow';
  }

  @override
  String ptsExpireInDays(String n, String d) {
    return '$n pts expire in $d days';
  }

  @override
  String ptsExpireInMonthsDays(String n, String m, String d) {
    return '$n pts expire in $m and $d';
  }

  @override
  String ptsExpireInMonths(String n, String m) {
    return '$n pts expire in $m';
  }

  @override
  String get oneMonth => '1 month';

  @override
  String monthsPlural(String m) {
    return '$m months';
  }

  @override
  String get oneDay => '1 day';

  @override
  String daysPlural(String d) {
    return '$d days';
  }

  @override
  String get pointsPending =>
      'Points are pending until departure and expire 4 months after departure.';

  @override
  String get profile => 'Profile';

  @override
  String get manageAccount => 'Manage your account';

  @override
  String get planYourJourney => 'Plan Your Journey';

  @override
  String get departureDate => 'Departure date';

  @override
  String get subCityOptional => 'Sub-city (optional — any station)';

  @override
  String govHint(String title) {
    return '$title (e.g. Cairo, Luxor)';
  }

  @override
  String get popularRoutes => 'Popular Routes';

  @override
  String get latestNews => 'Latest News';

  @override
  String get gov_Cairo => 'Cairo';

  @override
  String get gov_Alexandria => 'Alexandria';

  @override
  String get gov_Giza => 'Giza';

  @override
  String get gov_Aswan => 'Aswan';

  @override
  String get gov_Luxor => 'Luxor';

  @override
  String get gov_Minya => 'Minya';

  @override
  String get gov_Beheira => 'Beheira';

  @override
  String get gov_Qena => 'Qena';

  @override
  String get gov_Sohag => 'Sohag';

  @override
  String get gov_Asyut => 'Asyut';

  @override
  String get gov_Fayoum => 'Fayoum';

  @override
  String get gov_BeniSuef => 'Beni Suef';

  @override
  String get gov_Sharqia => 'Sharqia';

  @override
  String get gov_Dakahlia => 'Dakahlia';

  @override
  String get gov_Gharbiya => 'Gharbiya';

  @override
  String get gov_KafrElSheikh => 'Kafr El Sheikh';

  @override
  String get gov_Monufia => 'Monufia';

  @override
  String get gov_Qalyubia => 'Qalyubia';

  @override
  String get gov_Ismailia => 'Ismailia';

  @override
  String get gov_Suez => 'Suez';

  @override
  String get gov_PortSaid => 'Port Said';

  @override
  String get gov_Damietta => 'Damietta';
}
