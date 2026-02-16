import 'package:flutter/material.dart';
import 'location_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final bool isSecondRound;

  // 전역 변수로 방문한 장소 추적
  static Set<String> visitedLocations = {};

  // 각 라운드별 방문 가능한 횟수 제한
  static const int maxVisitsPerRound = 1;

  SearchScreen({Key? key, required this.isSecondRound}) : super(key: key);

  final List<String> locations = [
    "김이현의 작업실",
    "황윤서의 거실",
    "신예슬의 연구실",
    "김윤복의 사무실",
    "한규상의 집",
  ];

  // 해당 장소 방문 가능한지 체크하는 메소드
  bool canVisitLocation(String location) {
    int timesVisited = visitedLocations.where((loc) => loc == location).length;
    return timesVisited < maxVisitsPerRound;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSecondRound ? '2차 수색 장소 선택' : '1차 수색 장소 선택'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          final canVisit = canVisitLocation(location);

          return GestureDetector(
            onTap: canVisit
                ? () {
                    // 방문 기록 추가
                    visitedLocations.add(location);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationDetailsScreen(
                          location: location,
                          searchRound: isSecondRound ? 2 : 1,
                        ),
                      ),
                    );
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: canVisit ? Colors.black : Colors.grey.shade800,
                border: Border.all(
                    color: canVisit ? Colors.redAccent : Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  locations[index],
                  style: TextStyle(
                      color: canVisit ? Colors.white : Colors.grey,
                      fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
