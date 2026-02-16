import 'package:flutter/material.dart';
import 'dart:async';
import 'data.dart'; // GameData 포함
import 'game_main_screen.dart';
import 'vote_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mystery Game',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const GameMainScreen(),
    );
  }
}

class LocationDetailsScreen extends StatefulWidget {
  final String location; // 현재 위치
  final int searchRound; // 현재 수색 라운드

  const LocationDetailsScreen(
      {Key? key, required this.location, required this.searchRound})
      : super(key: key);

  @override
  _LocationDetailsScreenState createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  int cluesFoundInCurrentRound = 0; // 현재 라운드에서 찾은 단서 수
  Timer? searchTimer; // 제한 시간 타이머
  int secondsRemaining = 60; // 남은 시간 (초 단위)
  Map<int, String?> cluesAssigned = {}; // 각 버튼에 할당된 단서

  static const int maxCluesPerRound = 4; // 라운드당 최대 단서 수

  @override
  void initState() {
    super.initState();
    _startSearchTimer();
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    super.dispose();
  }

  /// 제한 시간 타이머 시작
  void _startSearchTimer() {
    searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        _endSearch("제한 시간이 종료되었습니다.");
      }
    });
  }

  /// 제한 시간 종료 시 처리
  void _endSearch(String message) {
    searchTimer?.cancel();

    if (widget.searchRound == 1) {
      setState(() {
        cluesFoundInCurrentRound = 0;
        secondsRemaining = 60;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameMainScreen(),
          settings: const RouteSettings(arguments: true), // 수색 완료 전달
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const VoteScreen(isTimerExpired: true)),
      );
    }
  }

  /// 위치에 따른 배경 이미지 반환
  String _getLocationImage() {
    switch (widget.location) {
      case "김이현의 작업실":
        return 'lib/assets/studio.png';
      case "황윤서의 거실":
        return 'lib/assets/living_room.png';
      case "신예슬의 연구실":
        return 'lib/assets/lab.png';
      case "김윤복의 사무실":
        return 'lib/assets/office.png';
      case "한규상의 집":
        return 'lib/assets/house.png';
      default:
        return 'lib/assets/default.jpg';
    }
  }

  /// 단서 버튼 생성
  Widget _buildClueButton(int buttonIndex, String label, String clueGroup) {
    return GestureDetector(
      onTap: () {
        if (cluesFoundInCurrentRound < maxCluesPerRound) {
          String? clue;

          if (cluesAssigned.containsKey(buttonIndex)) {
            clue = cluesAssigned[buttonIndex];
          } else {
            clue = GameData.collectClue(widget.location, clueGroup);
            cluesAssigned[buttonIndex] = clue;
          }

          if (clue != null) {
            cluesFoundInCurrentRound++;
            if (cluesFoundInCurrentRound == maxCluesPerRound) {
              _endSearch('1차 수색이 종료되었습니다.');
            }

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.black,
                title: const Text(
                  "발견된 단서",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  clue!,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        const Text("확인", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('이 그룹에 더 이상 단서가 없습니다.'),
                backgroundColor: Colors.grey,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('1차 수색이 종료되었습니다.'),
              backgroundColor: Colors.grey,
            ),
          );
        }
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.redAccent, width: 1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// 각 방에 단서 버튼 배치
  List<Widget> _buildFixedPositionButtons() {
    switch (widget.location) {
      case "김이현의 작업실":
        return [
          Positioned(
              top: 50, left: 650, child: _buildClueButton(1, "선반", "shelf")),
          Positioned(
              bottom: 70, left: 150, child: _buildClueButton(2, "바닥", "floor")),
          Positioned(
              bottom: 100,
              right: 550,
              child: _buildClueButton(3, "쓰레기통", "trash_can")),
          Positioned(
              right: 350, bottom: 50, child: _buildClueButton(4, "책상", "desk")),
          Positioned(
              right: 500, top: 200, child: _buildClueButton(5, "테이블", "tab")),
        ];
      case "황윤서의 거실":
        return [
          Positioned(
              top: 50, left: 650, child: _buildClueButton(1, "선반", "shelf")),
          Positioned(
              bottom: 20,
              right: 500,
              child: _buildClueButton(2, "바닥", "floor")),
          Positioned(
              bottom: 100,
              right: 25,
              child: _buildClueButton(3, "쓰레기통", "trash_can")),
          Positioned(
              right: 550,
              bottom: 250,
              child: _buildClueButton(4, "책상", "desk")),
          Positioned(
              left: 500, bottom: 20, child: _buildClueButton(5, "테이블", "tab")),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.location} (라운드: ${widget.searchRound})"),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
      ),
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getLocationImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "남은 시간: $secondsRemaining초",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ..._buildFixedPositionButtons(),
        ],
      ),
    );
  }
}
