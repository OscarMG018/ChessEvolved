import 'Piece.dart';
import 'Actions/PieceAction.dart';
import 'Actions/PieceActionGroup.dart';
import 'Actions/MoveAttackAction.dart';
import 'Actions/PathAction.dart';
import 'Actions/PushAction.dart';
import 'Actions/SwapAction.dart';
import 'Actions/CastleAction.dart';
import 'Actions/PieceActionType.dart';
import 'dart:convert';

class PieceList {
  static PieceList? instance;
  List<Piece> pieces = [];

  PieceList() {
    pieces = [];
    definePieces();
  }

  static PieceList getInstance() {
    instance ??= PieceList();
    return instance!;
  }

  static Piece getByName(String name,{PieceColor color = PieceColor.white,Position position = const Position(0,0)}) {
    Piece? piece = getInstance().pieces.where((piece) => piece.name == name).firstOrNull;
    if (piece == null) {
      throw Exception("Piece not found");
    }
    Piece copy = Piece.copy(piece);
    copy.color = color;
    copy.position = position;
    copy.startPosition = copy.position;
    for (PieceActionGroup group in copy.actionsGroups) {
      for (PieceAction action in group.actions) {
        action.piece = copy;
      }
    }
    return copy;
  }

  static List<Piece> getPieces({bool excludeKing = true}) {
    return getInstance().pieces.where((piece) => piece.name != "king" || !excludeKing).toList();
  }

  void definePieces() {
    definePawn();
    defineKnight();
    defineKing();
    defineRook();
    defineBishop();
    defineQueen();
    //loadPieces();
  }

  void definePawn() {
    Piece pawn = Piece(name: "pawn",value: 1);
    pawn.AddAction(MoveAttackAction(piece: pawn, position: const Position(0, 1), type: MoveAttackActionType.MOVE_ONLY));
    pawn.AddAction(MoveAttackAction(piece: pawn, position: const Position(0, 2), type: MoveAttackActionType.MOVE_ONLY, fromStartPosition: true));
    pawn.AddAction(MoveAttackAction(piece: pawn, position: const Position(1, 1), type: MoveAttackActionType.ATTACK_ONLY));
    pawn.AddAction(MoveAttackAction(piece: pawn, position: const Position(-1, 1), type: MoveAttackActionType.ATTACK_ONLY));
    pieces.add(pawn);
  }

