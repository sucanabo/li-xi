import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lixi/model/background_model.dart';
import 'package:lixi/page/setting_page.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:lixi/state_mixin.dart';
import 'package:lixi/widget/lixi.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class LixiItemModel {
  final GlobalKey<LixiState> key;
  final String content;

  const LixiItemModel({required this.key, required this.content});
}

class _MainPageState extends State<MainPage> with AppStateMixin {
  late final AppProvider appProvider;
  PosBackground? posBg;
  final List<int> moneys = [100, 50, 10, 50, 20, 500, 35, 20, 1];
  late final List<LixiItemModel> models;
  bool _isShuffle = false;

  @override
  void initState() {
    super.initState();
    appProvider = context.read<AppProvider>()..initState();
    models = List.generate(moneys.length,
        (index) => LixiItemModel(key: GlobalKey<LixiState>(), content: '${moneys[index]}K'));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        posBg = getPosBackground(
          MediaQuery.of(context).size.width - 32,
          moneys,
        );
      });
    });
  }

  shuffle() {
    closeAll();
    appShuffle(() {
      posBg?.shufflePos();
      setState(() {
        _isShuffle = true;
      });
    });
  }

  closeAll() {
    for (var item in models) {
      final itemState = item.key.currentState!;
      if (itemState.isFlipped == true) {
        itemState.flipCard();
        continue;
      }
    }
  }

  flipAll() {
    for (var item in models) {
      final itemState = item.key.currentState!;
      if (itemState.isFlipped == false) {
        itemState.flipCard();
        continue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<AppProvider>().isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: context.watch<AppProvider>().bgColor,
            bottomNavigationBar: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const SettingPage())),
                    child: Text('Cài đặt'),
                  ),
                  ElevatedButton(
                    onPressed: flipAll,
                    child: Text('Xem hết'),
                  ),
                  ElevatedButton(
                    onPressed: closeAll,
                    child: Text('Úm hết'),
                  ),
                  ElevatedButton(onPressed: shuffle, child: const Text('Trộn')),
                ],
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: posBg == null
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            margin: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Stack(
                                children: [
                                  Container(
                                    width: posBg!.width,
                                    height: posBg!.height,
                                  ),
                                  ...List.generate(moneys.length, (index) {
                                    return AnimatedPositioned(
                                        duration: config.animationDuration,
                                        top: posBg!.pos[index].y,
                                        left: posBg!.pos[index].x,
                                        child: Hero(
                                          tag: models[index].key,
                                          child: Lixi(
                                            key: models[index].key,
                                            margin: 8,
                                            width: posBg!.itemWidth,
                                            height: posBg!.itemHeight,
                                            money: models[index].content,
                                            onSelect: _isShuffle == false
                                                ? null
                                                : () {
                                                    if (models[index].key.currentState!.isFlipped)
                                                      return;
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                            opaque: false,
                                                            barrierDismissible: true,
                                                            barrierColor:
                                                                Colors.black.withOpacity(0.8),
                                                            pageBuilder: (context, _, __) {
                                                              ConfettiController confettiCtr =
                                                                  ConfettiController();
                                                              return Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  vertical: 100,
                                                                  horizontal: 32,
                                                                ),
                                                                child: Stack(
                                                                  alignment: Alignment.topCenter,
                                                                  children: [
                                                                    Align(
                                                                      alignment: Alignment.center,
                                                                      child: Hero(
                                                                        tag: models[index].key,
                                                                        child: Lixi(
                                                                          moneyFontSize: 80,
                                                                          money:
                                                                              models[index].content,
                                                                          onFlipChange: (bool
                                                                              isFlipped) async {
                                                                            if (isFlipped == true) {
                                                                              Navigator.pop(
                                                                                  context);
                                                                              return;
                                                                            }
                                                                            confettiCtr.play();
                                                                            models[index]
                                                                                .key
                                                                                .currentState!
                                                                                .flipCard();
                                                                            await Future.delayed(
                                                                                const Duration(
                                                                                    seconds: 2),
                                                                                () => confettiCtr
                                                                                    .stop());
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ConfettiWidget(
                                                                      confettiController:
                                                                          confettiCtr,
                                                                      blastDirectionality:
                                                                          BlastDirectionality
                                                                              .explosive,
                                                                      numberOfParticles: 50,
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }));
                                                  },
                                          ),
                                        ));
                                  })
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
