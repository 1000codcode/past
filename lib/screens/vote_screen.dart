import 'package:flutter/material.dart';
import '../widgets/chat_popup.dart';
import 'data.dart';
import 'package:crime_scene/screens/result_screen.dart';
import 'dart:async'; // 타이머를 위한 import

class VoteScreen extends StatefulWidget {
  final bool isTimerExpired; // 타이머 종료 여부 플래그

  const VoteScreen({Key? key, required this.isTimerExpired}) : super(key: key);

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  String? selectedSuspect = GameData.votedSuspect;
  Timer? _timer; // 타이머 객체
  int _remainingTime = 60; // 제한 시간 1분 (초 단위)

  @override
  void initState() {
    super.initState();
    if (widget.isTimerExpired) {
      _startTimer(); // 타이머 시작
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 화면 종료 시 타이머 해제
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--; // 제한 시간 감소
        } else {
          timer.cancel(); // 타이머 종료
          _onTimeExpired(); // 제한 시간 초과 시 동작
        }
      });
    });
  }

  void _onTimeExpired() {
    // 제한 시간 초과 시 수행할 동작
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('제한 시간이 초과되었습니다.'),
        backgroundColor: Colors.red,
      ),
    );

    // 예: 채팅 팝업 닫기 또는 화면 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(selectedSuspect: selectedSuspect ?? "None"),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /*기존 코드
  void _submitVote() {
    if (selectedSuspect != null) {
      GameData.castVote(selectedSuspect!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedSuspect!} 에게 투표했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('투표할 용의자를 선택해주세요.'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }
   */

  void _submitVote() {
    if (selectedSuspect != null) {
      GameData.castVote(selectedSuspect!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedSuspect!} 에게 투표했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      // Navigate to ResultScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(selectedSuspect: selectedSuspect!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('투표할 용의자를 선택해주세요.'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // isTimerExpired가 true일 경우 뒤로 가기 방지
        if (widget.isTimerExpired) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            '투표하기',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                // 채팅창 팝업 호출
                showDialog(
                  context: context,
                  builder: (context) => const ChatPopup(), // ChatPopup 통합
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  _formatTime(_remainingTime), // 제한 시간 표시
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: GameData.suspects.map((suspect) {
                    final isVoted = suspect == GameData.votedSuspect;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ListTile(
                        title: Text(
                          suspect,
                          style: TextStyle(
                            color: isVoted ? Colors.red : Colors.white,
                            fontWeight:
                            isVoted ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        leading: Radio<String>(
                          value: suspect,
                          groupValue: selectedSuspect,
                          activeColor: Colors.redAccent,
                          onChanged: (value) {
                            setState(() {
                              selectedSuspect = value;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _submitVote,
                  child: const Text('투표 완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
