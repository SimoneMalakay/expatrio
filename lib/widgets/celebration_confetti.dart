import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CelebrationConfetti extends StatefulWidget {
  final Widget child;
  const CelebrationConfetti({super.key, required this.child});

  @override
  State<CelebrationConfetti> createState() => CelebrationConfettiState();
}

class CelebrationConfettiState extends State<CelebrationConfetti> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void blast() {
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ],
    );
  }
}
