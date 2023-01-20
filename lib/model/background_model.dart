import 'dart:math';

class PosItem {
  final int id;
  final double x;
  final double y;
  final int data;

  const PosItem({required this.id, required this.x, required this.y, required this.data});

  PosItem changePos({required double x, required double y}) =>
      PosItem(id: id, x: x, y: y, data: data);

  @override
  String toString() {
    return 'PosItem{x: $x, y: $y, data: $data}';
  }
}

class PosBackground {
  final List<PosItem> pos;
  final double width;
  final double height;
  final double itemWidth;
  final double itemHeight;

  const PosBackground({
    required this.pos,
    required this.height,
    required this.width,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  String toString() {
    return 'PosBackground{pos: $pos, width: $width, height: $height, itemWidth: $itemWidth}';
  }
}

extension PosBgExtension on PosBackground {
  shufflePos() {
    final random = Random();
    int length = pos.length;

    while (length > 1) {
      int posRad = random.nextInt(length);
      length -= 1;
      var tmp = pos[length];
      pos[length] = pos[length].changePos(x: pos[posRad].x, y: pos[posRad].y);
      pos[posRad] = pos[posRad].changePos(x: tmp.x, y: tmp.y);
    }
  }
}
