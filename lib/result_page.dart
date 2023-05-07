import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;

class ResultPage extends StatefulWidget {
  
  final String ResultPageText;
  const ResultPage({Key? key, required this.ResultPageText}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.ResultPageText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type or paste your text here...',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _copyToClipboard,
                  child: Text('Copy to Clipboard'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _saveToFile,
                  child: Text('Download as TXT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textEditingController.text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Text copied to clipboard!'),
    ));
  }

  Future<void> _saveToFile() async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/ResultPageText.txt');

    await file.writeAsString(_textEditingController.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Text saved to file!'),
      action: SnackBarAction(
        label: 'Open',
        onPressed: () {
          _openFile(file);
        },
      ),
    ));
  }

  Future<void> _openFile(File file) async {
    final text = await file.readAsString();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultPage(ResultPageText: text),
      ),
    );
  }
}
