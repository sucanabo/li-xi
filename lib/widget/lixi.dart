import 'dart:math';

import 'package:flutter/material.dart';

class Lixi extends StatefulWidget {
  final double height;
  final double width;
  final String content;
  final bool initFlip;

  const Lixi({
    Key? key,
    required this.content,
    this.initFlip = false,
    this.width = 310,
    this.height = 474,
  }) : super(key: key);

  @override
  State<Lixi> createState() => LixiState();
}

class LixiState extends State<Lixi> {
  late bool isFlipped;
  double angle = 0;

  @override
  void initState() {
    super.initState();
    isFlipped = widget.initFlip;
    print('isFliiped: ${widget.initFlip}');
  }

  flipCard({bool? show}) {
    setState(() {
      angle = (show ?? isFlipped) ? (angle + pi) : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: angle),
        duration: const Duration(milliseconds: 600),
        builder: (context, double val, _) {
          isFlipped = !(val >= pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: isFlipped
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/lixi_back.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/lixi_front.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          widget.content,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 24,
                                color: Colors.white,
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
}
