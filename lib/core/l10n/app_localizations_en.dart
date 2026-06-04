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
  String get noRecentSearches => 'No recent searches';

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
  String get askingPrice => 'Asking price';

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
  String get txChallengeReward => 'Challenge Reward';

  @override
  String get txBookingEarned => 'Booking Reward';

  @override
  String get txStatusAvailable => 'Available';

  @override
  String get txStatusSpent => 'Spent';

  @override
  String get txStatusExpired => 'Expired';

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
  String get popularRoutes => '🔥 Popular Routes';

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
  String get gov_Damietta => 'Damietta';

  @override
  String get gov_Matrouh => 'Matrouh';

  @override
  String get gov_PortSaid => 'Port Said';

  @override
  String get challenges => 'Challenges';

  @override
  String get pointsHistory => 'Points History';

  @override
  String get noChallengesFound => 'No challenges found.';

  @override
  String get noPointHistory => 'No point history.';

  @override
  String get activeChallenges => 'Active';

  @override
  String get completedChallenges => 'Completed';

  @override
  String get uploadingPhoto => 'Uploading photo...';

  @override
  String get photoUploaded => 'Photo uploaded';

  @override
  String photoUploadFailed(String msg) {
    return 'Photo upload failed: $msg';
  }

  @override
  String get skipAndSave => 'Skip & Save';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'Enter your first name';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Enter your last name';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get familyName => 'Family Name';

  @override
  String get familyNameHint => 'Enter your family / tribal name';

  @override
  String get emailAddressValid => 'Enter a valid email';

  @override
  String get phoneNumberRequired => 'Phone is required';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get fixedDetails => 'Fixed Details';

  @override
  String get countryLabel => 'Country';

  @override
  String get countryCannotBeChanged => 'Country cannot be changed.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saving => 'Saving...';

  @override
  String pointsBalanceIs(String n) {
    return 'Points Balance: $n';
  }

  @override
  String expiringSoonCard(String n, String date) {
    return 'Expiring Soon: $n pts ($date)';
  }

  @override
  String get earnedPointsPending =>
      'Earned points are pending until departure and expire 4 months after departure.';

  @override
  String get myCart => 'My Cart';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get addTripsToCart => 'Add trips to your cart to checkout later.';

  @override
  String get checkoutWallet => 'Checkout (Wallet)';

  @override
  String get checkoutSuccess =>
      'Checkout successful!\nYour wallet has been deducted.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get nationalIdOptional => 'National ID Number  (optional)';

  @override
  String get nationalIdHint => 'e.g. 29901011234567';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get createPasswordHint => 'Create a strong password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get directTrip => 'Direct';

  @override
  String stopsCount(String count) {
    return '$count Stops';
  }

  @override
  String get hideStops => 'Hide Stops';

  @override
  String get showStops => 'Show Stops';

  @override
  String get routeStops => 'Route Stops';

  @override
  String get howManyPassengers => 'How many passengers?';

  @override
  String get perSeat => 'per seat';

  @override
  String seatsAvailable(String n) {
    return '$n seats available';
  }

  @override
  String continueWithNPassengers(String n) {
    return 'Continue with $n Passenger(s)';
  }

  @override
  String get useLoyaltyPoints => '💎 Use Loyalty Points';

  @override
  String get noPointsYet =>
      'You don\'t have any points yet. Complete trips to earn points!';

  @override
  String get pointsCantBeApplied =>
      'Points can\'t be applied — cart total is too low (10 EGP minimum final price).';

  @override
  String needMorePoints(String points) {
    return 'You need at least 20 pts to redeem (= 1.00 EGP off). You currently have $points pts. Keep booking to earn more!';
  }

  @override
  String get ptsLabel => 'pts';

  @override
  String get pointsInfo => 'ℹ️ 20 pts = 1.00 EGP';

  @override
  String get pointsUsed => 'Points used';

  @override
  String get discount => 'Discount';

  @override
  String get remainingAfter => 'Remaining after';

  @override
  String get finalTotal => 'Final total';

  @override
  String ptsValue(String n) {
    return '$n pts';
  }

  @override
  String get from => 'From';

  @override
  String get book => 'Book';

  @override
  String get fullSeats => 'Full';

  @override
  String get skip => 'Skip';

  @override
  String get ticketDetails => 'Ticket Details';

  @override
  String ticketClass(String className) {
    return '$className Class';
  }

  @override
  String get to => 'To';

  @override
  String get departure => 'Departure';

  @override
  String get arrival => 'Arrival';

  @override
  String get bookingRef => 'Booking Ref';

  @override
  String get passengersAndSeats => 'Passengers & Seats';

  @override
  String get tapPassengerInfo =>
      'Tap on a passenger to view their boarding pass';

  @override
  String idNum(String id) {
    return 'ID: $id';
  }

  @override
  String seatNum(String seat) {
    return 'Seat $seat';
  }

  @override
  String get seat => 'seat(s)';

  @override
  String get pax => 'pax';

  @override
  String get passengerDetails => 'Passenger Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get nationalId => 'National ID';

  @override
  String get emailOptional => 'Email Address (Optional)';

  @override
  String get requiredField => 'Required';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get bookNow => 'Book Now';

  @override
  String passengerN(String n) {
    return 'Passenger $n';
  }

  @override
  String seatLabel(String n) {
    return 'Seat: $n';
  }

  @override
  String passengersCount(String n) {
    return '$n Passenger(s)';
  }

  @override
  String get selectSeats => 'Select Seats';

  @override
  String get selectedSeatsLabel => 'Selected: ';

  @override
  String seatsCount(String n) {
    return '$n seats';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get continueBtn => 'Continue';

  @override
  String get noSeatsSelected => 'No seats selected';

  @override
  String get travellingWithFamily => 'Travelling with family?';

  @override
  String get autoFill => 'Auto-fill';

  @override
  String get autoFilled => 'Auto-filled ✔';

  @override
  String get reFill => 'Re-fill';

  @override
  String get fillSeat1Info =>
      'Fill seat 1, then copy name & phone to all other seats.';

  @override
  String get addEntireJourneyToCart => 'Add Entire Journey to Cart';

  @override
  String get bookEntireJourneyNow => 'Book Entire Journey Now';

  @override
  String get buildJourney => 'Build Journey';

  @override
  String selectTripForLeg(String n) {
    return 'Select Trip for Leg $n';
  }

  @override
  String selectSeatsForLeg(String n) {
    return 'Select Seats for Leg $n';
  }

  @override
  String get reviewCheckout => 'Review & Checkout';

  @override
  String get noTripsFoundForLeg => 'No trips found for this leg.';

  @override
  String get tryAdjustingFilters => 'Try adjusting the filters above.';

  @override
  String get suggestedTransferRoute => 'Suggested Transfer Route';

  @override
  String get transferAt => 'Transfer at';

  @override
  String get journeySummary => 'Journey Summary';

  @override
  String get journeyOverview => 'Journey Overview';

  @override
  String get connectionLayover => 'Connection layover';

  @override
  String get totalJourneyDuration => 'Total journey duration';

  @override
  String get routeLabel => 'Route';

  @override
  String get durationLabel => 'Duration';

  @override
  String get pricePerSeat => 'Price per seat';

  @override
  String get legTotal => 'Leg total';

  @override
  String get selectedSeats => 'Selected seats';

  @override
  String get noArrivalTime => 'Arrival time unavailable';

  @override
  String durationHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String legsCount(String n) {
    return '$n legs';
  }

  @override
  String legN(String n) {
    return 'Leg $n';
  }

  @override
  String get journeyAddedToCart => 'Journey added to cart successfully!';

  @override
  String get bookingSuccessful => 'Booking successful!';

  @override
  String get indirectTripAddedToCart =>
      'Indirect Trip successfully added to Cart!';

  @override
  String get pleaseSelectSeat => 'Please select a seat';

  @override
  String selectExactlyNSeats(String n) {
    return 'Please pick exactly $n seats';
  }

  @override
  String canOnlySelectNSeats(String n) {
    return 'You can only select $n seats for this leg.';
  }

  @override
  String pleaseSelectNPassengers(String n) {
    return 'Please select exactly $n passengers';
  }

  @override
  String get fillNamePhoneFirst =>
      'Please fill in Name and Phone for the first passenger first.';

  @override
  String filledNSeats(String n, String name) {
    return 'Filled $n seat(s) with \"$name\"';
  }

  @override
  String requiredCountSeats(String n, String m) {
    return 'Required: $n seats. Selected: $m';
  }

  @override
  String get idTypeLabel => 'ID Type';

  @override
  String get idTypeNationalId => 'National ID';

  @override
  String get idTypePassport => 'Passport';

  @override
  String get idNumberLabel => 'National ID Number';

  @override
  String get passportNumberLabel => 'Passport Number';

  @override
  String get activeChallengesTitle => 'Active Challenges';

  @override
  String challengeProgressLabel(String current, String goal) {
    return '$current / $goal trips';
  }

  @override
  String challengeRewardLabel(String points) {
    return 'Reward: $points points';
  }

  @override
  String get challengeMonthly => 'Monthly';

  @override
  String get challengeOneTime => 'One-Time';

  @override
  String challengePts(String pts) {
    return '+$pts pts';
  }

  @override
  String challengeProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String get amLabel => 'AM';

  @override
  String get pmLabel => 'PM';

  @override
  String floorLabel(String n) {
    return 'Floor $n';
  }

  @override
  String get standardClass => 'Standard';

  @override
  String get dateCannotBeToday =>
      'Travel date cannot be today. Please select a future date.';

  @override
  String get selectTravelDate => 'Select Travel Date';

  @override
  String get search => 'Search';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnread => 'Unread';

  @override
  String get filterMarketplace => 'Marketplace';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get seatLegendAvailable => 'Available';

  @override
  String get seatLegendSelected => 'Selected';

  @override
  String get seatLegendTaken => 'Taken';

  @override
  String get idTypeNone => 'None';

  @override
  String get passportNumberHint => 'e.g. A12345678';

  @override
  String get signupTitle => 'Create\nAccount.';

  @override
  String get joinFutureOfTravel => 'Join the future of travel';

  @override
  String get ticketMarketplace => 'Ticket Marketplace';

  @override
  String get findDealsFromTravelers => 'Find great deals from other travelers';

  @override
  String get filtersActive => 'Filters (active)';

  @override
  String get avgDiscount => 'Avg. Discount';

  @override
  String get totalListings => 'Total Listings';

  @override
  String get noListingsFound => 'No listings found.';

  @override
  String get tryRemovingFilters => 'Try removing some filters.';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get buyTicket => 'Buy Ticket';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get trainBooking => 'Train Booking';

  @override
  String get busBooking => 'Bus Booking';

  @override
  String get trainPassengerRequirements =>
      'Name, ID type & number required for each passenger';

  @override
  String get busPassengerRequirements =>
      'Name & phone number required for each passenger';

  @override
  String get agencyLabel => 'Agency';

  @override
  String get originLabel => 'Origin';

  @override
  String get destinationLabel => 'Destination';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get classLabel => 'Class';

  @override
  String get priceLabel => 'Price';

  @override
  String get areYouSureBuyTicket => 'Are you sure you want to buy this ticket?';

  @override
  String get ticketPurchasedSuccessfully => 'Ticket purchased successfully!';

  @override
  String get listingCancelledSuccessfully => 'Listing cancelled successfully!';

  @override
  String filterFrom(String gov) {
    return 'From: $gov';
  }

  @override
  String filterTo(String gov) {
    return 'To: $gov';
  }

  @override
  String filterDate(String date) {
    return 'Date: $date';
  }

  @override
  String get filterListings => 'Filter Listings';

  @override
  String get resetAll => 'Reset All';

  @override
  String get originGovernorate => 'Origin Governorate';

  @override
  String get destinationGovernorate => 'Destination Governorate';

  @override
  String get travelDateFilter => 'Travel Date';

  @override
  String get anyDate => 'Any date';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get hintCairo => 'e.g. Cairo';

  @override
  String get hintAlexandria => 'e.g. Alexandria';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSentTitle => 'Check your inbox!';

  @override
  String get emailSentMessage =>
      'If your email is registered, you will receive a password reset link shortly. Check your spam folder if you don\'t see it.';

  @override
  String get emailSendError => 'Could not send email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get reportIssue => 'Report an Issue';

  @override
  String get reportIssueTitle => 'Report an Issue';

  @override
  String get reportIssueHeaderTitle => 'We\'re here to help';

  @override
  String get reportIssueHeaderSubtitle =>
      'Describe your issue and our team will get back to you.';

  @override
  String get issueCategoryLabel => 'Issue Category';

  @override
  String get issueCategoryPayment => 'Payment';

  @override
  String get issueCategoryTrip => 'Trip Experience';

  @override
  String get issueCategoryAppBug => 'App Bug';

  @override
  String get issueCategoryAccount => 'Account Issue';

  @override
  String get issueCategoryOther => 'Other';

  @override
  String get issueTitleLabel => 'Title';

  @override
  String get issueTitleHint => 'Brief summary of your issue';

  @override
  String get issueTitleRequired => 'Title is required';

  @override
  String get issueDescriptionLabel => 'Description';

  @override
  String get issueDescriptionHint => 'Please describe your issue in detail...';

  @override
  String get issueDescriptionRequired => 'Description is required';

  @override
  String get issueDescriptionTooShort =>
      'Please provide at least 10 characters';

  @override
  String get issueSubmitBtn => 'Submit Report';

  @override
  String get issueSubmittedTitle => 'Report Submitted!';

  @override
  String get issueSubmittedBody =>
      'Thank you for reaching out. Our support team will review your issue and respond as soon as possible.';

  @override
  String get issueDone => 'Done';

  @override
  String get requestRefund => 'Request Refund';

  @override
  String get refundAlreadyRequested => 'Refund Requested';

  @override
  String get refundConfirmTitle => 'Request Refund?';

  @override
  String get refundConfirmBody =>
      'Are you sure you want to request a refund for this booking? Your wallet will be credited once the request is approved.';

  @override
  String get refundSubmitted => 'Refund request submitted successfully.';

  @override
  String get refundRequesting => 'Submitting refund request...';

  @override
  String get refundAccepted => 'Refund Accepted';

  @override
  String get refundRejected => 'Refund Rejected';

  @override
  String get expires => 'Expires';

  @override
  String get expired => 'Expired';

  @override
  String get cancelTripTitle => 'Cancel this trip?';

  @override
  String get cancelTripMsg =>
      'Your seat hold will be released and inventory restored. This cannot be undone.';

  @override
  String get keepIt => 'Keep It';

  @override
  String get cancelTripBtn => 'Cancel Trip';

  @override
  String get insufficientFunds => 'Insufficient funds.';

  @override
  String insufficientFundsDetail(String balance, String total) {
    return 'Insufficient funds. Your wallet balance is $balance EGP, but checkout total is $total EGP.';
  }

  @override
  String get checkoutFailed => 'Checkout failed';

  @override
  String ticketAddedButCheckoutFailed(String error) {
    return 'Ticket added to cart, but checkout failed: $error';
  }

  @override
  String originalPrice(String price, String currency) {
    return 'Original price: $price $currency';
  }

  @override
  String get seatsTakenError =>
      'One or more selected seats were just taken. Please refresh the seat map.';

  @override
  String get chooseCompany => 'Choose Company';

  @override
  String get allCompanies => 'All companies';

  @override
  String get arrivalTime => 'Arrival Time';

  @override
  String get identityDetails => 'Identity Details';

  @override
  String get identityDetailsWarning =>
      'Once set, identity details cannot be changed. Please make sure the entered details are correct.';

  @override
  String get nationalIdRequired => 'National ID is required.';

  @override
  String get passportNumberRequired => 'Passport number is required.';
}
