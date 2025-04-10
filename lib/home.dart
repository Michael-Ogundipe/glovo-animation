import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'blob.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Center of the circular path - initialize with a default value
  Offset center = Offset.zero;

  // Radius of the circular path
  double radius = 116;

  // Current angles of the circles in radians
  double angle1 = 0;
  double angle2 = pi / 2;
  double angle3 = pi;
  double angle4 = pi / 2 + pi;

  // The initial angle difference between circles (90 degrees or pi/2 radians)
  final double angleDifference = pi / 2;

  // Track which circle is being dragged
  int? draggedCircleIndex;

  // Previous angle during drag for calculating direction
  double? previousDragAngle;

  // Flag to check if layout is ready
  bool isLayoutReady = false;

  @override
  Widget build(BuildContext context) {
    if (!isLayoutReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          center = Offset(MediaQuery.of(context).size.width / 2.3,
              MediaQuery.of(context).size.height / 3);
          isLayoutReady = true;
        });
      });
    }

    return Scaffold(
      backgroundColor: const Color(0XFFF6C13B),
      appBar: AppBar(
        backgroundColor: const Color(0XFFF6C13B),
        title: Text(
          'Glovo Animation',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: center.dx - 20,
            top: center.dy - 25,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Blob(
                color: Colors.white,
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/job.svg', width: 80),
                  ],
                ),
              ),
            ),
          ),
          if (isLayoutReady) ...[
            _buildDraggableCircle(
                0, angle1, Colors.red, 'Food', 'assets/food.svg'),
            _buildDraggableCircle(
                1, angle2, Colors.blue, 'Shops', 'assets/shops.svg'),
            _buildDraggableCircle(
                2, angle3, Colors.yellow, 'Delivery', 'assets/delivery.svg'),
            _buildDraggableCircle(
                3, angle4, Colors.green, 'Groceries', 'assets/groceries.svg'),
          ] else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildDraggableCircle(
    int index,
    double angle,
    Color color,
    String title,
    String asset,
  ) {
    // Calculate position on the circle
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    return Positioned(
      left: x - 25,
      top: y - 25,
      child: GestureDetector(
        onPanStart: (details) {
          startDrag(index, details);
        },
        onPanUpdate: (details) {
          updateDrag(details);
        },
        onPanEnd: (_) {
          endDrag();
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: Blob(
            color: Colors.white,
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(asset, width: 52),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 16))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startDrag(int index, DragStartDetails details) {
    setState(() {
      draggedCircleIndex = index;

      // Calculate the angle of the tap relative to the center
      final touchPosition = details.globalPosition;
      previousDragAngle = atan2(
        touchPosition.dy - center.dy,
        touchPosition.dx - center.dx,
      );
    });
  }

  void updateDrag(DragUpdateDetails details) {
    if (draggedCircleIndex == null || previousDragAngle == null) return;

    final touchPosition = details.globalPosition;
    final currentAngle = atan2(
      touchPosition.dy - center.dy,
      touchPosition.dx - center.dx,
    );

    // Calculate the angle change (delta)
    var angleDelta = currentAngle - previousDragAngle!;

    // Handle angle wrap-around
    if (angleDelta > pi) {
      angleDelta -= 2 * pi;
    } else if (angleDelta < -pi) {
      angleDelta += 2 * pi;
    }

    setState(() {
      switch (draggedCircleIndex) {
        case 0: // First circle dragged
          angle1 = (angle1 + angleDelta) % (2 * pi);
          angle2 = (angle1 + angleDifference) % (2 * pi);
          angle3 = (angle2 + angleDifference) % (2 * pi);
          angle4 = (angle3 + angleDifference) % (2 * pi);
          break;

        case 1: // Second circle dragged
          angle2 = (angle2 + angleDelta) % (2 * pi);
          angle1 = (angle2 - angleDifference) % (2 * pi);
          angle3 = (angle2 + angleDifference) % (2 * pi);
          angle4 = (angle3 + angleDifference) % (2 * pi);
          break;

        case 2: // Third circle dragged
          angle3 = (angle3 + angleDelta) % (2 * pi);
          angle2 = (angle3 - angleDifference) % (2 * pi);
          angle1 = (angle2 - angleDifference) % (2 * pi);
          angle4 = (angle3 + angleDifference) % (2 * pi);
          break;

        case 3: // Fourth circle dragged
          angle4 = (angle4 + angleDelta) % (2 * pi);
          angle3 = (angle4 - angleDifference) % (2 * pi);
          angle2 = (angle3 - angleDifference) % (2 * pi);
          angle1 = (angle2 - angleDifference) % (2 * pi);
          break;
      }

      // Ensure all angles are positive
      angle1 = angle1 < 0 ? angle1 + 2 * pi : angle1;
      angle2 = angle2 < 0 ? angle2 + 2 * pi : angle2;
      angle3 = angle3 < 0 ? angle3 + 2 * pi : angle3;
      angle4 = angle4 < 0 ? angle4 + 2 * pi : angle4;
    });
  }

  void endDrag() {
    setState(() {
      draggedCircleIndex = null;
      previousDragAngle = null;
    });
  }
}
