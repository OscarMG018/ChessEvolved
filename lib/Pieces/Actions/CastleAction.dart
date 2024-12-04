import 'package:flutter/material.dart';
import 'PieceAction.dart';
import '../Board.dart';
import '../Piece.dart';
import '../GameManager.dart';
import 'dart:math';

class CastleAction extends PieceAction {
  CastleAction({required Piece piece, required Position position, required this.castledPieceStartingPosition, required this.castledPosition}) : super(piece, position, false, skipInCheck: true);
  Position castledPieceStartingPosition;
  late Piece castledPiece;
  Position castledPosition;

  @override
  void init() {
    Piece? p = GameManager.getInstance().board.GetPieceAt(castledPieceStartingPosition);
    if (p == null) {
      throw Exception("CastleAction: castledPiece not found");
    }
    castledPiece = p;
  }

  @override
  (bool, bool) IsValidAction(Board board) {
    //Checl if the castledPiece is on the board
    bool found = false;
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        if (board.GetPieceAt(castledPiece.position) == castledPiece) {
          found = true;
        }
      }
    }
    if (!found) {
      print("by castledPiece not found");
      return (false, false);
    }
    //Check if the piece is in its start position
    if (!identical(piece.position, piece.startPosition) || !identical(castledPiece.position, castledPiece.startPosition)) {
      print("by piece not in start position");
      print(piece.position);
      print(piece.startPosition);
      print(castledPosition);
      print(castledPiece.startPosition);
      print(castledPiece.position);
      print(identical(piece.position, piece.startPosition));
      print(identical(castledPosition, castledPiece.startPosition));
      return (false, false);
    }
    //Check if the path is clear
    int magnitude = max((castledPiece.position.x - piece.position.x).abs(), (castledPiece.position.y - piece.position.y).abs());
    Position direction = Position((castledPiece.position.x - piece.position.x) ~/ magnitude, (castledPiece.position.y - piece.position.y) ~/ magnitude);
    Position newPosition = piece.position;
    found = false;
    for (int i = 0; i < magnitude; i++) {
      if (board.IsOccupied(newPosition) && board.GetPieceAt(newPosition) != castledPiece && board.GetPieceAt(newPosition) != piece) {
        print("by path not clear");
        print(board.GetPieceAt(newPosition)?.name);
        return (false, false);
      }
      if (newPosition == castledPosition) {
        found = true;
      }
      newPosition += direction;
    }
    if (!found) {
      print("by castledPosition not between piece and castledPiece");
      return (false, false);
    }
    //Check for check
    if (board.IsCheck(piece.color).isNotEmpty) {
      print("by check");
      List<Piece> checkers = board.IsCheck(piece.color);
      print(checkers);
      for (Piece checker in checkers) {
        print(checker.name);
      }
      return (false, false);
    }
    Position oldPosition = piece.position;
    board.Swap(piece.position, getAbsolutePosition());
    if (board.IsCheck(piece.color).isNotEmpty) {
      print("by check after swap");
      return (false, false);
    }
    board.Swap(oldPosition, piece.position);
    return (true, true);
  }
  
  @override
  void action(Board board) {
    if (getAbsolutePosition() == castledPiece.position && castledPosition == piece.position) {
      board.Swap(castledPosition, piece.position);
    }
    else {
      board.Swap(getAbsolutePosition(), piece.position);
      board.Swap(castledPosition, castledPiece.position);
    }
  }
  
  @override
  PieceAction copy() {
    return CastleAction(piece: piece, position: relativePosition, castledPieceStartingPosition: castledPieceStartingPosition, castledPosition: castledPosition);
  }
  
  @override
  Color getActionColor() {
    return Colors.black;
  }
  
}