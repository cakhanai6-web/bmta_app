import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'views/main_scaffold.dart';

void main() async {
  // Flutter 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: avoid_print
    print('✅ BMTA: Firebase 연동 성공!');
  } catch (e) {
    // ignore: avoid_print
    print('❌ BMTA: Firebase 연동 실패 - $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMTA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MainScaffold(),
    );
  }
}
