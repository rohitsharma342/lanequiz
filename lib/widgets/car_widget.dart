import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class CarWidget extends StatefulWidget {
  final CarLane carLane;
  final AnimationController animationController;
  final bool isAnswering;

  const CarWidget({
    super.key,
    required this.carLane,
    required this.animationController,
    this.isAnswering = false,
  });

  @override
  State<CarWidget> createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _bounceController;
  late Animation<double> _moveAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _moveController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.elasticOut,
    ));

    _bounceController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(CarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.carLane != widget.carLane) {
      _moveController.forward().then((_) {
        _moveController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftPosition = screenWidth * 0.25 - AppConstants.carSize / 2;
    final rightPosition = screenWidth * 0.75 - AppConstants.carSize / 2;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_moveAnimation, _bounceAnimation, _scaleAnimation]),
      builder: (context, child) {
        double targetPosition = widget.carLane == CarLane.left ? leftPosition : rightPosition;
        
        return Positioned(
          left: targetPosition,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(0, -5 * _bounceAnimation.value),
              child: Container(
                width: AppConstants.carSize,
                height: AppConstants.carSize,
                decoration: BoxDecoration(
                  color: widget.isAnswering 
                      ? AppConstants.primaryColor.withOpacity(0.7)
                      : AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Car body
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          color: AppConstants.primaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                    // Wheels
                    Positioned(
                      bottom: 2,
                      left: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppConstants.textColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppConstants.textColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Headlights
                    if (widget.isAnswering) ...
                      [
                        Positioned(
                          top: 8,
                          left: 12,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade300,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.6),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 12,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade300,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.6),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}