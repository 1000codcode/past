import 'package:flutter/material.dart';
import 'data.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 수집된 단서 및 플레이어의 역할과 알리바이
    final collectedClues = GameData.collectedClues; // 플레이어가 수집한 단서 목록
    final role = GameData.currentRole; // 현재 플레이어 역할
    final alibi = GameData.currentAlibi; // 현재 플레이어 알리바이

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '수첩',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 현재 역할 출력
            if (role != null)
              ListTile(
                title: Text(
                  "역할: $role",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.person, color: Colors.red),
              ),

            // 현재 알리바이 출력
            if (alibi != null)
              ListTile(
                title: Text(
                  "알리바이: $alibi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: const Icon(Icons.security, color: Colors.orange),
              ),

            const Divider(
              color: Colors.red,
              thickness: 2,
              height: 20,
            ),

            // 수집된 단서 목록 출력
            const Text(
              "수집된 단서들:",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (collectedClues.isNotEmpty)
              ...collectedClues.map(
                (clue) => ListTile(
                  title: Text(
                    clue,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  leading: const Icon(Icons.search, color: Colors.white),
                ),
              )
            else
              const Center(
                child: Text(
                  "아직 수집된 단서가 없습니다.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
