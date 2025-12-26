import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../utils/constants.dart';
import 'game_screen.dart';
import 'splash_screen.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _restartGame() {
    context.read<GameController>().restartGame();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  void _exitGame() {
    context.read<GameController>().resetGame();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }

  String _getPerformanceMessage(double accuracy) {
    if (accuracy >= 90) return "Outstanding! 🏆";
    if (accuracy >= 75) return "Great job! 🎉";
    if (accuracy >= 60) return "Good effort! 👍";
    if (accuracy >= 40) return "Keep practicing! 💪";
    return "Don't give up! 🚀";
  }

  Color _getScoreColor(double accuracy) {
    if (accuracy >= 75) return AppConstants.correctAnswerColor;
    if (accuracy >= 50) return AppConstants.primaryColor;
    return AppConstants.wrongAnswerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameController>(
        builder: (context, gameController, child) {
          final gameStats = gameController.getGameStats();
          final accuracy = gameStats['accuracy'] as double;
          final score = gameStats['score'] as int;
          final correctAnswers = gameStats['correctAnswers'] as int;
          final totalQuestions = gameStats['totalQuestions'] as int;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppConstants.backgroundColor,
                  AppConstants.primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _getScoreColor(accuracy),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getScoreColor(accuracy).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flag,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          Text(
                            'Game Over!',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppConstants.textColor,
                            ),
                          ),
                          
                          const SizedBox(height: 10),
                          
                          Text(
                            _getPerformanceMessage(accuracy),
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: _getScoreColor(accuracy),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          _buildStatsCard(
                            context,
                            score,
                            correctAnswers,
                            totalQuestions,
                            accuracy,
                          ),
                          
                          const SizedBox(height: 50),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                context,
                                'Play Again',
                                Icons.refresh,
                                AppConstants.primaryColor,
                                _restartGame,
                              ),
                              _buildActionButton(
                                context,
                                'Exit',
                                Icons.home,
                                AppConstants.secondaryTextColor,
                                _exitGame,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    int score,
    int correctAnswers,
    int totalQuestions,
    double accuracy,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppConstants.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppConstants.primaryColor,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Correct',
                '$correctAnswers/$totalQuestions',
                Icons.check_circle,
                AppConstants.correctAnswerColor,
              ),
              _buildStatItem(
                context,
                'Accuracy',
                '${accuracy.toStringAsFixed(1)}%',
                Icons.percent,
                _getScoreColor(accuracy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}