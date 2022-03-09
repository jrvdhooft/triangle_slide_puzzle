//import 'dart:ffi';

//import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'board.dart';

PlayBoard playBoard = PlayBoard();
List<TriangleSprite> triangleList = [];
List<NumberSprite> numberList = [];
List<SquareSprite> squareList = [];
double screenWidth = 0;
double screenHeight = 0;
double moveTimInSecs = 0.51;
bool initDone = false;
bool displayNumbers = false;

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  TriangleSprite triangle = TriangleSprite();
  SpriteComponent background = SpriteComponent();
  ShuffleButton shuffleButton = ShuffleButton();
  SolveButton solveButton = SolveButton();
  DisplayNumbersButton displayNumbersButton = DisplayNumbersButton();
  final Vector2 buttonSize = Vector2(100.0, 100.0);

  final double triangleSize = 64.0;

  double xFactor = 50;
  double yFactor = 50;
  double xOffset = 50;
  double yOffset = 50;

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 36, color: Colors.white));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = size[0];
    screenHeight = size[1];

    // double x_factor = 75;
    // double y_factor = 75;
    // double x_offset = screenWidth / 2;
    // double y_offset = screenHeight / 2;
    // setup background2
    background
      ..sprite = await loadSprite('border.png')
      ..anchor = Anchor.center
      ..size = Vector2((screenWidth / 2) * 1.18, screenHeight * 0.93)
      ..position = Vector2(-3 + screenWidth / 2, screenHeight / 2);
    shuffleButton
      ..sprite = await loadSprite('shuffle.png')
      ..size = buttonSize
      ..position = Vector2(screenWidth - buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);
    solveButton
      ..sprite = await loadSprite('solve.png')
      ..size = buttonSize
      ..position = Vector2(screenWidth - 2 * buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);
    displayNumbersButton
      ..sprite = await loadSprite('numbers.png')
      ..size = buttonSize
      ..position = Vector2(screenWidth - 3 * buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);

    // String na = "0";
    for (int i = 0; i < 23; i++) {
      triangleList.add(TriangleSprite()
        ..triangleNumber = i
        ..boardPosition = i
        ..sprite = await loadSprite(i.toString() + '.png')
        ..size = Vector2(triangleSize, triangleSize));
      numberList.add(NumberSprite()
        ..triangleNumber = i
        ..boardPosition = i
        ..sprite = await loadSprite('n' + i.toString() + '.png')
        ..size = Vector2(triangleSize, triangleSize));
      squareList.add(SquareSprite()
        ..triangleNumber = i
        ..boardPosition = i
        ..sprite = await loadSprite('squary_empty.png')
        ..size = Vector2(triangleSize * 0.66, triangleSize * 0.66));
      playBoard.playFields[i].free = false;
    }

    playBoard.recalcPosition(triangleList, squareList, numberList, screenWidth, screenHeight);
    playBoard.recalcSize(triangleList, squareList, numberList, screenWidth, screenHeight);

    background.size = Vector2(triangleList[0].size.x * 4.33, triangleList[0].size.y * 4.38);
    add(background);
    for (int i = 0; i < 23; i++) {
      numberList[i].position.x = numberList[i].xNew;
      numberList[i].position.y = numberList[i].yNew;
      add(triangleList[i]);
      add(squareList[i]);
      if (displayNumbers) {
        add(numberList[i]);
      } else {
        remove(numberList[i]);
      }
    }

    add(shuffleButton);
    add(solveButton);
    add(displayNumbersButton);
    initDone = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (int i = 0; i < 23; i++) {
      numberList[i].moveSprite(dt);
      triangleList[i].moveSprite(dt);
      if (displayNumbers) {
        add(numberList[i]);
      } else {
        remove(numberList[i]);
      }
    }
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  // }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    screenWidth = canvasSize.x;
    screenHeight = canvasSize.y;
    // print("scr($screenWidth,$screenHeight)");

    redrawScreen();
  }

  void redrawScreen() {
    if (initDone == true) {
      //background.size = Vector2(screenWidth, screenHeight);

      shuffleButton.position = Vector2(screenWidth - buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);
      solveButton.position = Vector2(screenWidth - 2 * buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);
      displayNumbersButton.position = Vector2(screenWidth - 3 * buttonSize[0] - 10, screenHeight - buttonSize[1] - 10);

      playBoard.recalcPosition(triangleList, squareList, numberList, screenWidth, screenHeight);
      playBoard.recalcSize(triangleList, squareList, numberList, screenWidth, screenHeight);

      background.position = Vector2(-3 + screenWidth / 2, screenHeight / 2);
      for (int i = 0; i < 23; i++) {
        numberList[i].position.x = numberList[i].xNew;
        numberList[i].position.y = numberList[i].yNew;
        add(triangleList[i]);
        add(squareList[i]);
        if (displayNumbers) {
          add(numberList[i]);
        } else {
          remove(numberList[i]);
        }
      }
      background.size = Vector2(triangleList[0].size.x * 4.33, triangleList[0].size.y * 4.38);
      add(shuffleButton);
      add(solveButton);
      add(displayNumbersButton);
    }
  }
}

