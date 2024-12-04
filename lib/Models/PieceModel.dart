import 'package:flutter/material.dart';

import '../Pieces/Piece.dart';
import '../Pieces/PieceList.dart';

class PieceModel extends ChangeNotifier {
  void reload() {
    notifyListeners();
  }

  List<Piece> getPieceList() {
    return PieceList.getPieces();
  }
}
