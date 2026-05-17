// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'بحث';

  @override
  String get navTickets => 'تذاكري';

  @override
  String get navMarket => 'السوق';

  @override
  String get navProfile => 'ملفي';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get any => 'أي';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get no => 'لا';

  @override
  String get onboardingSubtitle1 => 'سافر بذكاء';

  @override
  String get onboardingTitle1 => 'اكتشف مصر';

  @override
  String get onboardingDesc1 => 'استكشف كل ركن في مصر...';

  @override
  String get onboardingSubtitle2 => 'ابقَ على اطلاع';

  @override
  String get onboardingTitle2 => 'تحديثات فورية';

  @override
  String get onboardingDesc2 => 'احصل على إشعارات فورية...';

  @override
  String get onboardingSubtitle3 => 'سافر بثقة';

  @override
  String get onboardingTitle3 => 'آمن وموثوق';

  @override
  String get onboardingDesc3 => 'احجز بثقة...';

  @override
  String get loginTitle => 'مرحباً \nبعودتك.';

  @override
  String get loginSubtitle => 'ادخل مستقبل السفر';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get sectionPersonal => 'المعلومات الشخصية';

  @override
  String get sectionContact => 'بيانات التواصل';

  @override
  String get sectionSecurity => 'الأمان';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get genderError => 'يرجى اختيار الجنس.';

  @override
  String get countryError => 'يرجى اختيار الدولة.';

  @override
  String get signOutTitle => 'تسجيل الخروج؟';

  @override
  String get signOutMsg => 'ستحتاج إلى تسجيل الدخول مجدداً...';

  @override
  String get cancelBtn => 'إلغاء';

  @override
  String get signOutBtn => 'تسجيل الخروج';

  @override
  String get language => 'اللغة';

  @override
  String get recentSearches => 'البحث الأخير';

  @override
  String get myTickets => 'تذاكري';

  @override
  String get digitalWallet => 'محفظة رحلاتك الرقمية';

  @override
  String get tabUpcoming => 'القادمة';

  @override
  String get tabActive => 'النشطة';

  @override
  String get tabPast => 'السابقة';

  @override
  String get noUpcoming => 'لا توجد رحلات قادمة';

  @override
  String get noActive => 'لا توجد رحلات قريبة';

  @override
  String get noPast => 'لا توجد رحلات سابقة';

  @override
  String get actionSuccess => 'تمت العملية بنجاح.';

  @override
  String get tapRefresh => 'اضغط زر التحديث أعلاه';

  @override
  String get useRefresh => 'استخدم زر التحديث أعلاه';

  @override
  String get resellTitle => 'إعادة بيع التذاكر';

  @override
  String get resellSubtitle => 'حوّل تذاكرك غير المستخدمة إلى نقود';

  @override
  String get yourUpcomingTickets => 'تذاكرك القادمة';

  @override
  String get statAvailable => 'متاح';

  @override
  String get statListed => 'مُدرج';

  @override
  String get statEstValue => 'القيمة التقديرية';

  @override
  String get listedOnMarket => 'مُدرج في السوق';

  @override
  String get availableForSale => 'متاح للبيع';

  @override
  String daysLeft(String n) {
    return 'باقي $n يوم';
  }

  @override
  String get totalPrice => 'الإجمالي:';

  @override
  String get sell => 'بيع';

  @override
  String get listForSale => 'أضف التذكرة للبيع';

  @override
  String askingPrice(String n) {
    return 'سعر الطلب (حد أقصى $n جنيه)';
  }

  @override
  String get listTicketBtn => 'أدرج التذكرة';

  @override
  String get cancelListing => 'إلغاء الإدراج';

  @override
  String get cancelListingMsg => 'هذا الحجز مُدرج حالياً في السوق...';

  @override
  String get cancelListingPrompt =>
      'هذا الحجز معروض حاليًا في السوق. هل تريد إزالته من البيع؟';

  @override
  String get noResellable => 'لا توجد تذاكر قادمة متاحة لإعادة البيع.';

  @override
  String get resellRules => 'التذاكر المؤكدة والقادمة فقط...';

  @override
  String get listingUpdated => 'تم تحديث الإدراج بنجاح!';

  @override
  String get priceMustBePos => 'يجب أن يكون السعر أكبر من صفر.';

  @override
  String maxPrice(String n) {
    return 'الحد الأقصى للسعر $n جنيه.';
  }

  @override
  String get all => 'الكل';

  @override
  String get bus => 'أتوبيس';

  @override
  String get train => 'قطار';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get lowestPrice => 'الأقل سعراً';

  @override
  String get shortestDuration => 'الأقصر مدة';

  @override
  String get departureTime => 'وقت المغادرة';

  @override
  String get maxPriceText => 'أقصى سعر';

  @override
  String get filters => 'تصفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get searchIndirectTrips => 'البحث عن رحلات غير مباشرة';

  @override
  String get noTripsFound => 'لا توجد رحلات متاحة';

  @override
  String get searchingConnectingRoutes => 'جاري البحث عن رحلات غير مباشرة...';

  @override
  String get noConnectingRoutes => 'لا توجد رحلات غير مباشرة متاحة.';

  @override
  String get connectingRoutes => 'رحلات غير مباشرة';

  @override
  String get noDirectTripsFound => 'لا توجد رحلات مباشرة';

  @override
  String get trySearchingIndirect =>
      'حاول البحث عن رحلات غير مباشرة بتوقف واحد';

  @override
  String get fillFromToBeforeReverse =>
      'الرجاء تحديد نقطة الانطلاق والوجهة قبل العكس.';

  @override
  String get fillFromToBeforeReturn =>
      'الرجاء تحديد نقطة الانطلاق والوجهة قبل العودة.';

  @override
  String get selectDepartureGov => 'الرجاء تحديد محافظة الانطلاق';

  @override
  String get selectDestinationGov => 'الرجاء تحديد محافظة الوجهة';

  @override
  String get destMustDiffer => 'يجب أن تختلف الوجهة عن نقطة الانطلاق';

  @override
  String get destGovMustDiffer => 'يجب أن تختلف محافظة الوجهة عن الانطلاق';

  @override
  String get selectDepartureDate => 'الرجاء تحديد تاريخ الانطلاق';

  @override
  String get selectReturnDate => 'الرجاء تحديد تاريخ العودة';

  @override
  String get returnDateBeforeDep => 'لا يمكن أن يكون تاريخ العودة قبل المغادرة';

  @override
  String get dateCannotBeEarlier =>
      'لا يمكن أن يكون التاريخ قبل الرحلة السابقة';

  @override
  String get useStandardSearchSingleTrip =>
      'يرجى استخدام البحث العادي لرحلة واحدة.';

  @override
  String get loadingStations => 'جاري تحميل المحطات...';

  @override
  String get trip => 'رحلة';

  @override
  String get fromGov => 'محافظة الانطلاق';

  @override
  String get toGov => 'محافظة الوجهة';

  @override
  String get multiDestNote =>
      'ملاحظة: اختر أحد هذه الخيارات فقط بعد إكمال خطة رحلتك بالكامل.';

  @override
  String get stepByStepReverse => 'عكس الرحلة خطوة بخطوة';

  @override
  String get directReturn => 'عودة مباشرة';

  @override
  String get fillFromToBeforeAdding =>
      'الرجاء تحديد نقطة الانطلاق والوجهة قبل إضافة رحلة جديدة.';

  @override
  String get addAnotherDestination => 'إضافة وجهة أخرى';

  @override
  String get undoAutoGeneratedTrips => 'التراجع عن الرحلات التلقائية';

  @override
  String get searchMultiDestination => 'بحث عن وجهات متعددة';

  @override
  String get roundTrip => 'ذهاب وعودة';

  @override
  String get selectOutbound => 'اختر رحلة الذهاب';

  @override
  String get selectReturn => 'اختر رحلة العودة';

  @override
  String get outboundSummary => 'ملخص الذهاب';

  @override
  String arrivesAt(String time) {
    return 'يصل في: $time';
  }

  @override
  String get noOutbound => 'لا توجد رحلات ذهاب متاحة.';

  @override
  String get noReturn => 'لا توجد رحلات عودة لتاريخك.';

  @override
  String get step1Seats => 'الخطوة 1: اختر مقاعد الذهاب';

  @override
  String get step2Seats => 'الخطوة 2: اختر مقاعد العودة';

  @override
  String get previous => 'السابق';

  @override
  String get roundTripSummary => 'ملخص الرحلة ذهاباً وعودةً';

  @override
  String get outbound => 'الذهاب';

  @override
  String get returnTrip => 'العودة';

  @override
  String get grandTotal => 'الإجمالي الكلي';

  @override
  String get proceedToPassenger => 'المتابعة لبيانات المسافرين';

  @override
  String nSeats(String n) {
    return '$n مقاعد';
  }

  @override
  String get actionSuccessful => 'تمت العملية بنجاح.';

  @override
  String get upcoming => 'القادمة';

  @override
  String get active => 'النشطة';

  @override
  String get past => 'السابقة';

  @override
  String get noUpcomingTrips => 'لا توجد رحلات قادمة';

  @override
  String get noActiveTrips => 'لا توجد رحلات نشطة';

  @override
  String get noPastTrips => 'لا توجد رحلات سابقة';

  @override
  String get refreshTickets => 'اضغط على زر التحديث في الأعلى';

  @override
  String get resellTickets => 'إعادة بيع التذاكر';

  @override
  String get turnTicketsIntoCash => 'حوّل تذاكرك غير المستخدمة إلى أموال';

  @override
  String get listTicketForSale => 'اعرض التذكرة للبيع';

  @override
  String get available => 'متاح';

  @override
  String get listed => 'معروض';

  @override
  String get estValue => 'القيمة التقديرية';

  @override
  String get listedOnMarketplace => 'معروضة في السوق';

  @override
  String get priceGreaterThanZero => 'يجب أن يكون السعر أكبر من 0.';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get txDeposit => 'إيداع';

  @override
  String get txTicketPurchase => 'شراء تذكرة';

  @override
  String get txRedemption => 'استرداد';

  @override
  String get txReward => 'مكافأة';

  @override
  String get welcome => '!مرحباً';

  @override
  String get whereToGoToday => 'أين تريد الذهاب اليوم؟';

  @override
  String get searchTrip => 'بحث عن رحلة';

  @override
  String get multiDestination => 'وجهات متعددة';

  @override
  String get oneWay => 'ذهاب فقط';

  @override
  String get roundTripToggle => 'ذهاب وعودة';

  @override
  String get transportType => 'نوع المواصلات';

  @override
  String get anyStation => 'أي محطة';

  @override
  String get travelDate => 'تاريخ السفر';

  @override
  String get returnDate => 'تاريخ العودة';

  @override
  String get myWallet => 'محفظتي';

  @override
  String get walletActive => 'نشطة';

  @override
  String get availableBalance => 'الرصيد المتاح';

  @override
  String get charge => 'شحن';

  @override
  String get history => 'السجل';

  @override
  String get chargeWallet => 'شحن المحفظة';

  @override
  String get walletChargedSuccess => 'تم شحن المحفظة بنجاح!';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get noTransactionsYet => 'لا توجد معاملات بعد';

  @override
  String get simulatedPayment => 'دفع تجريبي • لا يوجد خصم حقيقي';

  @override
  String get sellAllTickets => 'بيع جميع التذاكر';

  @override
  String get marketplace => 'السوق';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get loyaltyHub => 'مركز التحديات والمكافآت';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm => 'تسجيل الخروج؟';

  @override
  String get signOutBody => 'ستحتاج إلى تسجيل الدخول مجدداً للوصول إلى حسابك.';

  @override
  String get egp => 'جنيه';

  @override
  String get walletChargedSuccessfully => 'تم شحن المحفظة بنجاح!';

  @override
  String get confirmPayment => 'تأكيد الدفع';

  @override
  String get amountEgp => 'المبلغ (جنيه)';

  @override
  String get enterValidAmount => 'أدخل مبلغاً صحيحاً';

  @override
  String get amountMustBeRange => 'يجب أن يكون المبلغ بين 10 و 10000 جنيه';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get mustBe16Digits => 'يجب أن يكون 16 رقماً';

  @override
  String get expiry => 'تاريخ انتهاء الصلاحية';

  @override
  String get formatMmYy => 'الصيغة: شش/سس';

  @override
  String get threeDigitsRequired => 'مطلوب 3 أرقام';

  @override
  String get loyaltyPoints => 'نقاط المكافآت';

  @override
  String get pts => 'نقطة';

  @override
  String get noExpiringPoints => 'لا توجد نقاط تنتهي صلاحيتها حالياً';

  @override
  String ptsExpired(String n) {
    return 'انتهت صلاحية $n نقطة';
  }

  @override
  String ptsExpireTomorrow(String n) {
    return 'تنتهي صلاحية $n نقطة غداً';
  }

  @override
  String ptsExpireInDays(String n, String d) {
    return 'تنتهي صلاحية $n نقطة خلال $d يوم';
  }

  @override
  String ptsExpireInMonthsDays(String n, String m, String d) {
    return 'تنتهي صلاحية $n نقطة خلال $m و $d';
  }

  @override
  String ptsExpireInMonths(String n, String m) {
    return 'تنتهي صلاحية $n نقطة خلال $m';
  }

  @override
  String get oneMonth => 'شهر واحد';

  @override
  String monthsPlural(String m) {
    return '$m أشهر';
  }

  @override
  String get oneDay => 'يوم واحد';

  @override
  String daysPlural(String d) {
    return '$d أيام';
  }

  @override
  String get pointsPending =>
      'تظل النقاط معلقة حتى المغادرة وتنتهي صلاحيتها بعد 4 أشهر من المغادرة.';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get manageAccount => 'إدارة حسابك';

  @override
  String get planYourJourney => 'خطط لرحلتك';

  @override
  String get departureDate => 'تاريخ الانطلاق';

  @override
  String get subCityOptional => 'مدينة فرعية (اختياري — أي محطة)';

  @override
  String govHint(String title) {
    return '$title (مثل القاهرة، الأقصر)';
  }

  @override
  String get popularRoutes => 'مسارات شائعة';

  @override
  String get latestNews => 'أحدث الأخبار';

  @override
  String get gov_Cairo => 'القاهرة';

  @override
  String get gov_Alexandria => 'الإسكندرية';

  @override
  String get gov_Giza => 'الجيزة';

  @override
  String get gov_Aswan => 'أسوان';

  @override
  String get gov_Luxor => 'الأقصر';

  @override
  String get gov_Minya => 'المنيا';

  @override
  String get gov_Beheira => 'البحيرة';

  @override
  String get gov_Qena => 'قنا';

  @override
  String get gov_Sohag => 'سوهاج';

  @override
  String get gov_Asyut => 'أسيوط';

  @override
  String get gov_Fayoum => 'الفيوم';

  @override
  String get gov_BeniSuef => 'بني سويف';

  @override
  String get gov_Sharqia => 'الشرقية';

  @override
  String get gov_Dakahlia => 'الدقهلية';

  @override
  String get gov_Gharbiya => 'الغربية';

  @override
  String get gov_KafrElSheikh => 'كفر الشيخ';

  @override
  String get gov_Monufia => 'المنوفية';

  @override
  String get gov_Qalyubia => 'القليوبية';

  @override
  String get gov_Ismailia => 'الإسماعيلية';

  @override
  String get gov_Suez => 'السويس';

  @override
  String get gov_PortSaid => 'بورسعيد';

  @override
  String get gov_Damietta => 'دمياط';
}
