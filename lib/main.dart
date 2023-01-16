import 'package:flutter/material.dart';
import 'package:lixi/widget/lixi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MainPage(),
      ),
    );
  }
}

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

class _MainPageState extends State<MainPage> {
  final List<int> moneys = [100, 50, 10, 50, 20, 500, 35, 20, 1];
  late final List<LixiItemModel> models;

  bool _isFlippedAll = false;
  bool _isShuffle = false;

  @override
  void initState() {
    super.initState();
    models = List.generate(moneys.length,
        (index) => LixiItemModel(key: GlobalKey<LixiState>(), content: '${moneys[index]}K'));
  }

  shuffle() {
    setState(() {
      _isShuffle = true;
    });
  }

  closeAll() {
    for (var item in models) {
      final lixiItem = item.key.currentState;
      if (lixiItem!.isFlipped == _isFlippedAll) {
        continue;
      }
      lixiItem.flipCard();
    }
    setState(() {
      _isFlippedAll = false;
    });
  }

  flipAll() {
    for (var item in models) {
      final lixiItem = item.key.currentState;
      if (lixiItem!.isFlipped == _isFlippedAll) {
        continue;
      }
      lixiItem.flipCard();
    }
    setState(() {
      _isFlippedAll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffc2b3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _isFlippedAll ? closeAll : flipAll,
                  child: Text('${_isFlippedAll ? 'Úm hết' : 'Xem hết'}'),
                ),
                ElevatedButton(onPressed: shuffle, child: Text('Trộn')),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                itemCount: moneys.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // mainAxisExtent: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => Lixi(
                  key: models[index].key,
                  content: models[index].content,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
