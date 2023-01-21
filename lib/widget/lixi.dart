import 'dart:math';

import 'package:flutter/material.dart';

class Lixi extends StatefulWidget {
  final double height;
  final double width;
  final String money;
  final bool initFlip;
  final double margin;
  final double moneyFontSize;
  final Function()? onSelect;
  final Function(bool isFlip)? onFlipChange;

  const Lixi({
    Key? key,
    required this.money,
    this.onSelect,
    this.onFlipChange,
    this.initFlip = false,
    this.width = 310,
    this.height = 474,
    this.moneyFontSize = 24,
    this.margin = 0,
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
  }

  flipCard({bool? show}) {
    setState(() {
      angle = (show ?? isFlipped) ? 0 : (angle + pi);
    });
    widget.onFlipChange?.call(isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect ?? flipCard,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: angle),
        duration: const Duration(milliseconds: 700),
        builder: (context, double val, _) {
          isFlipped = val >= pi / 2;
          print('lixiFlip: $isFlipped');
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: isFlipped
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Container(
                        alignment: Alignment.topCenter + const Alignment(0, 0.65),
                        margin: EdgeInsets.all(widget.margin),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/lixi_front.jpeg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Text(
                          widget.money,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: widget.moneyFontSize,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(widget.margin),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/lixi_back.jpeg'),
                          fit: BoxFit.fill,
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
