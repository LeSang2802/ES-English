import '../../models/home/home_continue_model.dart';
import '../../models/home/home_flashcard_model.dart';
import '../../models/level/level_model.dart';
import '../../models/progress/progress_model.dart';
import '../../models/reading/reading.dart';
import '../../models/skill/skill_model.dart';
import '../../models/vocabulary/flash_card/flash_card_model.dart';
import '../../models/vocabulary/saved_word/saved_word_model.dart';
import '../../models/vocabulary/vocabulary_model.dart';

class DummyUtil {
  static List<FlashCardModel> flashCards = [
    FlashCardModel(
      id: "1",
      en: "Dog",
      vi: "Con chó",
      type: "n",
      imageUrl: "assets/images/animals/dog.jpg",
      audioUrl: "assets/audio/animals/dog.mp3",
    ),
    FlashCardModel(
      id: "2",
      en: "Cat",
      vi: "Con mèo",
      type: "n",
      imageUrl: "assets/images/animals/cat.jpg",
      audioUrl: "assets/audio/animals/cat.mp3",
    ),
    FlashCardModel(
      id: "3",
      en: "Elephant",
      vi: "Con voi",
      type: "n",
      imageUrl: "assets/images/animals/elephant.jpg",
      audioUrl: "assets/audio/animals/elephant.mp3",
    ),
    FlashCardModel(
      id: "4",
      en: "Giraffe",
      vi: "Con hươu cao cổ",
      type: "n",
      imageUrl: "assets/images/animals/giraffe.jpg",
      audioUrl: "assets/audio/animals/giraffe.mp3",
    ),
    FlashCardModel(
      id: "5",
      en: "Tiger",
      vi: "Con hổ",
      type: "n",
      imageUrl: "assets/images/animals/tiger.jpg",
      audioUrl: "assets/audio/animals/tiger.mp3",
    ),
    FlashCardModel(
      id: "6",
      en: "Monkey",
      vi: "Con khỉ",
      type: "n",
      imageUrl: "assets/images/animals/monkey.jpg",
      audioUrl: "assets/audio/animals/monkey.mp3",
    ),
    FlashCardModel(
      id: "7",
      en: "Horse",
      vi: "Con ngựa",
      type: "n",
      imageUrl: "assets/images/animals/horse.jpg",
      audioUrl: "assets/audio/animals/horse.mp3",
    ),
    FlashCardModel(
      id: "8",
      en: "Rabbit",
      vi: "Con thỏ",
      type: "n",
      imageUrl: "assets/images/animals/rabbit.jpg",
      audioUrl: "assets/audio/animals/rabbit.mp3",
    ),
    FlashCardModel(
      id: "9",
      en: "Bear",
      vi: "Con gấu",
      type: "n",
      imageUrl: "assets/images/animals/bear.jpg",
      audioUrl: "assets/audio/animals/bear.mp3",
    ),
    FlashCardModel(
      id: "10",
      en: "Fox",
      vi: "Con cáo",
      type: "n",
      imageUrl: "assets/images/animals/fox.jpg",
      audioUrl: "assets/audio/animals/fox.mp3",
    ),
  ];

  // static List<FlashCardModel> flashCards = [
  //   FlashCardModel(
  //     id: "1",
  //     en: "Dog",
  //     vi: "Con chó",
  //     type: "n",
  //     imageUrl: "assets/images/animals/dog.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/dog--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "2",
  //     en: "Cat",
  //     vi: "Con mèo",
  //     type: "n",
  //     imageUrl: "assets/images/animals/cat.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/cat--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "3",
  //     en: "Elephant",
  //     vi: "Con voi",
  //     type: "n",
  //     imageUrl: "assets/images/animals/elephant.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/elephant--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "4",
  //     en: "Giraffe",
  //     vi: "Con hươu cao cổ",
  //     type: "n",
  //     imageUrl: "assets/images/animals/giraffe.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/giraffe--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "5",
  //     en: "Tiger",
  //     vi: "Con hổ",
  //     type: "n",
  //     imageUrl: "assets/images/animals/tiger.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/tiger--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "6",
  //     en: "Monkey",
  //     vi: "Con khỉ",
  //     type: "n",
  //     imageUrl: "assets/images/animals/monkey.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/monkey--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "7",
  //     en: "Horse",
  //     vi: "Con ngựa",
  //     type: "n",
  //     imageUrl: "assets/images/animals/horse.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/horse--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "8",
  //     en: "Rabbit",
  //     vi: "Con thỏ",
  //     type: "n",
  //     imageUrl: "assets/images/animals/rabbit.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/rabbit--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "9",
  //     en: "Bear",
  //     vi: "Con gấu",
  //     type: "n",
  //     imageUrl: "assets/images/animals/bear.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/bear--_us_1.mp3",
  //   ),
  //   FlashCardModel(
  //     id: "10",
  //     en: "Fox",
  //     vi: "Con cáo",
  //     type: "n",
  //     imageUrl: "assets/images/animals/fox.jpg",
  //     audioUrl: "https://ssl.gstatic.com/dictionary/static/sounds/oxford/fox--_us_1.mp3",
  //   ),
  // ];




