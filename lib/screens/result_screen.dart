import 'dart:math';
import 'package:flutter/material.dart';
import 'data.dart';

class ResultScreen extends StatelessWidget {
  final String selectedSuspect; // 투표된 용의자

  const ResultScreen({Key? key, required this.selectedSuspect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 실제 범인 랜덤 선택
    final String actualCulprit =
        GameData.suspects[Random().nextInt(GameData.suspects.length)];
    final bool isCorrect = selectedSuspect == actualCulprit;

    // 결과 메시지
    String resultMessage = '';

    if (actualCulprit == "신예슬") {
      resultMessage = "신예슬은 계획적으로 복어 독의 위험성에 대해 파악한 뒤, "
          "자신이 키우던 복어를 페이퍼 나이프로 죽인 뒤, 그 독을 추출하여 피해자에게 주입했다. "
          "하지만, 김이현은 주입당하는 순간 반항하며, 그녀를 잡아챘고 몸싸움 과정에서 플라스크가 떨어졌다. "
          "그의 목을 졸라 그가 죽을 때까지 더 이상의 몸부림을 막았다. 이후, 깨진 플라스크들을 보며, "
          "신예슬은 자신이 의심받을 수 있다는 것을 깨닫고 김윤복이 주로 쓰던 망치로 피해자의 머리를 가격하여 "
          "타살로 위장한 뒤 도망쳤다. 이로 인해 피해자에게는 두드러기가 나고, 그 많은 상처들이 났던 것이다.";
    } else if (actualCulprit == selectedSuspect) {
      resultMessage = "$actualCulprit은 계획적으로 복어 독의 위험성에 대해 파악한 뒤 자신이 키우던 복어를 "
          "페이퍼 나이프로 죽인 뒤, 그 독을 추출하여 피해자에게 주입했다. 이후, 피해자가 다른 요인에 "
          "의해 사망한 것처럼 보이게 하기 위해, 신예슬이 최근 연구를 위해 사용하던 실험 플라스크들 중 "
          "하나를 가격, 타살로 보이게 만들었다. 진범은 그날 당일이 되어서야 복어를 죽였고, 그 때 사용한 "
          "장갑을 품에 갖고 있던 그는 지문을 남기지 않기 위해, 피해자를 살해할 때에도 다시 장갑을 착용, "
          "이로 인해 피해자는 그에게 닿은 부분들에 두드러기가 올라오고 많은 상처들과 함께 죽었던 것이다.";
    } else {
      // 진범을 못 찾았을 경우, 범인에 대한 설명 포함
      resultMessage = "$actualCulprit은 계획적으로 복어 독의 위험성에 대해 파악한 뒤, "
          "자신이 키우던 복어를 페이퍼 나이프로 죽인 뒤, 그 독을 추출하여 피해자에게 주입했다. "
          "하지만, 김이현은 주입당하는 순간 반항하며, 그녀를 잡아챘고 몸싸움 과정에서 플라스크가 떨어졌다. "
          "그의 목을 졸라 그가 죽을 때까지 더 이상의 몸부림을 막았다. 이후, 깨진 플라스크들을 보며, "
          "신예슬은 자신이 의심받을 수 있다는 것을 깨닫고 김윤복이 주로 쓰던 망치로 피해자의 머리를 가격하여 "
          "타살로 위장한 뒤 도망쳤다. 이로 인해 피해자에게는 두드러기가 나고, 그 많은 상처들이 났던 것이다.";
    }

    // 마지막 메시지 (진범을 못 찾았을 경우)
    String finalMessage = '';
    if (!isCorrect) {
      final String mostVotedSuspect = selectedSuspect; // 최다 투표 용의자 (실제 범인 아님)
      finalMessage =
          "하지만 용의자들과 탐정은 추리에 실패했고 억울한 $mostVotedSuspect 만이 감옥에 가게 되었다...";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('결과 화면'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '투표 결과:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                selectedSuspect,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '실제 범인:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                actualCulprit,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                isCorrect ? '범인 찾기 성공!' : '범인 찾기 실패!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 40),
              // 범인에 대한 설명
              Text(
                resultMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // 마지막 메시지
              if (finalMessage.isNotEmpty)
                Text(
                  finalMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  GameData.resetGameData(); // 게임 데이터 초기화
                  Navigator.pop(context);
                },
                child: const Text(
                  '다시 시작',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
