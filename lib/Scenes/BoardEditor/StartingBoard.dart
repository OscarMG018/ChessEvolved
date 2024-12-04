import 'package:flutter/material.dart';

import '../../Pieces/Board.dart';
import '../../Pieces/Piece.dart';
import '../../Pieces/PieceList.dart';

class StartingBoard extends StatefulWidget {

  const StartingBoard({super.key, required this.initialBoard});
  final Board initialBoard;

  @override
  State<StatefulWidget> createState() => _StartingBoardState();
}

class _StartingBoardState extends State<StartingBoard> {
  late Board board;
  bool movingPiece = false;

  @override
  void initState() {
    super.initState();
    board = widget.initialBoard;
    
    board.SetPieceAt(Position(0, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(0, 1)));
    board.SetPieceAt(Position(1, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(1, 1)));
    board.SetPieceAt(Position(2, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(2, 1)));
    board.SetPieceAt(Position(3, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(3, 1)));
    board.SetPieceAt(Position(4, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(4, 1)));
    board.SetPieceAt(Position(5, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(5, 1)));
    board.SetPieceAt(Position(6, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(6, 1)));
    board.SetPieceAt(Position(7, 1), PieceList.getByName("pawn", color: PieceColor.black, position: Position(7, 1)));
    board.SetPieceAt(Position(0, 0), PieceList.getByName("rook", color: PieceColor.black, position: Position(0, 0)));
    board.SetPieceAt(Position(7, 0), PieceList.getByName("rook", color: PieceColor.black, position: Position(7, 0)));
    board.SetPieceAt(Position(1, 0), PieceList.getByName("knight", color: PieceColor.black, position: Position(1, 0)));
    board.SetPieceAt(Position(6, 0), PieceList.getByName("knight", color: PieceColor.black, position: Position(6, 0)));
    board.SetPieceAt(Position(2, 0), PieceList.getByName("bishop", color: PieceColor.black, position: Position(2, 0)));
    board.SetPieceAt(Position(5, 0), PieceList.getByName("bishop", color: PieceColor.black, position: Position(5, 0)));
    board.SetPieceAt(Position(3, 0), PieceList.getByName("queen", color: PieceColor.black, position: Position(3, 0)));
    board.SetPieceAt(Position(4, 0), PieceList.getByName("king", color: PieceColor.black, position: Position(4, 0)));

    board.SetPieceAt(Position(0, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(0, 6)));
    board.SetPieceAt(Position(1, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(1, 6)));
    board.SetPieceAt(Position(2, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(2, 6)));
    board.SetPieceAt(Position(3, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(3, 6)));
    board.SetPieceAt(Position(4, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(4, 6)));
    board.SetPieceAt(Position(5, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(5, 6)));
    board.SetPieceAt(Position(6, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(6, 6)));
    board.SetPieceAt(Position(7, 6), PieceList.getByName("pawn", color: PieceColor.white, position: Position(7, 6)));
    board.SetPieceAt(Position(0, 7), PieceList.getByName("rook", color: PieceColor.white, position: Position(0, 7)));
    board.SetPieceAt(Position(7, 7), PieceList.getByName("rook", color: PieceColor.white, position: Position(7, 7)));
    board.SetPieceAt(Position(1, 7), PieceList.getByName("knight", color: PieceColor.white, position: Position(1, 7)));
    board.SetPieceAt(Position(6, 7), PieceList.getByName("knight", color: PieceColor.white, position: Position(6, 7)));
    board.SetPieceAt(Position(2, 7), PieceList.getByName("bishop", color: PieceColor.white, position: Position(2, 7)));
    board.SetPieceAt(Position(5, 7), PieceList.getByName("bishop", color: PieceColor.white, position: Position(5, 7)));
    board.SetPieceAt(Position(3, 7), PieceList.getByName("queen", color: PieceColor.white, position: Position(3, 7)));
    board.SetPieceAt(Position(4, 7), PieceList.getByName("king", color: PieceColor.white, position: Position(4, 7)));
  }

  void SetPiece(Position pos,Piece? piece) {
    setState(() {
      //player
      board.SetPieceAt(pos, piece);
      piece?.position = Position(pos.x, pos.y);
    });
  }

  void SwapPieces(Position pos1,Position pos2) {
    setState(() {
      board.Swap(pos1, pos2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, index) {
          return Container(
            color: ((index % 8) % 2 == (index ~/ 8) % 2) ? Colors.white : Color.fromARGB(255, 175, 175, 175),
            child: DragTarget<Piece Function()>(
              onAcceptWithDetails: (details) {
                setState(() {
                  Piece piece = details.data();
                  if (movingPiece) {
                    SwapPieces(Position(index % 8, index ~/ 8),piece.position);
                  }
                  else {
                    SetPiece(Position(index % 8, index ~/ 8), piece);
                  }
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  child: (() {
                    if (board.GetPieceAt(Position(index % 8, index ~/ 8)) == null) {
                      return Container();
                    }
                    else {
                      return Draggable(
                        data: () => board.GetPieceAt(Position(index % 8, index ~/ 8))!,
                        feedback: Container(
                          width: 500/8,//grid size / 8
                          height: 500/8,
                          child: board.getImageOfPieceAt(index %8, index ~/ 8)!,
                        ),
                        onDragStarted: () => {
                          movingPiece = true,
                        },
                        onDragEnd: (details) => {movingPiece = false,},
                        childWhenDragging: Container(),
                        child: GestureDetector(
                          onSecondaryTapDown: (details) => {
                            if (board.GetPieceAt(Position(index %8, index ~/ 8))!.name != "king") {
                              SetPiece(Position(index %8, index ~/ 8),null),
                            }
                          },
                          child: board.getImageOfPieceAt(index %8, index ~/ 8)!,
                        ),
                      );
                    }
                  })(),
                );
              },
            ),
          );
        }),
    );
  }
  
}

