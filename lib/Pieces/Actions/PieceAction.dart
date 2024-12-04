import 'package:flutter/material.dart';

import '../Board.dart';
import '../Piece.dart';

abstract class PieceAction {
    Piece piece;
    Position relativePosition;
    bool isUnblockable;//knigth jumping
    bool offersive = false;
    bool skipInCheck = false;

    void init() {}
    PieceAction(this.piece, this.relativePosition, this.isUnblockable, {this.offersive = false, this.skipInCheck = false});
    (bool, bool) IsValidAction(Board board);//asumes that the path is clear
    void action(Board board);
    Color getActionColor();
    PieceAction copy();
    Position getAbsolutePosition() {
      if (piece.color == PieceColor.white) {
        return Position(piece.position.x + relativePosition.x, piece.position.y - relativePosition.y);
      }
      return piece.position + relativePosition;
    }
}
