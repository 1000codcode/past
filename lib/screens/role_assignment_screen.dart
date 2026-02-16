import 'package:flutter/material.dart';
import 'game_main_screen.dart';
import 'data.dart';

class RoleAssignmentScreen extends StatelessWidget {
  final Map<String, dynamic> playerRole = GameData.getRandomRole();

  RoleAssignmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('당신의 역할', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 역할에 따라 이미지 추가
              if (playerRole["role"] == GameData.detectiveRole)
                Image.asset(
                  'lib/assets/detect.png', // 탐정 이미지
                  height: 200,
                  width: 200,
                )
              else
                Image.asset(
                  'lib/assets/crime.png', // 용의자 이미지
                  height: 200,
                  width: 200,
                ),
              const SizedBox(height: 20),
              Text(
                '당신은 ${playerRole["role"]} 입니다.',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),
              if (playerRole["alibi"] != null)
                Text(
                  '알리바이: ${playerRole["alibi"]}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  '탐정은 알리바이가 필요 없습니다.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameMainScreen()),
                  );
                },
                child: const Text(
                  '게임 시작',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
