// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'Actions/PieceAction.dart';
import 'Actions/PieceActionGroup.dart';
import 'Board.dart';

enum PieceColor {
  white,
  black
}

class Position {
  final int x;
  final int y;
  const Position(this.x, this.y);
  const Position.zero() : x = 0, y = 0;

  @override
  String toString() {
    return "($x, $y)";
  }

  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  bool operator ==(Object other) {
    if (other is Position) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Piece {
  String name;
  Map<PieceColor, String> imagePaths;
  PieceColor color;
  Position position;
  Position startPosition = Position(0, 0);
  List<PieceActionGroup> actionsGroups = [];
  int value;

  Piece.copy(Piece piece) : this(
    name: piece.name,
    value: piece.value,
    color: piece.color,
    position: Position(piece.position.x, piece.position.y),
    imagePaths: piece.imagePaths,
    actionsGroups: (() {
      List<PieceActionGroup> groups = [];
      for (PieceActionGroup group in piece.actionsGroups) {
        PieceActionGroup newGroup = PieceActionGroup(direction: group.direction.toList());
        for (PieceAction action in group.actions) {
          newGroup.actions.add(action.copy());
        }
        groups.add(newGroup);
      }
      return groups;
    })(),
  );

  Piece({
    required this.name,
    required this.value,
    this.color = PieceColor.white,
    this.position = const Position.zero(),
    this.imagePaths = const {},
    List<PieceActionGroup>? actionsGroups,
  }) {
    startPosition = position;
    this.actionsGroups = actionsGroups ?? [];
  }

  List<PieceAction> GetPosibleActions(Position position, Board board, {bool forCheck = false}) {
    List<PieceAction> actions = [];
    
    for (PieceActionGroup group in actionsGroups) {
      actions.addAll(group.GetPosibleActions(board, position, forCheck: forCheck));
    }

    return actions;
  }

  List<PieceAction> GetActions(Position position, Board board) {
    List<PieceAction> actions = [];
    for (PieceActionGroup group in actionsGroups) {
      actions.addAll(group.actions);
    }
    return actions;
  }

  List<PieceAction> GetInvalidActions(Board board) {
    List<PieceAction> actions = [];
    
    for (PieceActionGroup group in actionsGroups) {
      actions.addAll(group.GetInvalidActions(board, position));
    }

    return actions;
  }

  PieceAction? getAction(Position pos) {
    for (PieceActionGroup group in actionsGroups) {
      for (PieceAction action in group.actions) {
        if (action.getAbsolutePosition() == pos) {
          return action;
        }
      }
    }
    return null;
  }

  void AddAction(PieceAction action) {
    //Deterimine the direction
    Position relativePosition = action.relativePosition;
    List<int> direction = [];
    if (action.isUnblockable) {
      direction = [];
    }
    else if (relativePosition.x == 0) {
      if (relativePosition.y == 0) {
        throw Exception("Invalid action Position");
      }
      else if (relativePosition.y > 0) {
        direction = [0, 1];
      }
      else {
        direction = [0, -1];
      }
    }
    else if (relativePosition.y == 0) {
      if (relativePosition.x > 0) {
        direction = [1, 0];
      }
      else {
        direction = [-1, 0];
      }
    }
    else if (relativePosition.x.abs() == relativePosition.y.abs()) {
      if (relativePosition.x > 0) {
        if (relativePosition.y > 0) {
          direction = [1, 1];
        }
        else {
          direction = [1, -1];
        }
      }
      else {
        if (relativePosition.y > 0) {
          direction = [-1, 1];
        }
        else {
          direction = [-1, -1];
        }
      }
    }
    //Get The action group with that direction or create a new one
    PieceActionGroup? group;
    for (PieceActionGroup g in actionsGroups) {
      if (g.direction.length == direction.length) {
        bool match = true;
        for (int i = 0; i < direction.length; i++) {
          if (g.direction[i] != direction[i]) {
            match = false;
            break;
          }
        }
        if (match) {
          group = g;
          break;
        }
      }
    }
    if (group == null) {
      group = PieceActionGroup(direction: direction);
      actionsGroups.add(group);
      group.actions.add(action);
      return;
    }
    for (PieceAction a in group.actions) {
      if (a.relativePosition == relativePosition) {
        throw Exception("Duplicate action position in direction ${direction.toString()} for position ${relativePosition.toString()}");
      }
    }
    if (direction.isEmpty) {
      if (!action.isUnblockable) {
        throw Exception("Can't add a blockable action to an unblockable action group ");
      }
      group.actions.add(action);
      return;
    }
    //Get the index of the action([0,3]->2,[-3,0]->2,[-3,-3]->2)
    int index = max(relativePosition.x.abs(), relativePosition.y.abs()) -1;
    //Check if the he index is greater than the group size
    if (index == group.actions.length) {
      group.actions.add(action);
    }
    else {
      throw Exception("Invalid action index, with position ${relativePosition.toString()}	");
    }
  }

  Image getImage({PieceColor? color}) {
    //if image not found
    String url = imagePaths[color ?? this.color] ?? "assets/images/pieces/${color?.name ?? this.color.name}-$name.png";
    if (File(url).existsSync()) {
      return Image.file(File(url));
    }
    return Image.asset("assets/images/pieces/${color?.name ?? this.color.name}-unknownPiece.png");
  }
}

