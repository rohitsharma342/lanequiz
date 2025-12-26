import '../models/question.dart';

class DataService {
  static List<Question> getQuestions() {
    return [
      Question(
        question: "What is the capital of France?",
        leftOption: "Paris",
        rightOption: "London",
        isLeftCorrect: true,
        category: "Geography",
        difficulty: 1,
      ),
      Question(
        question: "What is 2 + 2?",
        leftOption: "3",
        rightOption: "4",
        isLeftCorrect: false,
        category: "Mathematics",
        difficulty: 1,
      ),
      Question(
        question: "Which planet is closest to the Sun?",
        leftOption: "Venus",
        rightOption: "Mercury",
        isLeftCorrect: false,
        category: "Science",
        difficulty: 2,
      ),
      Question(
        question: "Who wrote Romeo and Juliet?",
        leftOption: "Shakespeare",
        rightOption: "Dickens",
        isLeftCorrect: true,
        category: "Literature",
        difficulty: 2,
      ),
      Question(
        question: "What is the largest ocean?",
        leftOption: "Atlantic",
        rightOption: "Pacific",
        isLeftCorrect: false,
        category: "Geography",
        difficulty: 1,
      ),
      Question(
        question: "What is the chemical symbol for gold?",
        leftOption: "Au",
        rightOption: "Ag",
        isLeftCorrect: true,
        category: "Science",
        difficulty: 3,
      ),
      Question(
        question: "In which year did World War II end?",
        leftOption: "1944",
        rightOption: "1945",
        isLeftCorrect: false,
        category: "History",
        difficulty: 2,
      ),
      Question(
        question: "What is the square root of 64?",
        leftOption: "8",
        rightOption: "6",
        isLeftCorrect: true,
        category: "Mathematics",
        difficulty: 2,
      ),
      Question(
        question: "Which country is known as the Land of the Rising Sun?",
        leftOption: "China",
        rightOption: "Japan",
        isLeftCorrect: false,
        category: "Geography",
        difficulty: 1,
      ),
      Question(
        question: "What is the fastest land animal?",
        leftOption: "Cheetah",
        rightOption: "Lion",
        isLeftCorrect: true,
        category: "Biology",
        difficulty: 1,
      ),
      Question(
        question: "Which element has the atomic number 1?",
        leftOption: "Helium",
        rightOption: "Hydrogen",
        isLeftCorrect: false,
        category: "Science",
        difficulty: 3,
      ),
      Question(
        question: "Who painted the Mona Lisa?",
        leftOption: "Da Vinci",
        rightOption: "Picasso",
        isLeftCorrect: true,
        category: "Art",
        difficulty: 2,
      ),
      Question(
        question: "What is the tallest mountain in the world?",
        leftOption: "K2",
        rightOption: "Everest",
        isLeftCorrect: false,
        category: "Geography",
        difficulty: 1,
      ),
      Question(
        question: "How many sides does a triangle have?",
        leftOption: "3",
        rightOption: "4",
        isLeftCorrect: true,
        category: "Mathematics",
        difficulty: 1,
      ),
      Question(
        question: "Which gas do plants absorb from the atmosphere?",
        leftOption: "Oxygen",
        rightOption: "Carbon Dioxide",
        isLeftCorrect: false,
        category: "Biology",
        difficulty: 2,
      ),
    ];
  }

  static List<Question> getRandomQuestions({int count = 10}) {
    final allQuestions = getQuestions();
    allQuestions.shuffle();
    return allQuestions.take(count).toList();
  }

  static List<Question> getQuestionsByCategory(String category) {
    return getQuestions().where((q) => q.category == category).toList();
  }

  static List<Question> getQuestionsByDifficulty(int difficulty) {
    return getQuestions().where((q) => q.difficulty == difficulty).toList();
  }
}