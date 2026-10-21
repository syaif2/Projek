import 'package:cryptography/cryptography.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Cryptography.instance = FlutterCryptography();
  try {
    final controller = await AppController.create();
    runApp(VorteksApp(controller: controller));
  } catch (_) {
    runApp(const VorteksStartupErrorApp());
  }
}
