import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:lixi/widget/enter_lixi_dialog.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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

  _enterLixi() {
    showDialog(
      context: context,
      builder: (context) => Provider.value(value: context, child: const EnterLixiDialog()),
    );
  }

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
              _buildRowData('Nhập:',
                  editWidget: InkWell(onTap: _enterLixi, child: const Icon(Icons.edit))),
              _buildRowData(
                'Màu nền:',
                editWidget: GestureDetector(
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
              ),
              // _buildRowData('Nền lì xì (trước):',
              //     editWidget: GestureDetector(
              //       onTap: _changeLixiImg(true),
              //       child: context.watch<AppProvider>().isLixiFontNetwork?  Image.network('src') : Image.,
              //     )),
              // _buildRowData('Nền lì xì (sau):')
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowData(String title, {Widget? editWidget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          if (editWidget != null) editWidget,
        ],
      ),
    );
  }
}