class ShuffleButton extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      moveTimInSecs = 0.6;
      playBoard.shuffle(1500);
      return true;
    } catch (error) {
      // print(error);
      return false;
    }
  }
}

class NumberSprite extends SpriteComponent {
  late int triangleNumber;
  late int boardPosition;
  double xNew = 0;
  double yNew = 0;
  NumberSprite() {
    anchor = Anchor.center;
  }
  void moveSprite(double dt) {
    if (xNew != position.x || yNew != position.y) {
      // verplaatsing moet gelijk zijn aan dt/moveTimInSecs. b.v. 0.01 / 0.5 = 0.02
      // dat geeft een verplaatsing van x_to-x_van = 100 px * 0.02 = 2 pix
      position.x = position.x + (xNew - position.x) * (dt / moveTimInSecs);
      position.y = position.y + (yNew - position.y) * (dt / moveTimInSecs);
    }
  }
}

class TriangleSprite extends SpriteComponent {
  late int triangleNumber;
  late int boardPosition;
  double xNew = 0;
  double yNew = 0;
  double angleNew = 0;

  TriangleSprite() {
    anchor = Anchor.center;
  }
  void moveSprite(double dt) {
    if (xNew != position.x || yNew != position.y) {
      // verplaatsing moet gelijk zijn aan dt/moveTimInSecs. b.v. 0.01 / 0.5 = 0.02
      // dat geeft een verplaatsing van x_to-x_van = 100 px * 0.02 = 2 pix
      position.x = position.x + (xNew - position.x) * (dt / moveTimInSecs);
      position.y = position.y + (yNew - position.y) * (dt / moveTimInSecs);
    }
    if (angleNew != angle) {
      // verplaatsing moet gelijk zijn aan dt/moveTimInSecs. b.v. 0.01 / 0.5 = 0.02
      // dat geeft een verplaatsing van x_to-x_van = 100 px * 0.02 = 2 pix
      angle = angle + (angleNew - angle) * (dt / moveTimInSecs);
    }
  }
}

class SquareSprite extends SpriteComponent with Tappable {
  late int triangleNumber;
  late int boardPosition;
  SquareSprite() {
    anchor = Anchor.center;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    moveTimInSecs = 0.1;
    bool r = do1Move();
    playBoard.recalcPosition(triangleList, squareList, numberList, screenWidth, screenHeight);
    return r;
  }

  bool do1Move() {
    try {
      int i = playBoard.canGoToPlayfieldNumber(this);
      // print('hit trangle sprite.. $triangle_number, can go to $i');
      if (i != -1) {
        playBoard.moveTriangleAndSquareSprite(triangleList[triangleNumber], this, i);
      }
      return true;
    } catch (error) {
      // print(error);
      return false;
    }
  }
}

class SolveButton extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo info) {
    moveTimInSecs = 0.6;
    try {
      for (int i = 0; i < 23; i++) {
        triangleList[i].triangleNumber = i;
        triangleList[i].boardPosition = i;
        numberList[i].triangleNumber = i;
        numberList[i].boardPosition = i;
        squareList[i].triangleNumber = i;
        squareList[i].boardPosition = i;
        playBoard.playFields[i].free = false;
      }
      playBoard.playFields[23].free = true;
      playBoard.recalcPosition(triangleList, squareList, numberList, screenWidth, screenHeight);
      return true;
    } catch (error) {
      // print(error);
      return false;
    }
  }
}

class DisplayNumbersButton extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo info) {
    if (displayNumbers) {
      displayNumbers = false;
    } else {
      displayNumbers = true;
    }
    // print("dpn=$displayNumbers");

    return true;
  }
}
