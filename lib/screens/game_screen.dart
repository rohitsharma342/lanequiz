import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../widgets/car_widget.dart';
import '../widgets/road_widget.dart';
import '../widgets/question_banner.dart';
import '../utils/constants.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _carAnimationController;
  late AnimationController _backgroundController;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startGame();
  }

  void _initializeAnimations() {
    _carAnimationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _backgroundController.repeat();
  }

  void _startGame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameController>().startGame();
    });
  }

  @override
  void dispose() {
    _carAnimationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    final gameController = context.read<GameController>();
    
    if (!gameController.isGameActive || gameController.gameState.isAnswering) {
      return;
    }

    const sensitivity = 100.0;
    final velocity = details.velocity.pixelsPerSecond;

    if (velocity.dx.abs() > velocity.dy.abs()) {
      if (velocity.dx > sensitivity) {
        gameController.moveCarToLane(CarLane.right);
        _carAnimationController.forward().then((_) {
          _carAnimationController.reverse();
        });
        
        Future.delayed(const Duration(milliseconds: 500), () {
          gameController.answerQuestion(false);
        });
      } else if (velocity.dx < -sensitivity) {
        gameController.moveCarToLane(CarLane.left);
        _carAnimationController.forward().then((_) {
          _carAnimationController.reverse();
        });
        
        Future.delayed(const Duration(milliseconds: 500), () {
          gameController.answerQuestion(true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameController>(
        builder: (context, gameController, child) {
          if (gameController.isGameOver) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const GameOverScreen(),
                ),
              );
            });
            return const SizedBox.shrink();
          }

          return GestureDetector(
            onPanEnd: _handleSwipe,
            child: Stack(
              children: [
                RoadWidget(
                  animationController: _backgroundController,
                  currentQuestion: gameController.currentQuestion,
                ),
                
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: QuestionBanner(
                    question: gameController.currentQuestion,
                    questionNumber: gameController.gameState.currentQuestionIndex + 1,
                    totalQuestions: gameController.gameState.totalQuestions,
                  ),
                ),
                
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildScoreDisplay(gameController.gameState.score),
                ),
                
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: CarWidget(
                    carLane: gameController.gameState.carLane,
                    animationController: _carAnimationController,
                    isAnswering: gameController.gameState.isAnswering,
                  ),
                ),
                
                if (gameController.gameState.isAnswering)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreDisplay(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}