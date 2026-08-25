// ============================================================
// lib/data/lesson_data.dart
// Little Scholars – Sample lessons for all 6 subjects
// ============================================================
import '../models/app_models.dart';

import 'package:flutter/material.dart';

// ============== SUBJECTS DEFINITION ==============
const List<SubjectModel> kSubjects = [
  SubjectModel(
    id: 'math',
    nameEn: 'Math',
    nameUr: 'حساب',
    emoji: '🔢',
    color: Color(0xFF3B82F6),
    lightColor: Color(0xFFDBEAFE),
  ),
  SubjectModel(
    id: 'english',
    nameEn: 'English',
    nameUr: 'انگریزی',
    emoji: '📖',
    color: Color(0xFF22C55E),
    lightColor: Color(0xFFDCFCE7),
  ),
  SubjectModel(
    id: 'urdu',
    nameEn: 'Urdu',
    nameUr: 'اردو',
    emoji: '📝',
    color: Color(0xFFEC4899),
    lightColor: Color(0xFFFCE7F3),
  ),
  SubjectModel(
    id: 'science',
    nameEn: 'Science',
    nameUr: 'سائنس',
    emoji: '🔬',
    color: Color(0xFF7C3AED),
    lightColor: Color(0xFFEDE9FE),
  ),
  SubjectModel(
    id: 'islamiyat',
    nameEn: 'Islamiyat',
    nameUr: 'اسلامیات',
    emoji: '☪️',
    color: Color(0xFF14B8A6),
    lightColor: Color(0xFFCCFBF1),
  ),
  SubjectModel(
    id: 'gk',
    nameEn: 'General Knowledge',
    nameUr: 'عمومی معلومات',
    emoji: '🌍',
    color: Color(0xFFF97316),
    lightColor: Color(0xFFFFEDD5),
  ),
];

