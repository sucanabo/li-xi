import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/app_provider.dart';

class EnterLixiDialog extends StatefulWidget {
  const EnterLixiDialog({Key? key}) : super(key: key);

  @override
  State<EnterLixiDialog> createState() => _EnterLixiDialogState();
}

class _EnterLixiDialogState extends State<EnterLixiDialog> {
  final formKey = GlobalKey<FormState>();
  final txt = TextEditingController();
  List<int> data = [];
  Map<int, int> dataWithQuantity = {};

  Map<int, int> getDataWithQuantity() {
    final Map<int, int> result = {};
    final List<int> sortData = data..sort();
    for (var it in sortData) {
      if (result.containsKey(it)) {
        result[it] = (result[it] ?? 0) + 1;
        continue;
      }
      result[it] = 1;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    data = List.of(context.read<AppProvider>().lixiData);
    dataWithQuantity = getDataWithQuantity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nhập lì xì'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Lì xì hiện có:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                )),
            Wrap(
              children: List.generate(
                dataWithQuantity.length,
                (index) => Text.rich(
                  TextSpan(
                    text: '${dataWithQuantity.keys.toList()[index]}K',
                    style: const TextStyle(color: Colors.blue),
                    children: [
                      TextSpan(
                        text:
                            ' (x${dataWithQuantity.values.toList()[index]})${index == dataWithQuantity.length - 1 ? '' : ', '}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Bơm thêm tiền:'),
            Form(
              key: formKey,
              child: TextFormField(
                controller: txt,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Nhập xiềngg',
                  suffixText: 'K',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final int numberVal = int.parse(val);
                  if (numberVal > 500) return '500K lơn nhất rồi bạn ơi';
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() && txt.text.isNotEmpty) {
                    setState(() {
                      data.add(int.parse(txt.text));
                      dataWithQuantity = getDataWithQuantity();
                    });
                  }
                },
                child: Text('Thêm'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && txt.text.isNotEmpty) {
                  setState(() {
                    data.remove(int.parse(txt.text));
                    dataWithQuantity = getDataWithQuantity();
                  });
                }
              },
              child: Text('Xóa'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.clear();
                              dataWithQuantity = getDataWithQuantity();
                            });
                          },
                          child: Text('Xóa hết'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            context.read<AppProvider>().setLixiData(data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Lưu lì xì thành công')));
                          },
                          child: Text('Lưu'))),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            )
          ],
        ),
      ),
    );
  }
}
