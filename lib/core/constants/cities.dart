
class SubCity {
  final String slug;
  final String nameEn;
  final String nameAr;
  SubCity({required this.slug, required this.nameEn, required this.nameAr});
}

class Governorate {
  final String slug;
  final String nameEn;
  final String nameAr;
  final List<SubCity> subCities;
  Governorate({
    required this.slug,
    required this.nameEn,
    required this.nameAr,
    required this.subCities,
  });
}

final List<Governorate> egyptGovernorates = [
  Governorate(
    slug: "cairo",
    nameEn: "Cairo",
    nameAr: "القاهرة",
    subCities: [
      SubCity(
        slug: "shobra-khemah",
        nameEn: "Shobra El Kheima",
        nameAr: "شبرا الخيمة",
      ),
      SubCity(
        slug: "azhar-university",
        nameEn: "Al-Azhar University",
        nameAr: "جامعة الأزهر",
      ),
      SubCity(
        slug: "zawya-hamraa",
        nameEn: "El Zawya El Hamra",
        nameAr: "الزاوية الحمراء",
      ),
      SubCity(slug: "zaytoun-q", nameEn: "El Zeitoun", nameAr: "الزيتون ق"),
      SubCity(
        slug: "bashtil",
        nameEn: "Bashtil Station",
        nameAr: "بشتيل المحطة",
      ),
      SubCity(slug: "bashtil-b", nameEn: "Bashtil Town", nameAr: "بشتيل البلد"),
      SubCity(slug: "werdan", nameEn: "Werdan", nameAr: "وردان"),
      SubCity(slug: "birqash", nameEn: "Birqash", nameAr: "برقاش"),
      SubCity(
        slug: "qanatir-n",
        nameEn: "El Qanater El Khayriyya",
        nameAr: "القناطر ج",
      ),
      SubCity(
        slug: "shibin-qanatir",
        nameEn: "Shibin El Qanatir",
        nameAr: "شبين القناطر",
      ),
    ],
  ),
  Governorate(
    slug: "giza",
    nameEn: "Giza",
    nameAr: "الجيزة",
    subCities: [
      SubCity(
        slug: "giza-cairo",
        nameEn: "Giza (Main Station)",
        nameAr: "الجيزة / القاهرة",
      ),
      SubCity(
        slug: "alsads-mn-aktwbr",
        nameEn: "6th of October City",
        nameAr: "السادس من أكتوبر",
      ),
      SubCity(
        slug: "sheikh-zayed",
        nameEn: "Sheikh Zayed",
        nameAr: "الشيخ زايد",
      ),
      SubCity(slug: "hawamdeyya", nameEn: "El Hawamdeyya", nameAr: "الحوامدية"),
      SubCity(slug: "badrshein", nameEn: "El Badrshein", nameAr: "البدرشين"),
      SubCity(slug: "ayat", nameEn: "El Ayat", nameAr: "العياط"),
      SubCity(slug: "mazghounah", nameEn: "El Mazghounah", nameAr: "المزغونة"),
      SubCity(slug: "ossim", nameEn: "Ossim", nameAr: "اوسيم"),
      SubCity(slug: "qata", nameEn: "El Qata Station", nameAr: "القطا"),
      SubCity(slug: "qata-b", nameEn: "El Qata Town", nameAr: "القطا البلد"),
    ],
  ),
  Governorate(
    slug: "alexandria",
    nameEn: "Alexandria",
    nameAr: "الإسكندرية",
    subCities: [
      SubCity(slug: "sidi-gaber", nameEn: "Sidi Gaber", nameAr: "سيدي جابر"),
      SubCity(slug: "moharam-beek", nameEn: "Moharam Beik", nameAr: "محرم بك"),
      SubCity(slug: "hadrah", nameEn: "El Hadra", nameAr: "الحضرة"),
      SubCity(slug: "amreyah", nameEn: "El Amreyah", nameAr: "العامرية"),
      SubCity(
        slug: "burj-arab-airport",
        nameEn: "Borg El Arab Airport",
        nameAr: "مطار برج العرب",
      ),
      SubCity(slug: "burj-arab-o", nameEn: "Borg El Arab", nameAr: "برج العرب"),
    ],
  ),
  Governorate(
    slug: "qalyoubia",
    nameEn: "Qalyoubia",
    nameAr: "القليوبية",
    subCities: [
      SubCity(slug: "banha", nameEn: "Banha", nameAr: "بنها"),
      SubCity(slug: "qaha", nameEn: "Qaha", nameAr: "قها"),
      SubCity(slug: "qalyoub", nameEn: "Qalyoub Station", nameAr: "قليوب"),
      SubCity(slug: "qalyoub-b", nameEn: "Qalyoub Town", nameAr: "قليوب البلد"),
      SubCity(slug: "toukh", nameEn: "Toukh", nameAr: "طوخ"),
      SubCity(slug: "khatatbah", nameEn: "El Khatatba", nameAr: "الخطاطبة"),
    ],
  ),
  Governorate(
    slug: "menoufia",
    nameEn: "Menoufia",
    nameAr: "المنوفية",
    subCities: [
      SubCity(
        slug: "shebeen-kom-n",
        nameEn: "Shibin El Kom Station",
        nameAr: "شبين الكوم ج",
      ),
      SubCity(
        slug: "shebeen-kom-o",
        nameEn: "Shibin El Kom Town",
        nameAr: "شبين الكوم ق",
      ),
      SubCity(slug: "minuf", nameEn: "Menuf", nameAr: "منوف"),
      SubCity(slug: "tala", nameEn: "Tala", nameAr: "تلا"),
      SubCity(slug: "ashmun", nameEn: "Ashmoun", nameAr: "اشمون"),
      SubCity(slug: "shanawan", nameEn: "Shanawan", nameAr: "شنوان"),
      SubCity(
        slug: "berket-saba",
        nameEn: "Berket El Sab",
        nameAr: "بركة السبع",
      ),
    ],
  ),
  Governorate(
    slug: "gharbia",
    nameEn: "Gharbia",
    nameAr: "الغربية",
    subCities: [
      SubCity(slug: "tanta", nameEn: "Tanta", nameAr: "طنطا"),
      SubCity(
        slug: "kafr-zayat",
        nameEn: "Kafr El Zayat",
        nameAr: "كفر الزيات",
      ),
      SubCity(slug: "tawfiqiah", nameEn: "El Tawfiqiyya", nameAr: "التوفيقية"),
      SubCity(slug: "santa", nameEn: "Santa", nameAr: "السنطة"),
      SubCity(slug: "zefta", nameEn: "Zefta", nameAr: "زفتى"),
      SubCity(slug: "qotouri", nameEn: "El Qutouriyya", nameAr: "القطورى"),
      SubCity(
        slug: "mahalla-kubra",
        nameEn: "El Mahalla El Kubra",
        nameAr: "المحلة الكبرى",
      ),
      SubCity(slug: "tansa", nameEn: "Tansa", nameAr: "طنسا"),
      SubCity(
        slug: "mahallat-mousa",
        nameEn: "Mahallet Moussa",
        nameAr: "محلة موسى",
      ),
      SubCity(
        slug: "mahallat-rouh",
        nameEn: "Mahallet Rouh",
        nameAr: "محلة روح",
      ),
    ],
  ),
  Governorate(
    slug: "beheira",
    nameEn: "Beheira",
    nameAr: "البحيرة",
    subCities: [
      SubCity(slug: "damanhour", nameEn: "Damanhour", nameAr: "دمنهور"),
      SubCity(
        slug: "kafr-dawar",
        nameEn: "Kafr El Dawar",
        nameAr: "كفر الدوار",
      ),
      SubCity(
        slug: "itay-barud",
        nameEn: "Itay El Barud",
        nameAr: "ايتاي البارود",
      ),
      SubCity(slug: "abo-homos", nameEn: "Abu Homos", nameAr: "ابو حمص"),
      SubCity(slug: "kom-hamada", nameEn: "Kom Hamada", nameAr: "كوم حمادة"),
      SubCity(
        slug: "modiriyat-tahrir",
        nameEn: "Tahrir Directorate",
        nameAr: "مديرية التحرير",
      ),
      SubCity(
        slug: "kom-abo-rady",
        nameEn: "Kom Abu Rady",
        nameAr: "كوم أبو راضي",
      ),
      SubCity(slug: "sandanhour", nameEn: "Sandanhour", nameAr: "سندنهور"),
      SubCity(slug: "sidi-ghazy", nameEn: "Sidi Ghazi", nameAr: "سيدي غازي"),
    ],
  ),
  Governorate(
    slug: "kafr-sheikh",
    nameEn: "Kafr El Sheikh",
    nameAr: "كفر الشيخ",
    subCities: [
      SubCity(
        slug: "kafr-sheikh",
        nameEn: "Kafr El Sheikh",
        nameAr: "كفر الشيخ",
      ),
      SubCity(slug: "desouk", nameEn: "Desouk", nameAr: "دسوق"),
      SubCity(slug: "biyala", nameEn: "Biyala", nameAr: "بيلا"),
      SubCity(slug: "qleen", nameEn: "Qillin Station", nameAr: "قلين"),
      SubCity(slug: "qleen-b", nameEn: "Qillin Town", nameAr: "قلين البلد"),
      SubCity(slug: "sakha", nameEn: "Sakha", nameAr: "سخا"),
      SubCity(slug: "hamoul", nameEn: "El Hamoul", nameAr: "الحامول"),
      SubCity(slug: "kafr-bulin", nameEn: "Kafr Bulin", nameAr: "كفر بولين"),
      SubCity(slug: "shatanof", nameEn: "Shatahnof", nameAr: "شطانوف"),
      SubCity(slug: "akhmas", nameEn: "El Akhmas", nameAr: "الاخماس"),
    ],
  ),
  Governorate(
    slug: "dakahlia",
    nameEn: "Dakahlia",
    nameAr: "الدقهلية",
    subCities: [
      SubCity(slug: "mansoura", nameEn: "Mansoura", nameAr: "المنصورة"),
      SubCity(slug: "talkha", nameEn: "Talka", nameAr: "طلخا"),
      SubCity(slug: "samannoud", nameEn: "Samannoud", nameAr: "سمنود"),
      SubCity(slug: "mit-ghamer", nameEn: "Mit Ghamr", nameAr: "ميت غمر"),
      SubCity(slug: "sandub", nameEn: "Sandub", nameAr: "سندوب"),
      SubCity(slug: "shirbin", nameEn: "Shirbin", nameAr: "شربين"),
      SubCity(slug: "belkas", nameEn: "Bilqas", nameAr: "بلقاس"),
      SubCity(slug: "gelatmah", nameEn: "El Galatma", nameAr: "الجلاتمة"),
      SubCity(
        slug: "senbellawein",
        nameEn: "Sinbillawayn",
        nameAr: "السنبلاوين",
      ),
      SubCity(
        slug: "tafhna-ashraf",
        nameEn: "Tafhnna El Ashraf",
        nameAr: "تفهنا الاشراف",
      ),
    ],
  ),
  Governorate(
    slug: "sharqia",
    nameEn: "Sharqia",
    nameAr: "الشرقية",
    subCities: [
      SubCity(slug: "zagazig", nameEn: "Zagazig", nameAr: "الزقازيق"),
      SubCity(
        slug: "zagazig-university",
        nameEn: "Zagazig University",
        nameAr: "جامعة الزقازيق",
      ),
      SubCity(slug: "belbes", nameEn: "Bilbeis", nameAr: "بلبيس"),
      SubCity(slug: "inshas", nameEn: "Inshas", nameAr: "انشاص"),
      SubCity(slug: "kafr-saqr", nameEn: "Kafr Saqr", nameAr: "كفر صقر"),
      SubCity(slug: "abo-hammad", nameEn: "Abu Hammad", nameAr: "ابو حماد"),
      SubCity(
        slug: "mahjar-abo-hammad",
        nameEn: "Mahgar Abu Hammad",
        nameAr: "محجر ابو حماد",
      ),
      SubCity(slug: "hihya", nameEn: "Hihia", nameAr: "هيها"),
      SubCity(slug: "mashtul", nameEn: "Mashtoul El Souq", nameAr: "مشتول"),
      SubCity(
        slug: "menyet-qamh",
        nameEn: "Minyat El Qamh",
        nameAr: "منية القمح",
      ),
      SubCity(
        slug: "az-zanklun",
        nameEn: "El Zaqaziq (Zankaloun)",
        nameAr: "الزنكلون",
      ),
    ],
  ),
  Governorate(
    slug: "damietta",
    nameEn: "Damietta",
    nameAr: "دمياط",
    subCities: [
      SubCity(slug: "damietta", nameEn: "Damietta", nameAr: "دمياط"),
      SubCity(slug: "kafr-saad", nameEn: "Kafr Saad", nameAr: "كفر سعد"),
      SubCity(slug: "rous", nameEn: "El Roos", nameAr: "الروس"),
    ],
  ),
  Governorate(
    slug: "port-said",
    nameEn: "Port Said",
    nameAr: "بورسعيد",
    subCities: [
      SubCity(slug: "port-said", nameEn: "Port Said", nameAr: "بورسعيد"),
    ],
  ),
  Governorate(
    slug: "ismailia",
    nameEn: "Ismailia",
    nameAr: "الإسماعيلية",
    subCities: [
      SubCity(slug: "ismailia", nameEn: "Ismailia", nameAr: "الاسماعيلية"),
      SubCity(slug: "fayed", nameEn: "Fayed", nameAr: "فايد"),
      SubCity(slug: "qassasin", nameEn: "El Qassassin", nameAr: "القصاصين"),
      SubCity(
        slug: "tal-kabeer",
        nameEn: "El Tal El Kebir",
        nameAr: "التل الكبير",
      ),
      SubCity(slug: "serapeum", nameEn: "Serapeum", nameAr: "سرابيوم"),
      SubCity(
        slug: "qantara-gharb",
        nameEn: "El Qantara West",
        nameAr: "القنطرة غرب",
      ),
    ],
  ),
  Governorate(
    slug: "suez",
    nameEn: "Suez",
    nameAr: "السويس",
    subCities: [SubCity(slug: "suez", nameEn: "Suez", nameAr: "السويس")],
  ),
  Governorate(
    slug: "matrouh",
    nameEn: "Matrouh",
    nameAr: "مطروح",
    subCities: [
      SubCity(
        slug: "marsa-matruh",
        nameEn: "Marsa Matrouh",
        nameAr: "مرسى مطروح",
      ),
      SubCity(slug: "alamein", nameEn: "El Alamein", nameAr: "العلمين"),
      SubCity(slug: "dabaa", nameEn: "El Dabaa", nameAr: "الضبعة"),
      SubCity(slug: "hammam", nameEn: "Hammam", nameAr: "الحمام"),
      SubCity(
        slug: "sidi-abd-rahman",
        nameEn: "Sidi Abd El Rahman",
        nameAr: "سيدي عبد الرحمن",
      ),
      SubCity(slug: "sidi-henash", nameEn: "Sidi Hanish", nameAr: "سيدي حنيش"),
      SubCity(slug: "ras-hekmah", nameEn: "Ras El Hikma", nameAr: "راس الحكمة"),
      SubCity(slug: "fokah", nameEn: "Fouka", nameAr: "فوكة"),
    ],
  ),
  Governorate(
    slug: "fayoum",
    nameEn: "Fayoum",
    nameAr: "الفيوم",
    subCities: [
      SubCity(slug: "faiyum", nameEn: "Fayoum", nameAr: "الفيوم"),
      SubCity(
        slug: "amereyat-fayoum",
        nameEn: "Amereyat El Fayoum",
        nameAr: "عامرية الفيوم",
      ),
      SubCity(slug: "sanhur", nameEn: "Sanhour", nameAr: "سنهور"),
      SubCity(slug: "ebshway", nameEn: "Ibshway", nameAr: "ابشواي"),
    ],
  ),
  Governorate(
    slug: "beni-suef",
    nameEn: "Beni Suef",
    nameAr: "بني سويف",
    subCities: [
      SubCity(slug: "beni-suef", nameEn: "Beni Suef", nameAr: "بني سويف"),
      SubCity(slug: "biba", nameEn: "Biba", nameAr: "ببا"),
      SubCity(slug: "fashn", nameEn: "El Fashn", nameAr: "الفشن"),
      SubCity(slug: "wasta", nameEn: "El Wasta", nameAr: "الواسطى"),
      SubCity(slug: "maymun", nameEn: "El Maymoun", nameAr: "الميمون"),
      SubCity(slug: "nawa", nameEn: "Nawa", nameAr: "نوى"),
      SubCity(
        slug: "monshaat-abo-rayyah",
        nameEn: "Monshat Abu Rayya",
        nameAr: "منشاة ابو رية",
      ),
    ],
  ),
  Governorate(
    slug: "minya",
    nameEn: "Minya",
    nameAr: "المنيا",
    subCities: [
      SubCity(slug: "minya", nameEn: "Minya", nameAr: "المنيا"),
      SubCity(slug: "mallawi", nameEn: "Mallawi", nameAr: "ملوي"),
      SubCity(slug: "samalut", nameEn: "Samalout", nameAr: "سملوط"),
      SubCity(slug: "matay", nameEn: "Mattay", nameAr: "مطاي"),
      SubCity(slug: "maghagha", nameEn: "Maghagha", nameAr: "مغاغة"),
      SubCity(slug: "beni-mazar", nameEn: "Beni Mazar", nameAr: "بني مزار"),
      SubCity(slug: "beni-hidayr", nameEn: "Beni Hedir", nameAr: "بني حدير"),
      SubCity(slug: "beni-salamah", nameEn: "Beni Salama", nameAr: "بني سلامة"),
      SubCity(slug: "dayr-mawas", nameEn: "Deir Mawas", nameAr: "دير مواس"),
      SubCity(slug: "abo-qurqas", nameEn: "Abu Qirqas", nameAr: "ابو قرقاص"),
      SubCity(slug: "edwah", nameEn: "El Adwa", nameAr: "العدوة"),
      SubCity(slug: "galal", nameEn: "Galal", nameAr: "جلال"),
      SubCity(slug: "matanyah", nameEn: "El Mataniyya", nameAr: "المتانية"),
      SubCity(slug: "dayrout", nameEn: "Dayrout", nameAr: "ديروط"),
    ],
  ),
  Governorate(
    slug: "asyut",
    nameEn: "Asyut",
    nameAr: "أسيوط",
    subCities: [
      SubCity(slug: "asyut", nameEn: "Asyut", nameAr: "اسيوط"),
      SubCity(slug: "manfalut", nameEn: "Manfalout", nameAr: "منفلوط"),
      SubCity(slug: "qusiyyah", nameEn: "El Qusiyya", nameAr: "القوصية"),
      SubCity(slug: "sidfa", nameEn: "Sedfa", nameAr: "صدفا"),
      SubCity(slug: "manqabad", nameEn: "Manqabad", nameAr: "منقباد"),
      SubCity(slug: "aba-wakf", nameEn: "Abaa El Waqf", nameAr: "ابا الوقف"),
      SubCity(slug: "abo-tij", nameEn: "Abu Tig", nameAr: "ابو تيج"),
      SubCity(slug: "ashmant", nameEn: "Ashmant", nameAr: "اشمنت"),
    ],
  ),
  Governorate(
    slug: "sohag",
    nameEn: "Sohag",
    nameAr: "سوهاج",
    subCities: [
      SubCity(slug: "sohag", nameEn: "Sohag", nameAr: "سوهاج"),
      SubCity(slug: "tahta", nameEn: "Tahta", nameAr: "طهطا"),
      SubCity(slug: "tima", nameEn: "Tema", nameAr: "طما"),
      SubCity(slug: "maragha", nameEn: "El Maraga", nameAr: "المراغة"),
      SubCity(slug: "monshaa", nameEn: "El Monsha'a", nameAr: "المنشأة"),
      SubCity(slug: "girga", nameEn: "Gerga", nameAr: "جرجا"),
      SubCity(slug: "balyana", nameEn: "El Balyana", nameAr: "البلينا"),
      SubCity(slug: "dar-alslam", nameEn: "Dar El Salam", nameAr: "دار السلام"),
      SubCity(slug: "abo-tesht", nameEn: "Abu Tesht", nameAr: "ابو تشت"),
      SubCity(slug: "bardis", nameEn: "Bardis", nameAr: "برديس"),
      SubCity(slug: "bardein", nameEn: "Bardeen", nameAr: "بردين"),
      SubCity(slug: "sibaiyyah", nameEn: "El Sibaiyya", nameAr: "السباعية"),
      SubCity(slug: "sawah", nameEn: "El Sawah", nameAr: "الصوة"),
      SubCity(slug: "samla", nameEn: "Samla", nameAr: "سملا"),
      SubCity(slug: "samadun", nameEn: "Samadoun", nameAr: "سمادون"),
      SubCity(slug: "murabian", nameEn: "El Murabieen", nameAr: "المرابعين"),
    ],
  ),
  Governorate(
    slug: "qena",
    nameEn: "Qena",
    nameAr: "قنا",
    subCities: [
      SubCity(slug: "qena", nameEn: "Qena", nameAr: "قنا"),
      SubCity(slug: "qift", nameEn: "Qift", nameAr: "قفط"),
      SubCity(slug: "dishna", nameEn: "Dishna", nameAr: "دشنا"),
      SubCity(slug: "farshut", nameEn: "Farshout", nameAr: "فرشوط"),
      SubCity(
        slug: "nagaa-hammadi",
        nameEn: "Nag Hammadi",
        nameAr: "نجع حمادي",
      ),
      SubCity(slug: "naqidi", nameEn: "El Naqida", nameAr: "النقيدي"),
      SubCity(slug: "qus", nameEn: "Qous", nameAr: "قوص"),
      SubCity(slug: "abo-shousha", nameEn: "Abu Shusha", nameAr: "ابو شوشة"),
      SubCity(slug: "derwah", nameEn: "Darwa", nameAr: "دروة"),
    ],
  ),
  Governorate(
    slug: "luxor",
    nameEn: "Luxor",
    nameAr: "الأقصر",
    subCities: [
      SubCity(slug: "luxor", nameEn: "Luxor", nameAr: "الاقصر"),
      SubCity(slug: "armant", nameEn: "Armant", nameAr: "ارمنت"),
      SubCity(slug: "esna", nameEn: "Esna", nameAr: "اسنا"),
      SubCity(slug: "mahamid", nameEn: "El Mahamid", nameAr: "المحاميد"),
      SubCity(
        slug: "kom-ahmar",
        nameEn: "El Kom El Ahmar",
        nameAr: "الكوم الاحمر",
      ),
    ],
  ),
  Governorate(
    slug: "aswan",
    nameEn: "Aswan",
    nameAr: "أسوان",
    subCities: [
      SubCity(slug: "aswan", nameEn: "Aswan", nameAr: "اسوان"),
      SubCity(slug: "edfu", nameEn: "Edfu", nameAr: "ادفو"),
      SubCity(slug: "kom-ombo", nameEn: "Kom Ombo", nameAr: "كوم امبو"),
      SubCity(slug: "daraw", nameEn: "Daraw", nameAr: "دراو"),
      SubCity(slug: "kalabsha", nameEn: "Kalabsha", nameAr: "كلابشة"),
      SubCity(slug: "ballana", nameEn: "Ballana", nameAr: "بلانة"),
      SubCity(slug: "radisia", nameEn: "El Radisiyya", nameAr: "الرديسية"),
      SubCity(slug: "nasser", nameEn: "Nasser", nameAr: "ناصر"),
      SubCity(slug: "silwa-bahari", nameEn: "Silwa Bahari", nameAr: "سلوا"),
    ],
  ),
  Governorate(
    slug: "red-sea",
    nameEn: "Red Sea",
    nameAr: "البحر الأحمر",
    subCities: [
      SubCity(slug: "hurghada", nameEn: "Hurghada", nameAr: "الغردقة"),
      SubCity(slug: "ras-ghareb", nameEn: "Ras Ghareb", nameAr: "رأس غارب"),
      SubCity(
        slug: "sahl-hasheesh",
        nameEn: "Sahl Hasheesh",
        nameAr: "سهل حشيش",
      ),
    ],
  ),
  Governorate(
    slug: "south-sinai",
    nameEn: "South Sinai",
    nameAr: "جنوب سيناء",
    subCities: [
      SubCity(
        slug: "sharm-el-sheikh",
        nameEn: "Sharm El Sheikh",
        nameAr: "شرم الشيخ",
      ),
      SubCity(slug: "dahab", nameEn: "Dahab", nameAr: "دهب"),
      SubCity(slug: "el-tor", nameEn: "El Tor", nameAr: "الطور"),
    ],
  ),
  Governorate(
    slug: "north-sinai",
    nameEn: "North Sinai",
    nameAr: "شمال سيناء",
    subCities: [
      SubCity(slug: "rowaysat", nameEn: "El Ruwaisat", nameAr: "الرويسات"),
    ],
  ),
  Governorate(
    slug: "new-valley",
    nameEn: "New Valley",
    nameAr: "الوادي الجديد",
    subCities: [
      SubCity(slug: "upper-egypt", nameEn: "Upper Egypt", nameAr: "صعيد مصر"),
    ],
  ),
];
