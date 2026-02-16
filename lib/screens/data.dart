import 'dart:convert'; // JSON 처리를 위해 추가
import 'dart:math'; // Random 처리를 위해 추가
import 'package:flutter/services.dart'; // rootBundle 사용을 위해 추가

class GameData {
  static const String detectiveRole = "탐정";
  static String? currentRole;
  static String? currentSuspect;
  static String? currentGender;

  static List<String> collectedClues = [];
  static Set<int> collectedClueNumbers = {};
  static String? votedSuspect;

  static final Map<String, int> votes = {
    "한규상": 0,
    "신예슬": 0,
    "황윤서": 0,
    "김윤복": 0,
  };

  static final Map<String, String> roomJsonMapping = {
    "김이현의 작업실": 'lib/assets/김이현.json',
    "황윤서의 거실": 'lib/assets/황윤서.json',
    "신예슬의 연구실": 'lib/assets/신예슬.json',
    "김윤복의 사무실": 'lib/assets/김윤복.json',
    "한규상의 집": 'lib/assets/한규상.json',
  };

  static final Map<String, Map<String, List<Map<String, dynamic>>>> roomClues =
      {};

  static const List<String> suspects = ["한규상", "신예슬", "황윤서", "김윤복"];

  static const Map<String, String> suspectGenders = {
    "한규상": "남성",
    "김윤복": "남성",
    "신예슬": "여성",
    "황윤서": "여성",
  };

  static const Map<String, String> suspectAlibis = {
    "한규상": "사건 당시 집에서 뉴스를 작성하고 있었습니다.",
    "신예슬": "사건 당시 실험실에서 연구를 진행 중이었습니다.",
    "황윤서": "사건 당시 친구와 저녁 식사를 하고 있었습니다.",
    "김윤복": "사건 당시 사무실에서 서류를 검토 중이었습니다.",
  };

  static Future<void> loadRoomClues() async {
    for (var room in roomJsonMapping.keys) {
      final file = roomJsonMapping[room];
      if (file != null) {
        final jsonString = await rootBundle.loadString(file);
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;
        roomClues[room] = jsonData.map((category, clues) => MapEntry(
              category,
              List<Map<String, dynamic>>.from(clues),
            ));
      }
    }
    print("단서 데이터가 성공적으로 로드되었습니다.");
  }

  static Map<String, dynamic> getRandomRole() {
    final random = Random();
    final isDetective = random.nextBool();
    final suspectIndex = random.nextInt(suspects.length);

    if (isDetective) {
      currentRole = detectiveRole;
      currentSuspect = null;
      currentGender = null;
      return {
        "role": currentRole,
        "alibi": null,
      };
    } else {
      currentRole = suspects[suspectIndex];
      currentSuspect = suspects[suspectIndex];
      currentGender = suspectGenders[currentSuspect!]!;
      return {
        "role": currentRole,
        "alibi": suspectAlibis[currentSuspect!],
      };
    }
  }

  static String? get currentAlibi {
    if (currentSuspect != null) {
      return suspectAlibis[currentSuspect!];
    }
    return null;
  }

  static Map<String, Map<String, List<Map<String, dynamic>>>>
      getFilteredRoomClues() {
    if (currentSuspect == null || currentGender == null) return roomClues;

    final filteredClues = <String, Map<String, List<Map<String, dynamic>>>>{};

    roomClues.forEach((room, categories) {
      final filteredCategories = <String, List<Map<String, dynamic>>>{};
      categories.forEach((category, clues) {
        final filteredCluesList = clues.map((clue) {
          final description = clue['description'] as String;
          return {
            "id": clue['id'],
            "description": description
                .replaceAll("OOO", currentSuspect!)
                .replaceAll("XX", currentGender!),
          };
        }).toList();
        filteredCategories[category] = filteredCluesList;
      });
      filteredClues[room] = filteredCategories;
    });

    return filteredClues;
  }

  static String? collectClue(String room, String category) {
    final clues = getFilteredRoomClues()[room]?[category];
    if (clues != null && clues.isNotEmpty) {
      final remainingClues = clues
          .where((clue) => !collectedClueNumbers.contains(clue['id']))
          .toList();
      if (remainingClues.isNotEmpty) {
        final randomClue =
            remainingClues[Random().nextInt(remainingClues.length)];
        collectedClueNumbers.add(randomClue['id']);
        collectedClues.add(randomClue['description']);
        return randomClue['description'];
      }
    }
    return null;
  }

  static void castVote(String suspect) {
    if (votes.containsKey(suspect)) {
      votedSuspect = suspect;
      votes[suspect] = (votes[suspect] ?? 0) + 1;
    }
  }

  static void resetVotes() {
    votes.updateAll((key, value) => 0);
    votedSuspect = null;
  }

  static void resetGameData() {
    currentRole = null;
    currentSuspect = null;
    currentGender = null;
    collectedClues.clear();
    collectedClueNumbers.clear();
    votes.updateAll((key, value) => 0);
    print("게임 데이터가 초기화되었습니다.");
  }
}