  static List<Vocabulary> vocabulariesList = [
    Vocabulary(
      id: "1",
      name: "Con vật",
      imageUrl: "assets/images/dog.jpg",
    ),
    Vocabulary(
      id: "2",
      name: "Đồ vật",
      imageUrl: null,
    ),
    Vocabulary(
      id: "3",
      name: "Phương tiện giao thông",
      imageUrl: null,
    ),
    Vocabulary(
      id: "4",
      name: "Công nghệ",
      imageUrl: null,
    ),
  ];

  static final List<SkillProgress> progressList = [
    // Beginner
    SkillProgress(skill: 'Listening', level: 'beginner', completed: 8, total: 20, percent: 40),
    SkillProgress(skill: 'Reading', level: 'beginner', completed: 10, total: 20, percent: 50),
    SkillProgress(skill: 'Speaking', level: 'beginner', completed: 7, total: 20, percent: 35),
    SkillProgress(skill: 'Writing', level: 'beginner', completed: 6, total: 20, percent: 30),

    // Intermediate
    SkillProgress(skill: 'Listening', level: 'intermediate', completed: 15, total: 20, percent: 75),
    SkillProgress(skill: 'Reading', level: 'intermediate', completed: 14, total: 20, percent: 70),
    SkillProgress(skill: 'Speaking', level: 'intermediate', completed: 13, total: 20, percent: 65),
    SkillProgress(skill: 'Writing', level: 'intermediate', completed: 12, total: 20, percent: 60),

    // Advanced
    SkillProgress(skill: 'Listening', level: 'advanced', completed: 5, total: 20, percent: 25),
    SkillProgress(skill: 'Reading', level: 'advanced', completed: 4, total: 20, percent: 20),
    SkillProgress(skill: 'Speaking', level: 'advanced', completed: 3, total: 20, percent: 15),
    SkillProgress(skill: 'Writing', level: 'advanced', completed: 2, total: 20, percent: 10),
  ];
  static List<Passage> passages = [
    Passage(
      id: "1",
      title: "My Pet Dog",
      content:
          "I have a pet dog named Max. He is very playful and loves to run in the park every morning. Max is brown and has big ears. He barks loudly when he sees strangers but is gentle with children.",
      questions: [
        Question(
          id: "q1",
          text: "What is the name of the dog?",
          options: [
            Option(text: "Buddy", isCorrect: false),
            Option(text: "Max", isCorrect: true),
            Option(text: "Rex", isCorrect: false),
            Option(text: "Spot", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
        Question(
          id: "q2",
          text: "What does Max love to do every morning?",
          options: [
            Option(text: "Sleep", isCorrect: false),
            Option(text: "Eat", isCorrect: false),
            Option(text: "Run in the park", isCorrect: true),
            Option(text: "Bark at birds", isCorrect: false),
          ],
          correctOptionIndex: 2,
        ),
        Question(
          id: "q3",
          text: "How is Max with children?",
          options: [
            Option(text: "Scary", isCorrect: false),
            Option(text: "Gentle", isCorrect: true),
            Option(text: "Lazy", isCorrect: false),
            Option(text: "Noisy", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Passage(
      id: "2",
      title: "A Day at the Beach",
      content:
          "Last weekend, Anna and her family went to the beach. They swam in the sea, built sandcastles, and had a picnic. The weather was sunny, but it became windy in the afternoon. Anna enjoyed collecting shells and watching seagulls fly overhead.",
      questions: [
        Question(
          id: "q4",
          text: "What did Anna and her family do at the beach?",
          options: [
            Option(text: "Played soccer", isCorrect: false),
            Option(text: "Built sandcastles", isCorrect: true),
            Option(text: "Went hiking", isCorrect: false),
            Option(text: "Flew kites", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
        Question(
          id: "q5",
          text: "What was the weather like in the afternoon?",
          options: [
            Option(text: "Rainy", isCorrect: false),
            Option(text: "Sunny", isCorrect: false),
            Option(text: "Windy", isCorrect: true),
            Option(text: "Cloudy", isCorrect: false),
          ],
          correctOptionIndex: 2,
        ),
        Question(
          id: "q6",
          text: "What did Anna enjoy collecting?",
          options: [
            Option(text: "Rocks", isCorrect: false),
            Option(text: "Shells", isCorrect: true),
            Option(text: "Leaves", isCorrect: false),
            Option(text: "Feathers", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Passage(
      id: "3",
      title: "The Library Visit",
      content:
          "Tom visited the library to borrow books. He found a book about space exploration that excited him. The library was quiet, and Tom spent two hours reading. He also attended a storytelling session for kids.",
      questions: [
        Question(
          id: "q7",
          text: "Why did Tom visit the library?",
          options: [
            Option(text: "To meet friends", isCorrect: false),
            Option(text: "To borrow books", isCorrect: true),
            Option(text: "To watch a movie", isCorrect: false),
            Option(text: "To play games", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
        Question(
          id: "q8",
          text: "What kind of book did Tom find?",
          options: [
            Option(text: "A mystery novel", isCorrect: false),
            Option(text: "A book about space exploration", isCorrect: true),
            Option(text: "A cookbook", isCorrect: false),
            Option(text: "A history book", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Passage(
      id: "4",
      title: "The City Park",
      content:
          "The city park is a popular place for families. There are tall trees, a small pond with ducks, and a playground. Every Sunday, people gather for a community picnic. Last week, a music band played near the pond, attracting many visitors.",
      questions: [
        Question(
          id: "q9",
          text: "What can be found in the city park?",
          options: [
            Option(text: "A zoo", isCorrect: false),
            Option(text: "A small pond with ducks", isCorrect: true),
            Option(text: "A movie theater", isCorrect: false),
            Option(text: "A shopping mall", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
        Question(
          id: "q10",
          text: "What happens every Sunday in the park?",
          options: [
            Option(text: "A sports tournament", isCorrect: false),
            Option(text: "A community picnic", isCorrect: true),
            Option(text: "A book fair", isCorrect: false),
            Option(text: "A dance competition", isCorrect: false),
          ],
          correctOptionIndex: 1,
        ),
        Question(
          id: "q11",
          text: "What attracted many visitors last week?",
          options: [
            Option(text: "A magic show", isCorrect: false),
            Option(text: "A food festival", isCorrect: false),
            Option(text: "A music band", isCorrect: true),
            Option(text: "A pet show", isCorrect: false),
          ],
          correctOptionIndex: 2,
        ),
      ],
    ),
  ];

  static final List<Level> Levels = [
    Level(
      id: "1",
      title: "Beginner",
      description: "Dành cho người mới bắt đầu",
    ),
    Level(
      id: "2",
      title: "Intermediate",
      description: "Trình độ trung cấp",
    ),
    Level(
      id: "3",
      title: "Advanced",
      description: "Nâng cao",
    ),
  ];

  static final List<SavedWordModel> savedWords = [
    SavedWordModel(id: "1", en: "Friend", vi: "Bạn bè", type: "(n)"),
    SavedWordModel(id: "2", en: "Developer", vi: "Nhà phát triển", type: "(n)"),
    SavedWordModel(id: "3", en: "Run", vi: "Chạy", type: "(v)"),
    SavedWordModel(id: "4", en: "Seminar", vi: "Hội thảo", type: "(n)"),
    SavedWordModel(id: "5", en: "Miss", vi: "Cô / nhớ", type: "(n)/(v)"),
    SavedWordModel(id: "6", en: "Tester", vi: "Người thử nghiệm", type: "(n)"),
    SavedWordModel(id: "7", en: "Software", vi: "Phần mềm", type: "(n)"),
  ];

  static final List<Skill> skills = [
    Skill(id: "1", name: "Listening", icon: "ear", progress: 0.75),
    Skill(id: "2", name: "Speaking", icon: "mic", progress: 0.45),
    Skill(id: "3", name: "Reading", icon: "book", progress: 0.60),
    Skill(id: "4", name: "Writing", icon: "pencil", progress: 0.40),
    Skill(id: "5", name: "Vocabulary", icon: "cards", progress: 0.80),
    Skill(id: "6", name: "Test", icon: "clipboard", progress: 0.25),
  ];

  static final List<String> homeSliderImages = [
    'assets/images/animals/bear.jpg',
    'assets/images/animals/cat.jpg',
    'assets/images/animals/dog.jpg',
  ];

  /// Continue Study (mock – chọn 1 bản ghi đang học dở)
  static final HomeContinue continueStudy = HomeContinue(
    skillId: 'reading',
    skillName: 'Reading',
    levelId: 'beginner',
    levelName: 'Beginner',
    percent: 80,
  );

  /// Flashcard block
  static final HomeFlashcardSuggestion flashcard = HomeFlashcardSuggestion(
    id: 'vocab_daily',
    title: 'Study vocabulary with FlashCard',
    subtitle: '20 new words everyday',
    // icon: 'assets/images/animals/tiger.jpg',
  );




  /// Thời lượng mục tiêu trong ngày (phút)
  static const int targetMinutes = 30;

  /// Thời gian đã học hôm nay (mock)
  static int learnedTodayMinutes = 18;

  /// Tên user
  static const String userName = 'Long';
}