  void defineRook() {
    Piece rook = Piece(name: "rook", value: 5);
    for (int i = 1; i < 8; i++) {
      rook.AddAction(MoveAttackAction(piece: rook, position: Position(i, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
      rook.AddAction(MoveAttackAction(piece: rook, position: Position(-i, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
      rook.AddAction(MoveAttackAction(piece: rook, position: Position(0, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      rook.AddAction(MoveAttackAction(piece: rook, position: Position(0, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
    }
    pieces.add(rook);
  }

  void defineBishop() {
    Piece bishop = Piece(name: "bishop", value: 3);
    for (int i = 1; i < 8; i++) {
      bishop.AddAction(MoveAttackAction(piece: bishop, position: Position(i, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      bishop.AddAction(MoveAttackAction(piece: bishop, position: Position(-i, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      bishop.AddAction(MoveAttackAction(piece: bishop, position: Position(i, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      bishop.AddAction(MoveAttackAction(piece: bishop, position: Position(-i, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
    }
    pieces.add(bishop);
  }

  void defineQueen() {
    Piece queen = Piece(name: "queen", value: 9);
    for (int i = 1; i < 8; i++) {
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(i, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(-i, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(0, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(0, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(i, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(-i, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(i, -i), type: MoveAttackActionType.MOVE_OR_ATTACK));
      queen.AddAction(MoveAttackAction(piece: queen, position: Position(-i, i), type: MoveAttackActionType.MOVE_OR_ATTACK));
    }
    pieces.add(queen);
  }

  void defineKnight() {
    Piece knight = Piece(name: "knight", value: 3);
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(1, 2), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(2, 1), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(2, -1), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(1, -2), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(-1, -2), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(-2, -1), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(-2, 1), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    knight.AddAction(MoveAttackAction(piece: knight, position: const Position(-1, 2), type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: true));
    pieces.add(knight);
  }

  void defineKing() {
    Piece king = Piece(name: "king", value: 1);
    king.AddAction(MoveAttackAction(piece: king, position: const Position(1, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(0, 1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(-1, 0), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(0, -1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(1, 1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(1, -1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(-1, 1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(MoveAttackAction(piece: king, position: const Position(-1, -1), type: MoveAttackActionType.MOVE_OR_ATTACK));
    king.AddAction(PathAction(piece: king, position: const Position(-2, 0)));
    king.AddAction(CastleAction(piece: king, position: const Position(2, 0), castledPieceStartingPosition: const Position(7, 7), castledPosition: const Position(4, 7)));
    king.AddAction(CastleAction(piece: king, position: const Position(-3, 0), castledPieceStartingPosition: const Position(0, 7), castledPosition: const Position(3, 7)));
    pieces.add(king);
  }

  Future<void> loadPieces() async {
    //TODO: Load pieces from json
  }

  List<(String,int,List<List<PieceActionType>>)> getPieceData(String json) {
    List<Map<String,dynamic>> pieces = jsonDecode(json);
    List<(String,int,List<List<PieceActionType>>)> pieceData = [];
    for (Map<String,dynamic> piece in pieces) {
      pieceData.add((piece["name"], piece["value"], piece["data"]));
    }
    return pieceData;
  }

  Piece getPiece(String name, int value, List<List<PieceActionType>> pieceData) {
    Piece piece = Piece(name: name, value: value);
    //for all directions 
    List<List<int>> directions = [[0,1],[1,0],[0,-1],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]];
    for (List<int> direction in directions) {
      int x = 0;
      int y = 0;
      for (int i = 1; i < 8; i++) {
        x = 7+direction[0] * i;
        y = 7-direction[1] * i;
        Position position = Position(direction[0] * i, direction[1] * i);
        PieceAction? pieceAction = getPieceAction(pieceData[x][y], position, piece);
        if (pieceAction != null) {
          piece.AddAction(pieceAction);
        }
        else {
          piece.AddAction(PathAction(piece: piece, position: Position(direction[0] * i, direction[1] * i)));
        }
        if (pieceAction?.isUnblockable ?? false) {
          piece.AddAction(PathAction(piece: piece, position: Position(direction[0] * i, direction[1] * i)));
        }
      }
    }
    //Remove unnecesary pathActions
    for (PieceActionGroup group in piece.actionsGroups) {
      for (int i = group.actions.length - 1; i >= 0; i--) {
        PieceAction action = group.actions[i];
        if (action is PathAction) {
          group.actions.removeAt(i);
        }
        else {
          break;
        }
      }
    }

    //The rest of the actions are unblockable
    //Get a list of the unblockable actions
    Map<Position,PieceActionType> unblockableActions = {};
    for (int x = 0; x < 15; x++) {
      for (int y = 0; y < 15; y++) {
        unblockableActions[Position(x, y)] = pieceData[x][y];
      }
    }
    for (List<int> direction in directions) {
      for (int i = 1; i < 8; i++) {
        int x = 7+direction[0] * i;
        int y = 7-direction[1] * i;
        Position position = Position(x, y);
        if (unblockableActions.containsKey(position)) {
          unblockableActions.remove(position);
        }
      }
    }
    //Add the unblockable actions to the piece
    for (MapEntry<Position,PieceActionType> action in unblockableActions.entries) {
      action.value.data["isUnblockable"] = true;
      Position relativePosition = Position(action.key.x - 7, 7 - action.key.y);
      PieceAction? pieceAction = getPieceAction(action.value, relativePosition, piece);
      if (pieceAction != null) {
        piece.AddAction(pieceAction);
      }
    }
    return piece;
  }

  PieceAction? getPieceAction(PieceActionType actiontype, Position position, Piece piece) {
    switch (actiontype.type) {
      case "Move or Attack":
        return MoveAttackAction(piece: piece, position: position, type: MoveAttackActionType.MOVE_OR_ATTACK, isUnblockable: actiontype.data["isUnblockable"] ?? false, fromStartPosition: actiontype.data["fromStartingPosition"] ?? false);
      case "Move only":
        return MoveAttackAction(piece: piece, position: position, type: MoveAttackActionType.MOVE_ONLY, isUnblockable: actiontype.data["isUnblockable"] ?? false, fromStartPosition: actiontype.data["fromStartingPosition"] ?? false);
      case "Attack only":
        return MoveAttackAction(piece: piece, position: position, type: MoveAttackActionType.ATTACK_ONLY, isUnblockable: actiontype.data["isUnblockable"] ?? false, fromStartPosition: actiontype.data["fromStartingPosition"] ?? false);
      case "Ranged Attack":
        return MoveAttackAction(piece: piece, position: position, type: MoveAttackActionType.ATTACK_ONLY, moveToAttack: false, isUnblockable: actiontype.data["isUnblockable"] ?? false);
      case "Move, Attack or Swap places with ally":
        return SwapAction(piece: piece, position: position);
      case "Push":
        return PushAction(piece: piece, position: position, direction: actiontype.data["direction"], distance: actiontype.data["distance"]);
      case "Castle":
        if (actiontype.data.containsKey("isUnblockable")) {
          return null;
        }
        return CastleAction(piece: piece, position: position, castledPieceStartingPosition: actiontype.data["castledPieceStartingPosition"] ?? Position(0, 0), castledPosition: actiontype.data["castledPosition"] ?? Position(0, 0));
      case "":
        return null;
      default:
        throw Exception("Action type not found");
    }

  }
}

