import 'Player.dart';
import 'Piece.dart';
import 'PieceList.dart';
import 'Board.dart';
import 'Actions/PieceActionGroup.dart';
import 'Actions/PieceAction.dart';

class GameManager {
  static GameManager? instance;
  late Board board;
  late List<Player> players;
  late int currentPlayer;
  late PieceList pieceList;
  int turn = 0;

  GameManager() {
    pieceList = PieceList.getInstance();
    players = [];
    currentPlayer = 0;
  }

  static void SetUpGame(Board initialBoard) {
    instance = getInstance();
    instance!.players = [];
    for (int i = 0; i < initialBoard.players.length; i++) {
      instance!.players.add(Player(initialBoard.players[i].color));
    }
    instance!.board = Board(instance!.players);
    for (int i =0; i < 8; i++) {
      for (int j =0; j < 8; j++) {
        Piece? p = initialBoard.GetPieceAt(Position(i, j));
        if (p != null) {
          Player pl = instance!.players.firstWhere((player) => player.color == p.color);
          pl.pieces.add(p);
          instance!.board.SetPieceAt(Position(i, j), p);
          p.position = Position(i, j);	
          p.startPosition = p.position;
        }
      }
    }
    instance!.currentPlayer = 0;
    instance!.turn = 0;
    for(Player player in instance!.players) {
      for(Piece piece in player.pieces) {
        for(PieceActionGroup group in piece.actionsGroups) {
          for(PieceAction action in group.actions) {
            action.init();
          }
        }
      }
    }
  }

  static GameManager getInstance() {
    instance ??= GameManager();
    return instance!;
  }

  void PopulateBoard() {
    void AddPiece(String name, Position position,int player, PieceColor color) {
      Piece p = PieceList.getByName(name, color: color, position: position);
      players[player].pieces.add(p);
      board.SetPieceAt(position, p);
    }

    //White
    for (int i = 0; i < 8; i++) {
      AddPiece("pawn", Position(i, 6), 0, PieceColor.white);
    }
    AddPiece("king", const Position(4, 7), 0, PieceColor.white);
    AddPiece("rook", const Position(0, 7), 0, PieceColor.white);
    AddPiece("rook", const Position(7, 7), 0, PieceColor.white);
    AddPiece("knight", const Position(1, 7), 0, PieceColor.white);
    AddPiece("knight", const Position(6, 7), 0, PieceColor.white);
    AddPiece("bishop", const Position(2, 7), 0, PieceColor.white);
    AddPiece("bishop", const Position(5, 7), 0, PieceColor.white);
    AddPiece("queen", const Position(3, 7), 0, PieceColor.white);

    //Black
    for (int i = 0; i < 8; i++) {
      AddPiece("pawn", Position(i, 1), 1, PieceColor.black);
    }
    AddPiece("king", const Position(4, 0), 1, PieceColor.black);
    AddPiece("rook", const Position(0, 0), 1, PieceColor.black);
    AddPiece("rook", const Position(7, 0), 1, PieceColor.black);
    AddPiece("knight", const Position(1, 0), 1, PieceColor.black);
    AddPiece("knight", const Position(6, 0), 1, PieceColor.black);
    AddPiece("bishop", const Position(2, 0), 1, PieceColor.black);
    AddPiece("bishop", const Position(5, 0), 1, PieceColor.black);
    AddPiece("queen", const Position(3, 0), 1, PieceColor.black);
  }

  Map<Piece, List<PieceAction>> GetAllPosibleActions(PieceColor color,Board board, {bool forCheck = false}) {
    List<Piece> pieces = players.where((player) => player.color == color).expand((player) => player.pieces).toList();
    Map<Piece, List<PieceAction>> actions = {};
    for (Piece piece in pieces) {
      actions[piece] = piece.GetPosibleActions(piece.position, board, forCheck: forCheck);
    }
    return actions;
  }

  void ExecuteAction(PieceAction action) {
    action.action(board);
    turn++;
    currentPlayer = (currentPlayer + 1) % players.length;
    Piece? king = players[currentPlayer].pieces.where((piece) => piece.name == "king").firstOrNull;
    if (king == null) {
      Lose(players[currentPlayer].color);
      return;
    }
  }

  void Lose(PieceColor color) {
    print("Player ${color} loses");
  }
}