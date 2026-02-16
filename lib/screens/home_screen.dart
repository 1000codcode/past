import 'package:flutter/material.dart';
import 'story_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nickname;

  const HomeScreen({Key? key, required this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 크기 정보
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600; // 600px 기준으로 모바일 여부 판단

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crime Scene',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              nickname[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: _buttonStyle(screenSize),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryScreen(),
                      ),
                    );
                  },
                  child: const Text('게임 시작'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(Size screenSize) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: screenSize.width < 600 ? 20 : 40,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: TextStyle(
        fontSize: screenSize.width < 600 ? 16 : 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
