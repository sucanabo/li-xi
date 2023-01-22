import 'dart:async';

import 'package:flutter/material.dart';

class DebounceButton extends StatefulWidget {
  final String text;
  final bool isDebounce;
  final VoidCallback? onPressed;
  final Duration? debounceTime;

  const DebounceButton(
      {Key? key, required this.text, this.onPressed, this.isDebounce = false, this.debounceTime})
      : super(key: key);

  @override
  State<DebounceButton> createState() => _DebounceButtonState();
}

class _DebounceButtonState extends State<DebounceButton> {
  late final _debounceTime;
  late ValueNotifier<bool> _isEnable;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _debounceTime = widget.debounceTime ?? Duration(milliseconds: 700);
    _isEnable = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isEnable,
        builder: (context, isEnable, _) {
          return ElevatedButton(
            onPressed: isEnable ? _buttonPressed : null,
            child: Text(widget.text),
          );
        });
  }

  _buttonPressed() {
    _isEnable.value = false;
    widget.onPressed?.call();
    _timer = Timer(_debounceTime, () => _isEnable.value = true);
  }
}
