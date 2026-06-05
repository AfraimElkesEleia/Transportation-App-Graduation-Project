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
  String get noRecentSearches => 'لا توجد عمليات بحث سابقة';

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
  String get askingPrice => 'سعر الطلب';

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
  String get txChallengeReward => 'مكافأة تحدي';

  @override
  String get txBookingEarned => 'مكافأة حجز';

  @override
  String get txStatusAvailable => 'متاح';

  @override
  String get txStatusSpent => 'مُستخدم';

  @override
  String get txStatusExpired => 'منتهي الصلاحية';

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
  String profileTripsCount(String count) {
    return '$count رحلة';
  }

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
  String get popularRoutes => '🔥 رحلات شائعة';

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
  String get gov_Damietta => 'دمياط';

  @override
  String get gov_Matrouh => 'مطروح';

  @override
  String get gov_PortSaid => 'بورسعيد';

  @override
  String get challenges => 'التحديات';

  @override
  String get pointsHistory => 'سجل النقاط';

  @override
  String get noChallengesFound => 'لا توجد تحديات.';

  @override
  String get noPointHistory => 'لا يوجد سجل للنقاط.';

  @override
  String get activeChallenges => 'نشطة';

  @override
  String get completedChallenges => 'مكتملة';

  @override
  String get uploadingPhoto => 'جاري رفع الصورة...';

  @override
  String get photoUploaded => 'تم رفع الصورة';

  @override
  String photoUploadFailed(String msg) {
    return 'فشل رفع الصورة: $msg';
  }

  @override
  String get skipAndSave => 'تخطي وحفظ';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'أدخل الاسم الأول';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get lastNameHint => 'أدخل الاسم الأخير';

  @override
  String get lastNameRequired => 'الاسم الأخير مطلوب';

  @override
  String get familyName => 'اسم العائلة';

  @override
  String get familyNameHint => 'أدخل اسم العائلة / القبيلة';

  @override
  String get emailAddressValid => 'أدخل بريد إلكتروني صحيح';

  @override
  String get phoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get fixedDetails => 'تفاصيل ثابتة';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get countryCannotBeChanged => 'لا يمكن تغيير الدولة.';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String pointsBalanceIs(String n) {
    return 'رصيد النقاط: $n';
  }

  @override
  String expiringSoonCard(String n, String date) {
    return 'تنتهي قريباً: $n نقطة ($date)';
  }

  @override
  String get earnedPointsPending =>
      'النقاط المكتسبة معلقة حتى المغادرة وتنتهي صلاحيتها بعد 4 أشهر من المغادرة.';

  @override
  String get myCart => 'عربة التسوق';

  @override
  String get yourCartIsEmpty => 'عربة التسوق فارغة';

  @override
  String get addTripsToCart => 'أضف رحلات إلى عربة التسوق للدفع لاحقاً.';

  @override
  String get checkoutWallet => 'إتمام الدفع (بالمحفظة)';

  @override
  String get checkoutSuccess => 'تم الدفع بنجاح!\nتم الخصم من محفظتك.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get nationalIdOptional => 'رقم البطاقة القومية (اختياري)';

  @override
  String get nationalIdHint => 'مثال: 29901011234567';

  @override
  String get dateOfBirthLabel => 'تاريخ الميلاد';

  @override
  String get createPasswordHint => 'أنشئ كلمة مرور قوية';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get directTrip => 'مباشر';

  @override
  String stopsCount(String count) {
    return '$count توقف';
  }

  @override
  String get hideStops => 'إخفاء المحطات';

  @override
  String get showStops => 'عرض المحطات';

  @override
  String get routeStops => 'محطات الرحلة';

  @override
  String get howManyPassengers => 'كم عدد المسافرين؟';

  @override
  String get perSeat => 'لكل مقعد';

  @override
  String seatsAvailable(String n) {
    return '$n مقاعد متاحة';
  }

  @override
  String continueWithNPassengers(String n) {
    return 'متابعة مع $n مسافر';
  }

  @override
  String get useLoyaltyPoints => '💎 استخدم نقاط الولاء';

  @override
  String get noPointsYet => 'ليس لديك أي نقاط بعد. أكمل رحلات لكسب النقاط!';

  @override
  String get pointsCantBeApplied =>
      'لا يمكن تطبيق النقاط - إجمالي السلة منخفض جداً (الحد الأدنى 10 جنيهات).';

  @override
  String needMorePoints(String points) {
    return 'تحتاج إلى 20 نقطة على الأقل للخصم (= خصم 1 جنيه). لديك حالياً $points نقطة. استمر في الحجز لكسب المزيد!';
  }

  @override
  String get ptsLabel => 'نقطة';

  @override
  String get pointsInfo => 'ℹ️ 20 نقطة = 1 جنيه';

  @override
  String get pointsUsed => 'النقاط المستخدمة';

  @override
  String get discount => 'الخصم';

  @override
  String get remainingAfter => 'المتبقي بعد الخصم';

  @override
  String get finalTotal => 'الإجمالي النهائي';

  @override
  String ptsValue(String n) {
    return '$n نقطة';
  }

  @override
  String get from => 'من';

  @override
  String get book => 'حجز';

  @override
  String get fullSeats => 'مكتمل';

  @override
  String get skip => 'تخطي';

  @override
  String get ticketDetails => 'تفاصيل التذكرة';

  @override
  String ticketClass(String className) {
    return 'درجة $className';
  }

  @override
  String get to => 'إلى';

  @override
  String get departure => 'المغادرة';

  @override
  String get arrival => 'الوصول';

  @override
  String get bookingRef => 'رقم الحجز';

  @override
  String get passengersAndSeats => 'المسافرون والمقاعد';

  @override
  String get tapPassengerInfo => 'انقر على المسافر لعرض بطاقة الصعود';

  @override
  String idNum(String id) {
    return 'الرقم القومي: $id';
  }

  @override
  String seatNum(String seat) {
    return 'مقعد $seat';
  }

  @override
  String get seat => 'مقعد';

  @override
  String get pax => 'مسافر';

  @override
  String get passengerDetails => 'بيانات المسافرين';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get nationalId => 'الرقم القومي';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String passengerN(String n) {
    return 'مسافر $n';
  }

  @override
  String seatLabel(String n) {
    return 'المقعد: $n';
  }

  @override
  String passengersCount(String n) {
    return '$n مسافر';
  }

  @override
  String get selectSeats => 'اختر المقاعد';

  @override
  String get selectedSeatsLabel => 'المحدد: ';

  @override
  String seatsCount(String n) {
    return '$n مقاعد';
  }

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get noSeatsSelected => 'لم يتم اختيار مقاعد';

  @override
  String get travellingWithFamily => 'هل تسافر مع العائلة؟';

  @override
  String get autoFill => 'تعبئة تلقائية';

  @override
  String get autoFilled => 'تم التعبئة ✔';

  @override
  String get reFill => 'إعادة التعبئة';

  @override
  String get fillSeat1Info =>
      'أكمل المقعد الأول، ثم انسخ الاسم والهاتف للمقاعد الأخرى.';

  @override
  String get addEntireJourneyToCart => 'أضف الرحلة بالكامل إلى السلة';

  @override
  String get bookEntireJourneyNow => 'احجز الرحلة بالكامل الآن';

  @override
  String get buildJourney => 'ابنِ رحلتك';

  @override
  String selectTripForLeg(String n) {
    return 'اختر رحلة للجزء $n';
  }

  @override
  String selectSeatsForLeg(String n) {
    return 'اختر مقاعد الجزء $n';
  }

  @override
  String get reviewCheckout => 'مراجعة وإتمام';

  @override
  String get noTripsFoundForLeg => 'لا توجد رحلات لهذا الجزء.';

  @override
  String get tryAdjustingFilters => 'حاول تعديل الفلاتر أعلاه.';

  @override
  String get suggestedTransferRoute => 'مسار التحويل المقترح';

  @override
  String get transferAt => 'تحويل في';

  @override
  String get journeySummary => 'ملخص الرحلة';

  @override
  String get journeyOverview => 'نظرة عامة على الرحلة';

  @override
  String get connectionLayover => 'مدة الانتظار بين الرحلتين';

  @override
  String get totalJourneyDuration => 'المدة الإجمالية للرحلة';

  @override
  String get routeLabel => 'المسار';

  @override
  String get durationLabel => 'المدة';

  @override
  String get pricePerSeat => 'سعر المقعد';

  @override
  String get legTotal => 'إجمالي الجزء';

  @override
  String get selectedSeats => 'المقاعد المختارة';

  @override
  String get noArrivalTime => 'وقت الوصول غير متاح';

  @override
  String durationHoursMinutes(String hours, String minutes) {
    return '$hours س $minutes د';
  }

  @override
  String durationMinutes(String minutes) {
    return '$minutes د';
  }

  @override
  String legsCount(String n) {
    return '$n أجزاء';
  }

  @override
  String legN(String n) {
    return 'الجزء $n';
  }

  @override
  String get journeyAddedToCart => 'تمت إضافة الرحلة إلى السلة بنجاح!';

  @override
  String get bookingSuccessful => 'تم الحجز بنجاح!';

  @override
  String get indirectTripAddedToCart =>
      'تمت إضافة الرحلة غير المباشرة إلى السلة بنجاح!';

  @override
  String get pleaseSelectSeat => 'الرجاء اختيار مقعد';

  @override
  String selectExactlyNSeats(String n) {
    return 'الرجاء اختيار $n مقاعد بالضبط';
  }

  @override
  String canOnlySelectNSeats(String n) {
    return 'يمكنك اختيار $n مقعد فقط لهذا الجزء.';
  }

  @override
  String pleaseSelectNPassengers(String n) {
    return 'الرجاء اختيار $n مسافرين بالضبط';
  }

  @override
  String get fillNamePhoneFirst =>
      'الرجاء تعبئة الاسم والهاتف للمسافر الأول أولاً.';

  @override
  String filledNSeats(String n, String name) {
    return 'تمت تعبئة $n مقعد بـ \"$name\"';
  }

  @override
  String requiredCountSeats(String n, String m) {
    return 'مطلوب: $n مقاعد. تم اختيار: $m';
  }

  @override
  String get idTypeLabel => 'نوع الهوية';

  @override
  String get idTypeNationalId => 'بطاقة هوية وطنية';

  @override
  String get idTypePassport => 'جواز سفر';

  @override
  String get idNumberLabel => 'رقم بطاقة الهوية';

  @override
  String get passportNumberLabel => 'رقم جواز السفر';

  @override
  String get activeChallengesTitle => 'التحديات النشطة';

  @override
  String challengeProgressLabel(String current, String goal) {
    return '$current / $goal رحلة';
  }

  @override
  String challengeRewardLabel(String points) {
    return 'المكافأة: $points نقطة';
  }

  @override
  String get challengeMonthly => 'شهري';

  @override
  String get challengeOneTime => 'مرة واحدة';

  @override
  String challengePts(String pts) {
    return '+$pts نقطة';
  }

  @override
  String challengeProgress(String current, String goal) {
    return '$current / $goal';
  }

  @override
  String get amLabel => 'ص';

  @override
  String get pmLabel => 'م';

  @override
  String floorLabel(String n) {
    return 'الطابق $n';
  }

  @override
  String get standardClass => 'عادي';

  @override
  String get dateCannotBeToday =>
      'لا يمكن أن يكون تاريخ السفر اليوم. يرجى اختيار تاريخ مستقبلي.';

  @override
  String get selectTravelDate => 'اختر تاريخ السفر';

  @override
  String get search => 'بحث';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterUnread => 'غير مقروء';

  @override
  String get filterMarketplace => 'السوق';

  @override
  String get filterBoarding => 'الصعود';

  @override
  String get filterGamification => 'المكافآت';

  @override
  String get dismiss => 'إغلاق';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get yesterdayLabel => 'أمس';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String get notificationGeneral => 'عام';

  @override
  String get emptyMarketplaceTitle => 'لا يوجد نشاط في السوق بعد';

  @override
  String get emptyMarketplaceSubtitle => 'ستظهر إشعارات العروض والمبيعات هنا.';

  @override
  String get emptyUnreadTitle => 'أنت مطلع على كل شيء!';

  @override
  String get emptyUnreadSubtitle => 'لا توجد إشعارات غير مقروءة حالياً.';

  @override
  String get emptyBoardingTitle => 'لا توجد تنبيهات صعود';

  @override
  String get emptyBoardingSubtitle => 'ستظهر تذكيرات الرحلات القادمة هنا.';

  @override
  String get emptyGamificationTitle => 'لا يوجد نشاط مكافآت';

  @override
  String get emptyGamificationSubtitle => 'ستظهر إشعارات النقاط والتحديات هنا.';

  @override
  String get emptyNotificationsTitle => 'لا توجد إشعارات بعد';

  @override
  String get emptyNotificationsSubtitle =>
      'ستظهر هنا التحديثات المهمة حول رحلاتك ونشاط السوق.';

  @override
  String get seatLegendAvailable => 'متاح';

  @override
  String get seatLegendSelected => 'محدد';

  @override
  String get seatLegendTaken => 'محجوز';

  @override
  String get idTypeNone => 'بدون';

  @override
  String get passportNumberHint => 'مثال: A12345678';

  @override
  String get signupTitle => 'إنشاء\nحساب.';

  @override
  String get joinFutureOfTravel => 'انضم إلى مستقبل السفر';

  @override
  String get ticketMarketplace => 'سوق التذاكر';

  @override
  String get findDealsFromTravelers => 'ابحث عن أفضل العروض من المسافرين';

  @override
  String get filtersActive => 'تصفية (مفعّلة)';

  @override
  String get avgDiscount => 'متوسط الخصم';

  @override
  String get totalListings => 'إجمالي العروض';

  @override
  String get noListingsFound => 'لا توجد عروض.';

  @override
  String get tryRemovingFilters => 'حاول إزالة بعض الفلاتر.';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get buyTicket => 'شراء التذكرة';

  @override
  String get buyNow => 'اشترِ الآن';

  @override
  String get trainBooking => 'حجز قطار';

  @override
  String get busBooking => 'حجز حافلة';

  @override
  String get trainPassengerRequirements =>
      'الاسم ونوع الهوية ورقمها مطلوبة لكل مسافر';

  @override
  String get busPassengerRequirements => 'الاسم ورقم الهاتف مطلوبان لكل مسافر';

  @override
  String get agencyLabel => 'الوكالة';

  @override
  String get originLabel => 'نقطة الانطلاق';

  @override
  String get destinationLabel => 'الوجهة';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get classLabel => 'الدرجة';

  @override
  String get sellerLabel => 'البائع';

  @override
  String get priceLabel => 'السعر';

  @override
  String get areYouSureBuyTicket => 'هل أنت متأكد من شراء هذه التذكرة؟';

  @override
  String get ticketPurchasedSuccessfully => 'تم شراء التذكرة بنجاح!';

  @override
  String get listingCancelledSuccessfully => 'تم إلغاء الإدراج بنجاح!';

  @override
  String filterFrom(String gov) {
    return 'من: $gov';
  }

  @override
  String filterTo(String gov) {
    return 'إلى: $gov';
  }

  @override
  String filterDate(String date) {
    return 'التاريخ: $date';
  }

  @override
  String get filterListings => 'تصفية العروض';

  @override
  String get resetAll => 'إعادة ضبط الكل';

  @override
  String get originGovernorate => 'محافظة الانطلاق';

  @override
  String get destinationGovernorate => 'محافظة الوجهة';

  @override
  String get travelDateFilter => 'تاريخ السفر';

  @override
  String get anyDate => 'أي تاريخ';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get hintCairo => 'مثال: القاهرة';

  @override
  String get hintAlexandria => 'مثال: الإسكندرية';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين';

  @override
  String get sendResetLink => 'إرسال رابط الإعادة';

  @override
  String get emailSentTitle => 'تحقق من بريدك الوارد!';

  @override
  String get emailSentMessage =>
      'إذا كان بريدك الإلكتروني مسجلاً، ستستقبل رابط إعادة تعيين كلمة المرور قريباً.';

  @override
  String get emailSendError => 'تعذّر إرسال البريد الإلكتروني';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get supportTickets => 'تذاكر الدعم';

  @override
  String get noSupportTickets => 'لا توجد تذاكر دعم حتى الآن';

  @override
  String get supportTicketsEmptyBody => 'ستظهر المشكلات المرسلة هنا.';

  @override
  String get untitledTicket => 'تذكرة بدون عنوان';

  @override
  String get noDescriptionProvided => 'لا يوجد وصف.';

  @override
  String get reportIssue => 'الإبلاغ عن مشكلة';

  @override
  String get reportIssueTitle => 'الإبلاغ عن مشكلة';

  @override
  String get reportIssueHeaderTitle => 'نحن هنا للمساعدة';

  @override
  String get reportIssueHeaderSubtitle =>
      'صف مشكلتك وسيتواصل معك فريقنا في أقرب وقت.';

  @override
  String get issueCategoryLabel => 'فئة المشكلة';

  @override
  String get issueCategoryPayment => 'الدفع';

  @override
  String get issueCategoryTrip => 'تجربة الرحلة';

  @override
  String get issueCategoryAppBug => 'خطأ في التطبيق';

  @override
  String get issueCategoryAccount => 'مشكلة في الحساب';

  @override
  String get issueCategoryOther => 'أخرى';

  @override
  String get issueTitleLabel => 'العنوان';

  @override
  String get issueTitleHint => 'ملخص قصير لمشكلتك';

  @override
  String get issueTitleRequired => 'العنوان مطلوب';

  @override
  String get issueDescriptionLabel => 'الوصف';

  @override
  String get issueDescriptionHint => 'يرجى وصف مشكلتك بالتفصيل...';

  @override
  String get issueDescriptionRequired => 'الوصف مطلوب';

  @override
  String get issueDescriptionTooShort => 'يرجى كتابة 10 أحرف على الأقل';

  @override
  String get issueSubmitBtn => 'إرسال التقرير';

  @override
  String get issueSubmittedTitle => 'تم إرسال التقرير!';

  @override
  String get issueSubmittedBody =>
      'شكراً لتواصلك معنا. سيقوم فريق الدعم بمراجعة مشكلتك والرد عليك في أقرب وقت ممكن.';

  @override
  String get issueDone => 'تم';

  @override
  String get requestRefund => 'طلب استرداد';

  @override
  String get refundAlreadyRequested => 'تم طلب الاسترداد';

  @override
  String get refundConfirmTitle => 'طلب استرداد المبلغ؟';

  @override
  String get refundConfirmBody =>
      'هل أنت متأكد من طلب استرداد المبلغ لهذا الحجز؟ سيتم إضافة المبلغ إلى محفظتك بعد الموافقة على الطلب.';

  @override
  String get refundSubmitted => 'تم إرسال طلب الاسترداد بنجاح.';

  @override
  String get refundRequesting => 'جاري إرسال طلب الاسترداد...';

  @override
  String get refundAccepted => 'تم قبول الاسترداد';

  @override
  String get refundRejected => 'تم رفض الاسترداد';

  @override
  String get expires => 'ينتهي خلال';

  @override
  String get expired => 'منتهية';

  @override
  String get cancelTripTitle => 'إلغاء هذه الرحلة؟';

  @override
  String get cancelTripMsg =>
      'سيتم إلغاء حجز المقعد واستعادة المخزون. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get keepIt => 'الاحتفاظ بها';

  @override
  String get cancelTripBtn => 'إلغاء الرحلة';

  @override
  String get insufficientFunds => 'رصيد غير كافٍ.';

  @override
  String insufficientFundsDetail(String balance, String total) {
    return 'رصيد غير كافٍ. رصيد محفظتك هو $balance جنيه، ولكن إجمالي الدفع هو $total جنيه.';
  }

  @override
  String get checkoutFailed => 'فشل إتمام الدفع';

  @override
  String ticketAddedButCheckoutFailed(String error) {
    return 'تمت إضافة التذكرة إلى السلة، ولكن فشل إتمام الدفع: $error';
  }

  @override
  String originalPrice(String price, String currency) {
    return 'السعر الأصلي: $price $currency';
  }

  @override
  String get seatsTakenError =>
      'تم حجز واحد أو أكثر من المقاعد المختارة للتو. يرجى تحديث خريطة المقاعد.';

  @override
  String get chooseCompany => 'اختر الشركة';

  @override
  String get allCompanies => 'كل الشركات';

  @override
  String get arrivalTime => 'وقت الوصول';

  @override
  String get identityDetails => 'تفاصيل الهوية';

  @override
  String get identityDetailsWarning =>
      'بمجرد التعيين، لا يمكن تغيير تفاصيل الهوية. يرجى التأكد من صحة البيانات المدخلة.';

  @override
  String get nationalIdRequired => 'الرقم القومي مطلوب.';

  @override
  String get passportNumberRequired => 'رقم جواز السفر مطلوب.';

  @override
  String get gender => 'الجنس';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get selectCountryCode => 'اختر رمز الدولة';

  @override
  String get searchCountryOrCode => 'البحث عن الدولة أو الرمز...';

  @override
  String get selectDate => 'اختر التاريخ';
}
