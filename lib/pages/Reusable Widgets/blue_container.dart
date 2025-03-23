import 'package:flutter/material.dart';
import 'dart:async';

class BlueContainer extends StatefulWidget {
  final String title;
  final int delayMilliseconds;

  const BlueContainer({
    super.key,
    required this.title,
    required this.delayMilliseconds,
  });

  @override
  State<BlueContainer> createState() => _BlueContainerState();
}

class _BlueContainerState extends State<BlueContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Right to left
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 93, 152, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(widget.title, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
