import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/constants.dart';

class RoadWidget extends StatelessWidget {
  final AnimationController animationController;
  final Question? currentQuestion;

  const RoadWidget({
    super.key,
    required this.animationController,
    this.currentQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade100,
                Colors.green.shade50,
              ],
            ),
          ),
        ),
        
        // Clouds
        ...List.generate(3, (index) => _buildCloud(
          context,
          left: (index * screenSize.width / 3) + (animationController.value * 50),
          top: 30 + (index * 20).toDouble(),
          size: 60 + (index * 10).toDouble(),
        )),
        
        // Road base
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: AppConstants.roadHeight,
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.roadColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
          ),
        ),
        
        // Road lanes
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: AppConstants.roadHeight,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: RoadPainter(
                  animationValue: animationController.value,
                  screenWidth: screenSize.width,
                ),
                size: Size(screenSize.width, AppConstants.roadHeight),
              );
            },
          ),
        ),
        
        // Lane options
        if (currentQuestion != null) ...
          [
            _buildLaneOption(
              context,
              currentQuestion!.leftOption,
              isLeft: true,
              screenWidth: screenSize.width,
            ),
            _buildLaneOption(
              context,
              currentQuestion!.rightOption,
              isLeft: false,
              screenWidth: screenSize.width,
            ),
          ],
      ],
    );
  }

  Widget _buildCloud(BuildContext context, {
    required double left,
    required double top,
    required double size,
  }) {
    return Positioned(
      left: left % MediaQuery.of(context).size.width,
      top: top,
      child: Container(
        width: size,
        height: size * 0.6,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(size * 0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaneOption(
    BuildContext context,
    String option,
    {
    required bool isLeft,
    required double screenWidth,
  }) {
    final laneCenter = isLeft ? screenWidth * 0.25 : screenWidth * 0.75;
    
    return Positioned(
      bottom: AppConstants.roadHeight - 80,
      left: laneCenter - 80,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: AppConstants.primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          option,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppConstants.textColor,
          ),
        ),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  final double animationValue;
  final double screenWidth;

  RoadPainter({
    required this.animationValue,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.laneLineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = AppConstants.laneLineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Center line (dashed)
    final centerX = size.width / 2;
    final dashHeight = 20.0;
    final dashSpacing = 15.0;
    final totalDashPattern = dashHeight + dashSpacing;
    final offset = (animationValue * totalDashPattern * 2) % totalDashPattern;

    for (double y = -offset; y < size.height + dashHeight; y += totalDashPattern) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + dashHeight),
        dashedPaint,
      );
    }

    // Side lines
    canvas.drawLine(
      Offset(screenWidth * 0.05, 0),
      Offset(screenWidth * 0.05, size.height),
      paint,
    );
    
    canvas.drawLine(
      Offset(screenWidth * 0.95, 0),
      Offset(screenWidth * 0.95, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(RoadPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}