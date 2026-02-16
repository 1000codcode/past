import 'package:flutter/material.dart';
import 'role_assignment_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final PageController _pageController = PageController();

  // 4페이지로 나눈 스토리 텍스트와 이미지 목록
  final List<Map<String, String>> _storyContent = [
    {
      'image': 'lib/assets/story1.png', // 이미지 경로 수정
      'text': '''서울 외곽의 고급 저택에서 발생한 살인 사건.
피해자는 유명 화가 김이현(50세)으로, 그는 최근까지 예술계에서 활발하게 활동한 인물이었다. 다양한 작품으로 유명하며, 많은 제자들을 두고 있었다.
사건은 김이현이 주최한 저녁 만찬 후 발생했다. 만찬이 끝난 후, 피해자는 잠시 후인 8시 50분에서 9시 30분 사이에 사망한 것으로 추정된다.
사건이 발생한 당시, 저택에서는 정전이 일어나 전기가 모두 끊어진 상태였다. 모든 사람들이 저택의 두꺼비집을 점검하기 위해 모였으나, 피해자는 그곳에 나타나지 않았다.
그로부터 30분 후, 한규상 기자가 피해자의 시체를 발견하면서 사건에 대한 수사가 시작되었다.''',
    },
    {
      'image': 'lib/assets/story2.png', // 이미지 경로 수정
      'text': '''김이현의 시체는 그의 개인 방에서 발견되었다. 피해자의 입과 목에는 심한 두드러기가 나 있었고, 동공은 확장되어 있었다.
머리에서는 다량의 피가 흐르고 있었으며, 시체의 바로 옆에는 두꺼운 유리조각들이 흩어져 있었다. 이 유리조각들에는 피가 묻어 있었다.
목에는 멍이 들어 있었고, 찔린 자국도 발견되었으며, 특히 목을 강하게 잡은 듯한 흔적이 남아 있었다.
피해자는 어패류 알레르기가 있었지만, 평소에는 알레르기 반응이 경미했기 때문에 만찬에 제공된 어패류를 섭취한 후에도 특별한 이상을 느끼지 않았을 것이다. 
그의 사망 원인은 과다출혈과 알레르기 반응에 의한 쇼크로 보인다. 그러나 그의 사망을 둘러싼 의문점은 여전히 풀리지 않았다.''',
    },
    {
      'image': 'lib/assets/story3.png', // 이미지 경로 수정
      'text': '''사망 추정 시각은 8시 50분에서 9시 30분 사이로 추정된다. 피해자가 만찬 후 얼마 지나지 않아 사망한 것으로 보인다.
사건 발생 당시의 정전이 중요한 단서가 될 수 있었다. 피해자가 사망한 시간대에는 모든 전기가 끊겨 있었고, 
이후 사건에 대한 조사가 시작되었지만 그가 마지막으로 목격된 장소나, 그가 사망에 이르게 된 구체적인 이유는 명확하지 않았다.
사건의 발생 당시, 저택의 분위기는 무척 긴장감이 감돌았으며, 그 누구도 피해자의 상태에 대해 예측할 수 없었다.
정확한 사망 원인은 아직 규명되지 않았지만, 사건에 대한 의문은 더욱 깊어지고 있다.''',
    },
    {
      'image': 'lib/assets/story4.png', // 이미지 경로 수정
      'text': '''김이현의 사망 사건을 둘러싼 의문들은 계속해서 제기되고 있다. 피해자는 누구에게 살해당했으며, 어떤 이유로 죽음을 맞이했을까?
사건이 발생한 직후, 피해자는 전혀 예상치 못한 방식으로 죽음을 맞이했다. 그가 알레르기 반응으로 사망했다는 이론은 단지 표면적인 원인일 뿐, 사건의 진상은 아직
밝혀지지 않았다. 과연, 피해자의 죽음을 둘러싼 진실은 무엇일까?
김이현의 사망 추정시간: 8시 50분 ~ 9시 30분 사이. 최초 발견자 한규상이 시체를 발견한 시간: 10시 00분''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _storyContent.length,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              Image.asset(
                _storyContent[index]['image']!,
                fit: BoxFit.cover,
              ),
              // 반투명 배경 + 텍스트
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _storyContent[index]['text']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // 하단 "다음" 버튼
              Positioned(
                bottom: screenSize.height * 0.05, // 화면 크기에 따라 위치 조정
                right: screenSize.width * 0.05,
                child: index < _storyContent.length - 1
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // 스토리 끝난 후 역할 할당 화면으로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoleAssignmentScreen()),
                    );
                  },
                  child: const Text(
                    '시작하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
