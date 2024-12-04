
import 'package:flutter/material.dart';

import '../Pieces/Board.dart';
import '../Pieces/Player.dart';
import '../Pieces/Piece.dart';

class InitialBoardModel extends ChangeNotifier {
  Board board = Board([Player(PieceColor.white), Player(PieceColor.black)]);

  void SetBoard(Board board) {
    this.board = board;
    notifyListeners();
  }
}
