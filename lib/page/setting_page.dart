import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lixi/const/value.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:lixi/widget/enter_lixi_dialog.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with SettingStateMixin {
  late final AppProvider _providerRead = context.read<AppProvider>();
  late final AppProvider _providerWatch = context.watch<AppProvider>();

  _changeBg() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn màu nền'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: context.watch<AppProvider>().bgColor,
            onColorChanged: (color) => _providerRead.changeColorTheme(color),
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

  _changeLixiTheme({required bool isFront, required ImageType type}) async {
    ImageType? type = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Chọn loại ảnh'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      title: Text('Nhập từ thư viện', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () => Navigator.pop(context, ImageType.file)),
                  ListTile(
                      title: Text('Nhập link (ảnh mạng)', style: TextStyle(color: Colors.green)),
                      onTap: () => Navigator.pop(context, ImageType.network)),
                  ListTile(
                    title: Text('Khôi phục (mặc định)', style: TextStyle(color: Colors.deepOrange)),
                    onTap: () {
                      _providerRead.setLixiThemeDefault(isFront: isFront);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
    final String? path;
    switch (type) {
      case ImageType.file:
        path = await _pickFile();
        break;
      case ImageType.network:
        path = await _enterUrl();
        break;
      default:
        path = null;
    }
    if (path != null) {
      context.read<AppProvider>().setLixiTheme(
            frontType: isFront ? type : null,
            frontPath: isFront ? path : null,
            backType: !isFront ? type : null,
            backPath: !isFront ? path : null,
          );
    }
  }

  Future<String?> _pickFile() async {
    final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    return file?.path;
  }

  Future<String?> _enterUrl() async {
    final formKey = GlobalKey<FormState>();
    final txt = TextEditingController();
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Nhập Url ảnh:'),
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: txt,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) =>
                        !Uri.parse(val ?? '').hasAbsolutePath ? 'Vui lòng nhập đúng Url' : null,
                  ),
                ),
              ),
              actions: [
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, txt.text);
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ));
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
              buildRowData('Nhập lì xì:',
                  onTap: _enterLixi, editWidget: SizedBox(child: const Icon(Icons.edit))),
              buildRowData(
                'Màu nền:',
                onTap: _changeBg,
                editWidget: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: context.watch<AppProvider>().bgColor,
                  ),
                ),
              ),
              buildRowData(
                'Nền lì xì: (Trước - sau)',
                editWidget: Row(children: [
                  GestureDetector(
                    onTap: () => _changeLixiTheme(isFront: true, type: _providerRead.lixiFrontType),
                    child: buildLixiTheme(
                      _providerWatch.lixiFrontType,
                      _providerWatch.lixiImgFrontPath,
                      width: 50,
                      height: 100,
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _changeLixiTheme(isFront: false, type: _providerRead.lixiBackType),
                    child: buildLixiTheme(
                        _providerWatch.lixiBackType, _providerWatch.lixiImgBackPath,
                        width: 50, height: 100),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin SettingStateMixin<T extends StatefulWidget> on State<T> {
  Widget buildLixiTheme(ImageType type, String path,
      {double height = 250, double width = 150, BoxFit fit = BoxFit.cover}) {
    switch (type) {
      case ImageType.assets:
        return Image.asset(
          path,
          height: height,
          width: width,
          fit: fit,
        );
      case ImageType.file:
        return Image.file(
          File(path),
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, _, __) => Text('Ảnh bị lỗi (không có trong thiết bị)'),
        );
      case ImageType.network:
        return Image.network(
          path,
          fit: fit,
          height: height,
          width: width,
          errorBuilder: (context, _, __) => Text('Ảnh bị lỗi(đường dẫn không hợp lệ)'),
        );
    }
  }

  Widget buildRowData(String title, {Widget? editWidget, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            if (editWidget != null) editWidget,
          ],
        ),
      ),
    );
  }
}
