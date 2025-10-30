import '../../models/home/home_continue_model.dart';
import '../../models/home/home_flashcard_model.dart';
import '../../models/progress/progress_model.dart';
import '../../models/reading/reading.dart';

class DummyUtil {

  static final List<SkillProgress> progressList = [
    // Beginner
    SkillProgress(skill: 'Listening',
        level: 'beginner',
        completed: 8,
        total: 20,
        percent: 40),
    SkillProgress(skill: 'Reading',
        level: 'beginner',
        completed: 10,
        total: 20,
        percent: 50),
    SkillProgress(skill: 'Speaking',
        level: 'beginner',
        completed: 7,
        total: 20,
        percent: 35),
    SkillProgress(skill: 'Writing',
        level: 'beginner',
        completed: 6,
        total: 20,
        percent: 30),

    // Intermediate
    SkillProgress(skill: 'Listening',
        level: 'intermediate',
        completed: 15,
        total: 20,
        percent: 75),
    SkillProgress(skill: 'Reading',
        level: 'intermediate',
        completed: 14,
        total: 20,
        percent: 70),
    SkillProgress(skill: 'Speaking',
        level: 'intermediate',
        completed: 13,
        total: 20,
        percent: 65),
    SkillProgress(skill: 'Writing',
        level: 'intermediate',
        completed: 12,
        total: 20,
        percent: 60),

    // Advanced
    SkillProgress(skill: 'Listening',
        level: 'advanced',
        completed: 5,
        total: 20,
        percent: 25),
    SkillProgress(skill: 'Reading',
        level: 'advanced',
        completed: 4,
        total: 20,
        percent: 20),
    SkillProgress(skill: 'Speaking',
        level: 'advanced',
        completed: 3,
        total: 20,
        percent: 15),
    SkillProgress(skill: 'Writing',
        level: 'advanced',
        completed: 2,
        total: 20,
        percent: 10),
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

  static final List<String> homeSliderImages = [
    // 'assets/images/animals/bear.jpg',
    // 'assets/images/animals/cat.jpg',
    // 'assets/images/animals/dog.jpg',
    'assets/images/banners/banner2.jpg',
    'assets/images/banners/banner3.jpg',
    'assets/images/banners/banner1.jpg',
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


  //Thời lượng mục tiêu trong ngày (phút)
  static const int targetMinutes = 30;

  //Thời gian đã học hôm nay (mock)
  static int learnedTodayMinutes = 18;
}