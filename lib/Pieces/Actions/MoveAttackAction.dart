import 'package:flutter/material.dart';

import '../Board.dart';
import '../Piece.dart';

import 'PieceAction.dart';

enum MoveAttackActionType {
  MOVE_ONLY,
  ATTACK_ONLY,
  MOVE_OR_ATTACK,
}

class MoveAttackAction extends PieceAction {
  MoveAttackActionType type;
  bool moveToAttack;
  bool fromStartPosition = false;

  MoveAttackAction({
    required Piece piece, 
    required Position position, 
    required this.type, 
    this.moveToAttack = true, 
    this.fromStartPosition = false,
    bool isUnblockable = false,
  }) : super(piece, position, isUnblockable, offersive: (type == MoveAttackActionType.MOVE_OR_ATTACK || type == MoveAttackActionType.ATTACK_ONLY));

  @override
  (bool, bool) IsValidAction(Board board) {//first bool is if the action is valid, second bool is if this interupts the path of the piece
    Position absolutePosition = getAbsolutePosition();
    if (!board.IsInBoard(absolutePosition)) {
      return (false, true);
    }
    if (fromStartPosition && !identical(piece.position, piece.startPosition)) {
      return (false, false);
    }
    if (type == MoveAttackActionType.MOVE_OR_ATTACK) {
      if (board.IsCapturable(absolutePosition, piece.color)) {
        return (true, false);
      }
      if (board.IsOccupied(absolutePosition)) {
        return (false, false);
      }
      return (true, true);
    }
    if (type == MoveAttackActionType.ATTACK_ONLY) {
      if (board.IsCapturable(absolutePosition, piece.color)) {
        return (true, false);
      }
      if (board.IsOccupied(absolutePosition)) {
        return (false, false);
      }
      return (false, true);
    }
    if (type == MoveAttackActionType.MOVE_ONLY) {
      if (!board.IsOccupied(absolutePosition)) {
        return (true, true);
      }
      return (false, false);
    }
    return (false, false);
  }

  @override
  void action(Board board) {
    Position absolutePosition = getAbsolutePosition();
    if (board.IsCapturable(absolutePosition, piece.color)) {
      if (moveToAttack) {
        board.CapturePiece(absolutePosition,piece);
      }
      else {
        board.RemovePieceAt(absolutePosition, null);
      }
    }
    else {
      board.MovePiece(absolutePosition, piece);
    }
  }

  @override
  Color getActionColor() {
    switch (type) {
      case MoveAttackActionType.MOVE_ONLY:
        if (fromStartPosition) {
          if (isUnblockable) {
            return const Color.fromARGB(255, 240, 161, 187);
          }
          return Colors.cyan;
        }
        if (isUnblockable) {
          return Colors.purple;
        }
        return Colors.blue;
      case MoveAttackActionType.ATTACK_ONLY:
        if (!moveToAttack) {
          return Color.fromARGB(255, 122, 33, 27);
        }
        return Colors.red;
      case MoveAttackActionType.MOVE_OR_ATTACK:
        if (isUnblockable) {
          return const Color.fromARGB(255, 57, 220, 65);
        }
        return Colors.grey[700]!;
    }
  }

  @override
  PieceAction copy() {
    return MoveAttackAction(piece: piece, position: relativePosition, type: type, moveToAttack: moveToAttack, fromStartPosition: fromStartPosition, isUnblockable: isUnblockable);
  }
}