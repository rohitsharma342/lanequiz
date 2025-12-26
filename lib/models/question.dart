class Question {
  final String question;
  final String leftOption;
  final String rightOption;
  final bool isLeftCorrect;
  final String category;
  final int difficulty;

  Question({
    required this.question,
    required this.leftOption,
    required this.rightOption,
    required this.isLeftCorrect,
    required this.category,
    this.difficulty = 1,
  });

  String get correctAnswer => isLeftCorrect ? leftOption : rightOption;
  String get wrongAnswer => isLeftCorrect ? rightOption : leftOption;

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'leftOption': leftOption,
      'rightOption': rightOption,
      'isLeftCorrect': isLeftCorrect,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      leftOption: json['leftOption'],
      rightOption: json['rightOption'],
      isLeftCorrect: json['isLeftCorrect'],
      category: json['category'],
      difficulty: json['difficulty'] ?? 1,
    );
  }
}