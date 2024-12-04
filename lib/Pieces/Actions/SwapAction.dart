import 'package:flutter/material.dart';

import '../Board.dart';
import '../Piece.dart';

import 'PieceAction.dart';

class SwapAction extends PieceAction {//Move, Attack or Swap places with ally
  SwapAction({required Piece piece, required Position position}) : super(piece, position, true);
  
  @override
  (bool, bool) IsValidAction(Board board) {
    return (true, true);
  }
  
  @override
  void action(Board board) {
    if (board.IsCapturable(getAbsolutePosition(), piece.color)) {
      board.CapturePiece(getAbsolutePosition(), piece);
    }
    else {
      board.Swap(piece.position, getAbsolutePosition());//move(swap with null) or swap with ally
    }
  }
  
  @override
  PieceAction copy() {
    return SwapAction(piece: piece, position: relativePosition);
  }
  
  @override
  Color getActionColor() {
    return Colors.yellow;
  }
  
}
