enum OccupationEnum {
  ACCOUNTANT(28, "Accountant", "হিসাবরক্ষক"),
  ARCHITECT(29, "Architect", "স্থপতি"),
  BANKER(30, "Banker", "ব্যাংকার"),
  LAWYER(31, "Lawyer", "আইনজীবী"),
  BUSINESSMAN(32, "Businessman", "ব্যবসায়ী"),
  CARPENTER(33, "Carpenter", "কারিগর"),
  CLEANER(34, "Cleaner", "পরিষ্কারক"),
  CHEF(35, "Chef", "রান্নার দারুন"),
  RICKSHAW_PULLER(36, "Rickshaw Puller", "রিকশা চালক"),
  DOCTOR(37, "Doctor", "ডাক্তার"),
  DRIVER(38, "Driver", "ড্রাইভার"),
  DRIVING_HELPER(39, "Driving Helper", "ড্রাইভিং সাহায্যকারী"),
  ELECTRICIAN(40, "Electrician", "ইলেকট্রিশিয়ান"),
  VILLAGE_DOCTOR(41, "Village Doctor", "গ্রামের ডাক্তার"),
  NURSE(42, "Nurse/Midwife/Paramedics/Health assistant/SACMO",
      "নার্স/মিডওয়াইফ/প্যারামেডিক/স্বাস্থ্য সহায়ক/SACMO"),
  ENGINEER(43, "Engineer", "প্রকৌশলী"),
  FARMER(44, "Farmer", "কৃষক"),
  TENANT_FARMER(45, "Tenant farmers", "মামলাদার"),
  FISHERMAN(46, "Fisherman/Boatman", "মাছের দরোয়ান/নৌকায়ন"),
  GARMENTS_WORKER(47, "Garments worker", "গার্মেন্টস শ্রমিক"),
  JEWELER(48, "Jeweler", "জুয়েলার"),
  BARBER(49, "Barber", "বার্বার"),
  HOME_MAID(50, "Home Maid", "গৃহিণী"),
  HOUSEWIFE(51, "Housewife", "গৃহিণী"),
  JOURNALIST(52, "Journalist", "সাংবাদিক"),
  INVIGILATOR(53, "Invigilator", "পরিদর্শক"),
  AGRICULTURALIST(54, "Agriculturalist", "কৃষিবিদ"),
  EXECUTIVE(55, "Executive/Manager/Officer", "কার্যনির্বাহী/ব্যবস্থাপক/অফিসার"),
  WASHERMAN(56, "Washerman", "ধোপা"),
  MANAGER(57, "Manager", "ম্যানেজার"),
  PARAMEDIC(58, "Paramedic", "প্যারামেডিক"),
  MERCHANDISER(59, "Merchandiser", "মার্চেন্ডাইজার"),
  OPERATOR(60, "Operator", "মিস্ত্রি"),
  POLICE(61, "Police", "পুলিশ"),
  STUDENT(62, "Student", "ছাএ/ছাএী"),
  PRIEST(63, "Priest (Imam/Purohit)", "ধর্মজীবী (ইমাম/ব্রহ্মচারী)"),
  RETIRED(64, "Retired", "অবসরপ্রাপ্ত"),
  WATCHMAN(65, "Watchman", "চৌকিদার"),
  DAY_LABOURER(66, "Day Labourer", "দিনমজুর"),
  FOREIGNER(67, "Foreigner", "প্রবাসী"),
  POTTER(68, "Potter", "কামার/কুমার"),
  MECHANIC(69, "Mechanic", "যন্ত্রবিৎ"),
  HOLY_MAN(70, "Holy man/Shaman", "পীর/ফকির/ওঝা"),
  KOVIRAJ(71, "Koviraj", "কবিরাজ"),
  TEACHER(72, "Teacher", "শিক্ষক"),
  ENGRAVER(73, "Engraver", "খোদাইকর"),
  LABOUR(74, "Labour", "শ্রমিক"),
  AYURVEDIC_DOCTOR(
      75, "Ayurvedic/Homoeopathic Doctor", "আয়ুর্বেদিক/হোমিওপ্যাথ ডাক্তার"),
  POULTRY_WORKER(76, "Poultry/Fish/Nursery/Dairy Firm Worker",
      "পোলট্রি/ফিশারী/নার্সারী/ডেইরিখামার কর্মী"),
  UNEMPLOYED(77, "Unemployed", "বেকার"),
  VETERINARIAN(78, "Veterinarian", "গোবৈদ্য/পশু ডাক্তার"),
  TAILOR(79, "Tailor", "দর্জি"),
  WEAVERS(80, "Weavers", "তাতী"),
  JUTE_WORKERS(81, "Jute Workers", "পাঁট শ্রমিক"),
  SMALL_BUSINESS(82, "Small Business", "রছোট ব্যাবসা"),
  BIG_BUSINESS(83, "Big Business/Industrialist", "বড় ব্যবসা/শিল্পপতি"),
  JEWELRY_BUSINESS(84, "Jewelry Business", "গহনা ব্যবসা"),
  HAWKER(85, "Hawker", "হকার/ ছোট ব্যাবসা"),
  DEED_WRITER(86, "Deed-writer", "দলিল লেখক"),
  CONDUCTOR(87, "Conductor/Supplier", "ঠিকাদার/সরবরাহকারি"),
  BEGGAR(88, "Beggar", "ভিক্ষুক"),
  ADVOCATE(89, "Advocate", "এ্যাডভোকেট"),
  RESTAURANT_BUSINESS(90, "Restaurant Business", "রেস্টরেন্ট ব্যবসা"),
  AGED_PEOPLE(91, "Aged People/Disability", "অক্ষম/বার্ধক্যজনিত"),
  OTHER_SKILLED_WORKERS(92, "Other Skilled Workers", "অন্যান্য দক্ষ কর্মী"),
  OTHER_UNSKILLED_WORKERS(
      93, "Other UnSkilled Workers", "অন্যান্য অদক্ষ কর্মী");

  const OccupationEnum(this.id, this.labelEn, this.labelBn);

  final int id;
  final String labelEn;
  final String labelBn;

  // Method to get OccupationEnum by id
  static OccupationEnum getById(int id) {
    return OccupationEnum.values.firstWhere(
      (profession) => profession.id == id,
      orElse: () =>
          OccupationEnum.OTHER_UNSKILLED_WORKERS, // Default if not found
    );
  }

  // Method to get OccupationEnum by label (English or Bengali)
  static OccupationEnum getByLabel(String label) {
    return OccupationEnum.values.firstWhere(
      (profession) =>
          profession.labelEn == label || profession.labelBn == label,
      orElse: () =>
          OccupationEnum.OTHER_UNSKILLED_WORKERS, // Default if not found
    );
  }

  // Method to validate OccupationEnum by id
  static bool validate(int id) {
    return OccupationEnum.values.any((profession) => profession.id == id);
  }
}
