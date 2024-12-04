import 'package:flutter/material.dart';

import '../Board.dart';
import '../Piece.dart';
import 'PieceAction.dart';

class PathAction extends PieceAction {//this action is used to skip an action on the path, usually for ranged attacks
  PathAction({required Piece piece, required Position position}) : super(piece, position, false);
  
  @override
  (bool, bool) IsValidAction(Board board) {
    if (board.IsOccupied(getAbsolutePosition())) {
      return (false, false);
    }
    return (false, true);
  }
  
  @override
  void action(Board board) {
    throw Exception("PathAction can't be executed");
  }
  
  @override
  PieceAction copy() {
    return PathAction(piece: piece, position: relativePosition);
  }
  
  @override
  Color getActionColor() {
    return Colors.transparent;
  }
}