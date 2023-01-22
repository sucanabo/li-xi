import 'package:flutter/material.dart';
import 'package:lixi/const/value.dart';
import 'package:lixi/page/setting_page.dart';
import 'package:lixi/provider/app_provider.dart';
import 'package:provider/provider.dart';

class ChangeLixiThemeDialog extends StatefulWidget {
  const ChangeLixiThemeDialog({Key? key}) : super(key: key);

  @override
  State<ChangeLixiThemeDialog> createState() => _ChangeLixiThemeDialogState();
}

class _ChangeLixiThemeDialogState extends State<ChangeLixiThemeDialog> with SettingStateMixin {
  late final _provider = context.read<AppProvider>();
  late final ImageType _frontType;
  late final ImageType _backType;
  late final String _frontPath;
  late final String _backPath;

  @override
  void initState() {
    super.initState();
    _frontType = _provider.lixiFrontType;
    _backType = _provider.lixiBackType;
    _frontPath = _provider.lixiImgFrontPath;
    _backPath = _provider.lixiImgBackPath;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Đổi nền lì xì:',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.blueAccent,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Mặt trước'),
                      SizedBox(height: 12),
                      buildLixiTheme(_frontType, _frontPath, height: 200)
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text('Mặt sau'),
                      SizedBox(height: 12),
                      buildLixiTheme(_backType, _backPath, height: 200),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
