import 'package:flutter/material.dart';

import '../Board.dart';
import '../Piece.dart';
import 'PieceAction.dart';

class PushAction extends PieceAction {
  PushAction({required Piece piece, required Position position, required this.direction, required this.distance}) : super(piece, position, true);
  
  List<int> direction;
  int distance;


  @override
  (bool, bool) IsValidAction(Board board) {
    Position absolutePosition = getAbsolutePosition();
    if (!board.IsInBoard(absolutePosition)) {
      return (false, false);
    }
    if (board.IsOccupied(absolutePosition)) {
      Position firstPushPosition = absolutePosition + Position(direction[0], -direction[1]);
      if (!board.IsInBoard(firstPushPosition)) {
        return (false, true);
      }
      if (!board.IsOccupied(firstPushPosition)) {
        return (true, true);
      }
      return (false, true);
    }
    else {
      return (false, true);
    }
  }
  
  @override
  void action(Board board) {
    Piece pushedPiece = board.GetPieceAt(getAbsolutePosition())!;
    print("Pushing ${pushedPiece.name} from ${pushedPiece.position} direction ${direction.toString()} distance $distance");
    Position newPosition = getAbsolutePosition();
    for (int i = 0; i < distance; i++) {
      newPosition += Position(direction[0], -direction[1]);
      if (board.IsOccupied(newPosition)) {
        break;
      }
      board.MovePiece(newPosition, pushedPiece);
    }
  }
  
  @override
  PieceAction copy() {
    return PushAction(piece: piece, position: relativePosition, direction: direction, distance: distance);
  }
  
  @override
  Color getActionColor() {
    return Color.fromARGB(255, 89, 255, 158);
  }
  
}