// ============== LESSONS PER SUBJECT ==============
const Map<String, List<LessonModel>> kLessons = {
  'math': [
    LessonModel(
      id: 'math_1',
      titleEn: 'Numbers 1 to 10',
      titleUr: '1 سے 10 تک گنتی',
      contentEn:
          '1️⃣ One  2️⃣ Two  3️⃣ Three  4️⃣ Four  5️⃣ Five\n\n6️⃣ Six  7️⃣ Seven  8️⃣ Eight  9️⃣ Nine  🔟 Ten\n\nCount everything you see! 🌟\nOne apple 🍎, two bananas 🍌, three stars ⭐⭐⭐',
      contentUr:
          '1️⃣ ایک  2️⃣ دو  3️⃣ تین  4️⃣ چار  5️⃣ پانچ\n\n6️⃣ چھ  7️⃣ سات  8️⃣ آٹھ  9️⃣ نو  🔟 دس\n\nآپ کے ارد گرد جو چیزیں ہیں انہیں گنیں! 🌟\nایک سیب 🍎، دو کیلے 🍌، تین ستارے ⭐⭐⭐',
    ),
    LessonModel(
      id: 'math_2',
      titleEn: 'Simple Addition',
      titleUr: 'آسان جمع',
      contentEn:
          '➕ Addition means putting things together!\n\n🍎 + 🍎 = 2 apples\n2 + 3 = 5\n4 + 1 = 5\n5 + 5 = 10\n\nTip: Use your fingers to count! 🤚',
      contentUr:
          '➕ جمع کا مطلب ہے چیزیں اکٹھی کرنا!\n\n🍎 + 🍎 = 2 سیب\n2 + 3 = 5\n4 + 1 = 5\n5 + 5 = 10\n\nمشورہ: انگلیوں سے گنیں! 🤚',
    ),
    LessonModel(
      id: 'math_3',
      titleEn: 'Shapes Around Us',
      titleUr: 'ہمارے ارد گرد اشکال',
      contentEn:
          '🔵 Circle – Round like the sun ☀️\n🟥 Square – 4 equal sides like a window 🪟\n🔺 Triangle – 3 sides like a pizza slice 🍕\n🟩 Rectangle – like a door 🚪\n\nFind shapes in your house!',
      contentUr:
          '🔵 دائرہ – سورج کی طرح گول ☀️\n🟥 مربع – کھڑکی کی طرح 4 برابر اطراف 🪟\n🔺 مثلث – پیزے کی قاش کی طرح 3 اطراف 🍕\n🟩 مستطیل – دروازے جیسا 🚪\n\nاپنے گھر میں اشکال تلاش کریں!',
    ),
  ],
  'english': [
    LessonModel(
      id: 'eng_1',
      titleEn: 'The Alphabet A-Z',
      titleUr: 'حروف تہجی A-Z',
      contentEn:
          '🔤 A B C D E F G\nH I J K L M N\nO P Q R S T U\nV W X Y Z\n\n🍎 A is for Apple\n🐝 B is for Bee\n🐱 C is for Cat\n🐶 D is for Dog\n🐘 E is for Elephant',
      contentUr:
          '🔤 A B C D E F G\nH I J K L M N\nO P Q R S T U\nV W X Y Z\n\n🍎 A سیب کے لیے\n🐝 B شہد کی مکھی کے لیے\n🐱 C بلی کے لیے\n🐶 D کتے کے لیے\n🐘 E ہاتھی کے لیے',
    ),
    LessonModel(
      id: 'eng_2',
      titleEn: 'My Body Parts',
      titleUr: 'میرے جسم کے اعضاء',
      contentEn:
          '👁️ Eyes – I see with my eyes\n👂 Ears – I hear with my ears\n👃 Nose – I smell with my nose\n👄 Mouth – I eat and speak with my mouth\n🖐️ Hands – I write and play with my hands\n🦶 Feet – I walk with my feet',
      contentUr:
          '👁️ آنکھیں – میں آنکھوں سے دیکھتا/دیکھتی ہوں\n👂 کان – میں کانوں سے سنتا/سنتی ہوں\n👃 ناک – میں ناک سے سونگھتا/سونگھتی ہوں\n👄 منہ – میں منہ سے کھاتا/کھاتی اور بولتا/بولتی ہوں\n🖐️ ہاتھ – میں ہاتھوں سے لکھتا/لکھتی اور کھیلتا/کھیلتی ہوں\n🦶 پاؤں – میں پاؤں سے چلتا/چلتی ہوں',
    ),
    LessonModel(
      id: 'eng_3',
      titleEn: 'Colors of the Rainbow',
      titleUr: 'قوس قزح کے رنگ',
      contentEn:
          '🌈 The rainbow has 7 colors!\n\n🔴 Red  🟠 Orange  🟡 Yellow\n🟢 Green  🔵 Blue  🟣 Indigo  🟣 Violet\n\nRemember: ROY G BIV\n\n☀️ Red is the color of an apple\n🌊 Blue is the color of the sea',
      contentUr:
          '🌈 قوس قزح میں 7 رنگ ہیں!\n\n🔴 سرخ  🟠 نارنجی  🟡 پیلا\n🟢 سبز  🔵 نیلا  🟣 بنفشی  🟣 آسمانی\n\n☀️ سرخ سیب کا رنگ ہے\n🌊 نیلا سمندر کا رنگ ہے',
    ),
  ],
  'urdu': [
    LessonModel(
      id: 'urdu_1',
      titleEn: 'Urdu Alphabet – Alif Ba',
      titleUr: 'اردو حروف تہجی – الف باء',
      contentEn:
          'Urdu has 38 letters!\n\nا – Alif  ب – Bay  پ – Pay\nت – Tay  ٹ – Ttay  ث – Say\nج – Jeem  چ – Chay  ح – Hay\n\nStart with Alif:\nالف – آم (Mango 🥭)\nب – بکری (Goat 🐐)\nپ – پھول (Flower 🌸)',
      contentUr:
          'اردو میں 38 حروف ہیں!\n\nا – الف  ب – باء  پ – پاء\nت – تاء  ٹ – ٹاء  ث – ثاء\nج – جیم  چ – چاء  ح – حاء\n\nالف سے شروع کریں:\nالف – آم 🥭\nب – بکری 🐐\nپ – پھول 🌸',
    ),
    LessonModel(
      id: 'urdu_2',
      titleEn: 'My Family – Mera Khandan',
      titleUr: 'میرا خاندان',
      contentEn:
          '👨 Abbu – Father\n👩 Ammi – Mother\n👦 Bhai – Brother\n👧 Bahen – Sister\n👴 Dada/Nana – Grandfather\n👵 Dadi/Nani – Grandmother\n\nFamily is everything! ❤️',
      contentUr:
          '👨 ابو – باپ\n👩 امی – ماں\n👦 بھائی – بھائی\n👧 بہن – بہن\n👴 دادا/نانا – دادا\n👵 دادی/نانی – دادی\n\nخاندان سب سے اہم ہے! ❤️',
    ),
  ],
  'science': [
    LessonModel(
      id: 'sci_1',
      titleEn: 'Plants Around Us',
      titleUr: 'ہمارے ارد گرد پودے',
      contentEn:
          '🌱 Plants are living things!\n\nParts of a Plant:\n🌿 Roots – Take water from soil\n🌿 Stem – Carries water to leaves\n🍃 Leaves – Make food using sunlight\n🌸 Flower – Makes seeds\n🍎 Fruit – Grows from flowers\n\n☀️ + 💧 + 🌱 = 🌳 A big tree!',
      contentUr:
          '🌱 پودے زندہ چیزیں ہیں!\n\nپودے کے حصے:\n🌿 جڑیں – مٹی سے پانی لیتی ہیں\n🌿 تنا – پانی پتوں تک پہنچاتا ہے\n🍃 پتے – سورج کی روشنی سے خوراک بناتے ہیں\n🌸 پھول – بیج بناتا ہے\n🍎 پھل – پھول سے اگتا ہے\n\n☀️ + 💧 + 🌱 = 🌳 ایک بڑا درخت!',
    ),
    LessonModel(
      id: 'sci_2',
      titleEn: 'Animals – Wild & Domestic',
      titleUr: 'جانور – جنگلی اور پالتو',
      contentEn:
          '🏠 Domestic Animals (live with us):\n🐄 Cow – gives milk\n🐔 Hen – lays eggs\n🐕 Dog – guards the house\n🐑 Sheep – gives wool\n\n🌳 Wild Animals (live in jungle):\n🦁 Lion – King of jungle\n🐘 Elephant – largest land animal\n🦒 Giraffe – tallest animal',
      contentUr:
          '🏠 پالتو جانور (ہمارے ساتھ رہتے ہیں):\n🐄 گائے – دودھ دیتی ہے\n🐔 مرغی – انڈے دیتی ہے\n🐕 کتا – گھر کی حفاظت کرتا ہے\n🐑 بھیڑ – اون دیتی ہے\n\n🌳 جنگلی جانور (جنگل میں رہتے ہیں):\n🦁 شیر – جنگل کا بادشاہ\n🐘 ہاتھی – سب سے بڑا زمینی جانور\n🦒 زرافہ – سب سے لمبا جانور',
    ),
  ],
  'islamiyat': [
    LessonModel(
      id: 'islam_1',
      titleEn: 'Bismillah & Kalima',
      titleUr: 'بسم اللہ اور کلمہ',
      contentEn:
          '🕌 We say Bismillah before starting any good work:\n\nبِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ\n"In the name of Allah, the Most Gracious, the Most Merciful"\n\n☪️ The First Kalima:\nلَا إِلٰهَ إِلَّا اللهُ مُحَمَّدٌ رَّسُولُ اللهِ\n"There is no god but Allah, Muhammad ﷺ is the Messenger of Allah"',
      contentUr:
          '🕌 ہم ہر اچھے کام سے پہلے بسم اللہ پڑھتے ہیں:\n\nبِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ\n"اللہ کے نام سے شروع جو بڑا مہربان نہایت رحم والا ہے"\n\n☪️ پہلا کلمہ:\nلَا إِلٰهَ إِلَّا اللهُ مُحَمَّدٌ رَّسُولُ اللهِ\n"اللہ کے سوا کوئی معبود نہیں، محمد ﷺ اللہ کے رسول ہیں"',
    ),
    LessonModel(
      id: 'islam_2',
      titleEn: 'Five Pillars of Islam',
      titleUr: 'اسلام کے پانچ ارکان',
      contentEn:
          '🕌 The Five Pillars of Islam:\n\n1️⃣ Kalima – Declaration of Faith (کلمہ)\n2️⃣ Salah – Prayer 5 times a day (نماز)\n3️⃣ Zakat – Giving to the poor (زکوٰۃ)\n4️⃣ Sawm – Fasting in Ramadan (روزہ)\n5️⃣ Hajj – Pilgrimage to Makkah (حج)',
      contentUr:
          '🕌 اسلام کے پانچ ارکان:\n\n1️⃣ کلمہ – ایمان کا اقرار\n2️⃣ نماز – دن میں 5 مرتبہ\n3️⃣ زکوٰۃ – غریبوں کو دینا\n4️⃣ روزہ – رمضان میں\n5️⃣ حج – مکہ کا سفر',
    ),
  ],
  'gk': [
    LessonModel(
      id: 'gk_1',
      titleEn: 'My Country Pakistan 🇵🇰',
      titleUr: 'میرا ملک پاکستان 🇵🇰',
      contentEn:
          '🇵🇰 Pakistan was created on August 14, 1947\n\n🏛️ Capital: Islamabad\n🌊 Largest City: Karachi\n📜 National Language: Urdu\n💚 National Color: Green & White\n🦅 National Bird: Markhor? No — Shaheen (Falcon) 🦅\n🌹 National Flower: Jasmine\n🌲 National Tree: Deodar\n\n❤️ Pakistan Zindabad!',
      contentUr:
          '🇵🇰 پاکستان 14 اگست 1947 کو بنا\n\n🏛️ دارالحکومت: اسلام آباد\n🌊 سب سے بڑا شہر: کراچی\n📜 قومی زبان: اردو\n💚 قومی رنگ: سبز اور سفید\n🦅 قومی پرندہ: شاہین\n🌹 قومی پھول: چنبیلی\n🌲 قومی درخت: دیودار\n\n❤️ پاکستان زندہ باد!',
    ),
    LessonModel(
      id: 'gk_2',
      titleEn: 'The Solar System ☀️',
      titleUr: 'نظام شمسی ☀️',
      contentEn:
          '☀️ Our Sun is a star!\nThere are 8 planets:\n\n1. Mercury 2. Venus 3. Earth 🌍\n4. Mars 5. Jupiter 6. Saturn 🪐\n7. Uranus 8. Neptune\n\n🌍 We live on Earth!\n🌙 Earth has one Moon.',
      contentUr:
          '☀️ ہمارا سورج ایک ستارہ ہے!\n8 سیارے ہیں:\n\n1. عطارد 2. زہرہ 3. زمین 🌍\n4. مریخ 5. مشتری 6. زحل 🪐\n7. یورینس 8. نیپچون\n\n🌍 ہم زمین پر رہتے ہیں!\n🌙 زمین کا ایک چاند ہے۔',
    ),
  ],
};

