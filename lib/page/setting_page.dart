import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Màu nền: ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: _changeBg,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: context.watch<AppProvider>().bgColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _changeBg() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: context.watch<AppProvider>().bgColor,
            onColorChanged: (color) => context.read<AppProvider>().changeColorTheme(color),
          ),
        ),
      ),
    );
  }
}
