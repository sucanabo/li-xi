import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lixi/model/background_model.dart';
import 'package:lixi/state_mixin.dart';
import 'package:lixi/widget/lixi.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with AppStateMixin {
  final List<int> moneys = [100, 50, 10, 50, 20, 500, 35, 20, 1];
  PosBackground? posBg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        posBg = getPosBackground(
          MediaQuery.of(context).size.width - 32,
          moneys,
        );
      });
    });
  }

  PosBackground getPosBackground(
    double width,
    List<int> data, {
    int columnCount = 3,
    double itemHeight = 250,
  }) {
    final itemCount = data.length;
    final double itemWidth = width / columnCount;
    final double height = (itemCount ~/ columnCount + itemCount % columnCount) * itemHeight;
    int rowCount = 0;
    final List<PosItem> pos = List.generate(itemCount, (index) {
      if (index != 0 && index % columnCount == 0) {
        rowCount++;
      }
      return PosItem(
        id: index,
        x: (index % columnCount) * itemWidth,
        y: rowCount * itemHeight,
        data: data[index],
      );
    });
    return PosBackground(
        pos: pos, height: height, width: width, itemWidth: itemWidth, itemHeight: itemHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: shuffle(shuffleFunc: posBg?.shufflePos()),
        child: const Icon(Icons.shuffle),
      ),
      body: posBg == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: posBg!.width,
                      height: posBg!.height,
                      color: Colors.white,
                    ),
                    ...List.generate(moneys.length, (index) {
                      return AnimatedPositioned(
                          duration: config.animationDuration,
                          top: posBg!.pos[index].y,
                          left: posBg!.pos[index].x,
                          child: Container(
                            child: Lixi(
                              margin: 8,
                              width: posBg!.itemWidth,
                              height: posBg!.itemHeight,
                              content: '${posBg!.pos[index].data} K',
                              onSelect: () {},
                            ),
                          ));
                    })
                  ],
                ),
              ),
            ),
    );
  }
}
