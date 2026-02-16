# 🎭 Mystery Game (Flutter)

A Flutter-based mystery investigation game where players explore different locations, collect clues within a time limit, and participate in a voting phase to determine the suspect.

---

## 📌 Overview

Mystery Game is an interactive investigation game built with Flutter.  
Players enter various locations, search for clues under a time limit, and proceed to a voting stage after collecting evidence.

The game is structured with multiple screens and a centralized data system that manages clues dynamically.

---

## 🚀 Features

- ⏳ 60-second countdown timer per search round
- 🔍 Randomized clue collection system
- 🎯 Maximum of 4 clues per round
- 🖼 Dynamic background images based on location
- 🗳 Voting phase after investigation
- 🛑 Automatic round termination when:
  - Time expires
  - Maximum clues are collected

---

## 🏗 Project Structure

```
lib/
│
├── main.dart
├── data.dart
├── game_main_screen.dart
└── vote_screen.dart
```

### File Descriptions

| File | Description |
|------|------------|
| `main.dart` | Entry point and core game logic |
| `data.dart` | Manages all clue data and random selection |
| `game_main_screen.dart` | Main game screen |
| `vote_screen.dart` | Voting stage screen |

---

## 🧠 Game Flow

```
MyApp
   ↓
GameMainScreen
   ↓
LocationDetailsScreen
   ↓
GameData.collectClue()
   ↓
VoteScreen
```

---

## 🎮 How to Play

1. Launch the app.
2. Select a location from the main screen.
3. Enter the search phase.
4. Collect up to 4 clues within 60 seconds.
5. After the search ends:
   - Return to the main screen (Round 1)
   - Move to the voting screen (Round 2)

---

## 🔍 Clue System

Clues are managed inside `data.dart`.

### How It Works

```dart
GameData.collectClue(location, clueGroup);
```

- Retrieves a clue based on:
  - Current location
  - Clue group (e.g., shelf, desk, floor)
- Returns:
  - `String` → A clue is found
  - `null` → No clues remaining in that group
- Clues are randomly selected and removed once used

---

## ⏳ Timer System

Each search round includes a countdown timer:

```dart
Timer.periodic(const Duration(seconds: 1), ...)
```

- Starts at 60 seconds
- Ends automatically when:
  - Timer reaches 0
  - 4 clues are collected

---

## 🖼 Location-Based Background

Background images are dynamically loaded depending on the selected location:

```dart
_getLocationImage()
```

To add a new location:
1. Add a background image in `assets`
2. Update `_getLocationImage()`
3. Add clue buttons in `_buildFixedPositionButtons()`
4. Add clue data in `data.dart`

---

## ⚙ Customization Guide

### Change Maximum Clues Per Round

```dart
static const int maxCluesPerRound = 4;
```

---

### Change Timer Duration

```dart
int secondsRemaining = 60;
```

---

### Add a New Location

1. Add image asset
2. Update switch case in:
   - `_getLocationImage()`
   - `_buildFixedPositionButtons()`
3. Add clue data in `GameData`

---

## 🛠 Requirements

- Flutter SDK
- Dart
- Android Studio / VS Code

---

## ▶ Running the Project

```bash
flutter pub get
flutter run
```

---

## 📌 Future Improvements

- Multiplayer support
- Enhanced UI animations
- Sound effects
- Difficulty modes
- Persistent game state

---

## 👨‍💻 Author

Developed using Flutter for educational

---

