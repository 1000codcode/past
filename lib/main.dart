import 'package:flutter/material.dart';
import 'screens/nickname_screen.dart';
import 'screens/story_screen.dart';
import 'screens/game_main_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/data.dart'; // GameData 포함

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  await GameData.loadRoomClues(); // JSON 단서 데이터 로드
  runApp(const CrimeSceneApp());
}

class CrimeSceneApp extends StatelessWidget {
  const CrimeSceneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crime Scene',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/nickname',
      routes: {
        '/nickname': (context) => const NicknameScreen(),
        '/story': (context) => const StoryScreen(),
        '/game': (context) => const GameMainScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
