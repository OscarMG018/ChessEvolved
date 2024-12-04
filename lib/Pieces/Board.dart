import 'Piece.dart';
import 'package:flutter/material.dart';
import 'Player.dart';
import 'GameManager.dart';
import 'Actions/PieceAction.dart';

class Board {
  static const int size = 8;
  List<Player> players;
  final List<List<Piece?>> _board = List.generate(
    size,
    (_) => List<Piece?>.filled(size, null),
  );

  Board(this.players);

  @override
  String toString() {
    String string = "";
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        string += "${_board[j][i]?.name ?? "."} ";
      }
      string += "\n";
    }
    return string;
  }

  Piece? GetPieceAt(Position position) {
    return _board[position.x][position.y];
  }

  void MovePiece(Position pos,Piece piece) {
    if (GetPieceAt(pos) != null) {
      throw Exception("Attemt to move piece to an ocupied space, $pos, ${piece.position}");
    }
    SetPieceAt(pos, piece);
    SetPieceAt(piece.position, null);
    piece.position = pos;
  }

  void CapturePiece(Position pos, Piece attacker) {
    RemovePieceAt(pos, attacker);
    SetPieceAt(attacker.position, null);
    attacker.position = pos;
  }

  void RemoveFromPlayer(Position position) {
    Piece? oldPiece = GetPieceAt(position);
    if (oldPiece != null) {
      if (oldPiece.color == PieceColor.white) {
        players[0].pieces.remove(oldPiece);
      }
      else {
        players[1].pieces.remove(oldPiece);
      }
    }
  }

  void RemovePieceAt(Position position, Piece? replacement) {
    RemoveFromPlayer(position);
    SetPieceAt(position, replacement);
  }

  void SetPieceAt(Position position, Piece? piece) {
    _board[position.x][position.y] = piece;
  }

  void Swap(Position position, Position position2) {
    Piece? p = GetPieceAt(position);
    Piece? p2 = GetPieceAt(position2);
    SetPieceAt(position2, p);
    p?.position = position2;
    SetPieceAt(position, p2);
    p2?.position = position;
  }

  bool IsBlocked(Position position, PieceColor color) {
    return _board[position.x][position.y] != null && _board[position.x][position.y]!.color == color;
  }

  bool IsCapturable(Position position, PieceColor color) {
    return _board[position.x][position.y] != null && _board[position.x][position.y]!.color != color;
  }

  bool IsOccupied(Position position) {
    return _board[position.x][position.y] != null;
  }

  bool IsInBoard(Position position) {
    return position.x >= 0 && position.x < size && position.y >= 0 && position.y < size;
  }

  List<Piece> IsCheck(PieceColor color) {
    List<Piece> checkers = [];
    //Get king of color
    Piece? king = players.where((player) => player.color == color).expand((player) => player.pieces).where((piece) => piece.name == "king").firstOrNull;
    if (king != null) {
      //Get all valid actions of the enemy pieces
      Map<Piece, List<PieceAction>> actions = GameManager.getInstance().GetAllPosibleActions(PieceColor.values.firstWhere((element) => element != color), this, forCheck: true);
      //Check if any of the actions has the king's position
      for (Piece piece in actions.keys) {
        for (PieceAction action in actions[piece]!) {
          if (action.getAbsolutePosition() == king.position) {
            checkers.add(piece);
          }
        }
      }
    }
    return checkers;
  }

  Image? getImageOfPieceAt(int x, int y) {
    return GetPieceAt(Position(x, y))?.getImage();
  }
}