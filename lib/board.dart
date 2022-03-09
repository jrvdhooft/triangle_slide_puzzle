import 'dart:math' as math;
import 'main.dart';

import 'package:flame/game.dart';

class PlayBoard {
  List<PlayField> playFields = [];
  final double triangleFactor = 0.866; // 0.866

  PlayBoard() {
    //---------------------------------------1e regel (5 stuks)
    playFields.add(PlayField() // 0
      ..x = -1.0
      ..y = (-triangleFactor - triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [1, 6]);
    playFields.add(PlayField() // 1
      ..x = -0.5
      ..y = (-triangleFactor - triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [0, 2]);
    playFields.add(PlayField() // 2
      ..x = -0.0
      ..y = (-triangleFactor - triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [1, 3, 8]);
    playFields.add(PlayField() // 3
      ..x = .5
      ..y = (-triangleFactor - triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [2, 4]);
    playFields.add(PlayField() // 4
      ..x = 1
      ..y = (-triangleFactor - triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [3, 10]);
    //---------------------------------------2e regel (7 stuks)
    playFields.add(PlayField() // 5
      ..x = -1.5
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [6, 12]);
    playFields.add(PlayField() // 6
      ..x = -1.0
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [0, 5, 7]);
    playFields.add(PlayField() // 7
      ..x = -0.5
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [6, 8, 14]);
    playFields.add(PlayField() // 8
      ..x = 0.0
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [2, 7, 9]);
    playFields.add(PlayField() // 9
      ..x = 0.5
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [8, 10, 16]);
    playFields.add(PlayField() // 10
      ..x = 1.0
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [4, 9, 11]);
    playFields.add(PlayField() // 11
      ..x = 1.5
      ..y = (-triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [10, 18]);
    //---------------------------------------3e regel (7 stuks)
    playFields.add(PlayField() // 12
      ..x = -1.5
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [5, 13]);
    playFields.add(PlayField() // 13
      ..x = -1.0
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [12, 14, 19]);
    playFields.add(PlayField() // 14
      ..x = -0.5
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [7, 13, 15]);
    playFields.add(PlayField() // 15
      ..x = 0.0
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [14, 16, 21]);
    playFields.add(PlayField() // 16
      ..x = 0.5
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [9, 15, 17]);
    playFields.add(PlayField() // 17
      ..x = 1.0
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [16, 18, 23]);
    playFields.add(PlayField() // 18
      ..x = 1.5
      ..y = (triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [11, 17]);
    //---------------------------------------4e regel (5 stuks)
    playFields.add(PlayField() // 19
      ..x = -1.0
      ..y = (triangleFactor + triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [13, 20]);
    playFields.add(PlayField() // 20
      ..x = -0.5
      ..y = (triangleFactor + triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [19, 21]);
    playFields.add(PlayField() // 21
      ..x = 0.0
      ..y = (triangleFactor + triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [15, 20, 22]);
    playFields.add(PlayField() // 22
      ..x = 0.5
      ..y = (triangleFactor + triangleFactor / 2) * triangleFactor
      ..orientation = true
      ..canGoToPlayFields = [21, 23]);
    playFields.add(PlayField() // 23
      ..x = 1.0
      ..y = (triangleFactor + triangleFactor / 2) * triangleFactor
      ..orientation = false
      ..canGoToPlayFields = [17, 22]);
  }

  void recalcSize(List<TriangleSprite> triangleList, List<SquareSprite> squareList, List<NumberSprite> numberList,
      double screenWidth, double screenHeight) {
    double factor = math.min(screenWidth / 4, screenHeight / 4);
    double triangleSize = factor;
    for (int i = 0; i < 23; i++) {
      triangleList[i].size = Vector2(triangleSize, triangleSize * triangleFactor);
      squareList[i].size = Vector2(triangleSize * 0.5, triangleSize * triangleFactor);
      numberList[i].size = triangleList[i].size;
    }
  }

  void recalcPosition(List<TriangleSprite> triangleList, List<SquareSprite> squareList, List<NumberSprite> numberList,
      double screenWidth, double screenHeight) {
    double xFactor = math.min(screenWidth / 4, screenHeight / 4);
    double yFactor = xFactor;
    double xOffset = screenWidth / 2;
    double yOffset = screenHeight / 2;
    // double triangleSize = x_factor;
    // double jx, jy;
    for (int i = 0; i < 23; i++) {
      triangleList[i].xNew = xOffset + playFields[triangleList[i].boardPosition].x * xFactor;
      triangleList[i].yNew =
          yOffset + playFields[triangleList[i].boardPosition].y * (yFactor * 1.01) * (1 / triangleFactor);

      if (playFields[triangleList[i].boardPosition].orientation) {
        triangleList[i].angleNew = 0.0;
      } else {
        triangleList[i].angleNew = math.pi;
      }
      //
      squareList[i].position.x = triangleList[i].xNew;
      squareList[i].position.y = triangleList[i].yNew;

      numberList[i].xNew = triangleList[i].xNew;
      numberList[i].yNew = triangleList[i].yNew;
    }
  }

  int canGoToPlayfieldNumber(SquareSprite squareSprite) {
    int fieldnr;
    int v = playFields[squareSprite.boardPosition].canGoToPlayFields.length;
    // print('cnt fields. $v');
    for (int i = 0; i < v; i++) {
      fieldnr = playFields[squareSprite.boardPosition].canGoToPlayFields[i];
      //bool bb = playFields[fieldnr].free;
      // print('ee $fieldnr $bb');
      if (playFields[fieldnr].free == true) return fieldnr;
    }
    return -1;
  }

  void moveTriangleAndSquareSprite(TriangleSprite triangleSprite, SquareSprite squareSprite, to) {
    int from = triangleSprite.boardPosition;
    playFields[from].free = true;
    playFields[to].free = false;
    triangleSprite.boardPosition = to;
    squareSprite.boardPosition = to;
  }

  void shuffle(int numberOfIterations) {
    var rng = math.Random();
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

    // Ga nu random zetten doen
    int emptyFieldIs = 23;
    for (int i = 0; i < numberOfIterations; i++) {
      int randomNextEmptyFieldIndex = rng.nextInt(playFields[emptyFieldIs].canGoToPlayFields.length);
      int boardNumberIsFrom = playFields[emptyFieldIs].canGoToPlayFields[randomNextEmptyFieldIndex];
      //find out witch square is on that field
      for (int j = 0; j < 23; j++) {
        if (squareList[j].boardPosition == boardNumberIsFrom) {
          squareList[j].do1Move();
          break;
        }
      }
      emptyFieldIs = boardNumberIsFrom;
    }
    playBoard.recalcPosition(triangleList, squareList, numberList, screenWidth, screenHeight);
  }
}
/*
 var rng = Random();
  for (var i = 0; i < 10; i++) {
    print(rng.nextInt(100));
static var mypoints = [
  Vector2(0,0),
  Vector2(1,0),
  Vector2(0.5, triangleFactor)
];
*/

class PlayField {
  late double x;
  late double y;
  late bool orientation; // true=ArrowUp; false=ArrowDown
  bool free = true;
  late List<int> canGoToPlayFields;
}
