import 'package:flutter/material.dart';
import 'view/tela_inicial.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as uhtml;

// Yeah I'm using it. Sue me
import 'dart:js' as js;

Future<void> loadMockDB(String jsonFilePath) async {
  print("LOAD DB");
  final jsonString = await rootBundle.loadString(jsonFilePath);
  final jsonData = json.decode(jsonString);
  uhtml.window.localStorage['mockDB'] = json.encode(jsonData);
}

Future<void> saveMockDB(String jsonFilePath) async {
  print("SAVE DB");
  final dataValue = uhtml.window.localStorage['mockDB'];
  final jsonData = json.decode(dataValue!);
  jsonData['hmm'] = 'test';
  final jsonString = json.encode(jsonData);
  final bytes = utf8.encode(jsonString);
  final blob = uhtml.Blob([bytes]);
  final url = uhtml.Url.createObjectUrlFromBlob(blob);
  final anchor = uhtml.document.createElement('a') as uhtml.AnchorElement;
  anchor.href = url;
  anchor.download = jsonFilePath;
  anchor.click();
  uhtml.Url.revokeObjectUrl(url);
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  void _beforeUnloadHandler() {
    saveMockDB('lib/assets/mockDB.json');
  }

  @override
  void initState() {
    super.initState();
    js.context['beforeUnload'] = _beforeUnloadHandler;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaInicial(),
    );
  }
}
class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainAppState();
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String mockDBPath = 'lib/assets/mockDB.json';

  loadMockDB(mockDBPath).then((_) {
    runApp(MainApp());
  });
}
