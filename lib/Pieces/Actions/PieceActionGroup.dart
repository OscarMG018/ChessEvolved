import 'PieceAction.dart';

import '../Board.dart';
import '../Piece.dart';
class PieceActionGroup {
  List<PieceAction> actions = [];//Max Size of 8;
  List<int> direction;

  PieceActionGroup.copy(PieceActionGroup group) : this(
    actions: group.actions.map((action) => action.copy()).toList(),
    direction: group.direction,
  );

  PieceActionGroup({List<PieceAction>? actions, required this.direction}) {
    actions = actions ?? [];
  }

   List<PieceAction> GetPosibleActions(Board board, Position position, {bool forCheck = false}) {
    List<PieceAction> PosobleActions = [];
    if (direction.length == 0 ) {
      for (PieceAction action in actions) {
        if (forCheck && (action.skipInCheck || !action.offersive)) {
          continue;
        }
        (bool, bool) isValid = action.IsValidAction(board);
        if (isValid.$1) {
          PosobleActions.add(action);
        }
      }
      return PosobleActions;
    }
    for (int i = 0; i < actions.length; i++) {
      Position newPos = actions[i].getAbsolutePosition();
      if (forCheck && (actions[i].skipInCheck || !actions[i].offersive)) {
        continue;
      }
      if (!board.IsInBoard(newPos)) {
        break;
      }
      (bool, bool) isValid = actions[i].IsValidAction(board);
      if (isValid.$1) {
        PosobleActions.add(actions[i]);
      }
      if (!isValid.$2) {
        break;
      }
    }
    return PosobleActions;
  }
  
  List<PieceAction> GetInvalidActions(Board board, Position position) {
    List<PieceAction> InvalidActions = [];
    if (direction.length == 0 ) {
      for (PieceAction action in actions) {
        (bool, bool) isValid = action.IsValidAction(board);
        if (!isValid.$1) {
          InvalidActions.add(action);
        }
      }
      return InvalidActions;
    }
    for (int i = 0; i < actions.length; i++) {
      Position newPos = actions[i].getAbsolutePosition();
      if (!board.IsInBoard(newPos)) {
        break;
      }
      (bool, bool) isValid = actions[i].IsValidAction(board);
      if (!isValid.$1) {
        InvalidActions.add(actions[i]);
      }
      if (!isValid.$2) {
        InvalidActions.addAll(actions.getRange(i+1, actions.length));
        if (i < actions.length && !isValid.$1) {
          InvalidActions.add(actions[i]);
        }
        break;
      }
    }
    return InvalidActions;
  }
}