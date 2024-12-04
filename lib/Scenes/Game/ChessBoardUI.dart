import 'package:flutter/material.dart';

import '../../Pieces/Piece.dart';
import '../../Pieces/Actions/PieceAction.dart';
import '../../Pieces/GameManager.dart';
import '../PieceActionsViewer.dart';
import '../LineOverlay.dart';

class ChessBoardUI extends StatefulWidget {
  ChessBoardUI({super.key});
  final GameManager gameManager = GameManager.getInstance();
  final double spaceSize = 500/8;
  @override
  State<ChessBoardUI> createState() => ChessBoardUIState();
}

class ChessBoardUIState extends State<ChessBoardUI> {

  List<PieceAction> validActions = [];
  List<PieceAction> invalidActions = [];
  Piece? hoveredPiece;
  bool isDragging = false;

  void setActions(int x, int y, bool isDragging) {
    setState(() {
      this.isDragging = isDragging;
      Piece p = widget.gameManager.board.GetPieceAt(Position(x, y))!;
      hoveredPiece = p;
      validActions = p.GetPosibleActions(p.position, widget.gameManager.board);
      invalidActions = p.GetInvalidActions(widget.gameManager.board);
    });
  }

  void onDragAccept(DragTargetDetails<Piece> details, int x, int y) {
    setState(() {
      PieceAction? action = details.data.getAction(Position(x, y));

      if (action != null && validActions.contains(action)) {
        widget.gameManager.ExecuteAction(action);
      }
    });
  }

  List<Line> getLines() {
    List<Piece> checkers = widget.gameManager.board.IsCheck(PieceColor.values[widget.gameManager.currentPlayer]);
    if (checkers.isNotEmpty) {
      Piece? king = widget.gameManager.players[widget.gameManager.currentPlayer].pieces.where((piece) => piece.name == "king").firstOrNull;
      if (king != null) {
        Position kingPos = king.position;
        Offset kingOffset = Offset((kingPos.x + 0.5) * widget.spaceSize, (kingPos.y + 0.5) * widget.spaceSize);//+0.5 to center the anchor of the line in the center of the square
        List<Line> lines = [];
        for (Piece checker in checkers) {
          Position checkerPos = checker.position;
          Offset checkerOffset = Offset((checkerPos.x + 0.5) * widget.spaceSize, (checkerPos.y + 0.5) * widget.spaceSize);
          lines.add(Line(checkerOffset, kingOffset, color: const Color.fromARGB(155, 255, 0, 0), strokeWidth: 5));
        }
        return lines;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: widget.gameManager.currentPlayer == 0 ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "${PieceColor.values[widget.gameManager.currentPlayer].name} to move",
            style: TextStyle(
              color: widget.gameManager.currentPlayer == 0 ? Colors.white : Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PieceActionsViewer(piece: hoveredPiece),
            LineOverlay(
              lines: getLines(),
              height: widget.spaceSize * 8,
              width: widget.spaceSize * 8,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemCount: 64,
                itemBuilder: (context, index) {
                  return DragTarget<Piece>(
                    onAcceptWithDetails: (details) {
                      onDragAccept(details, index % 8, index ~/ 8);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          color: ((index % 8) % 2 == (index ~/ 8) % 2) ? Colors.white : Color.fromARGB(255, 175, 175, 175),
                          border: (() {
                            if (hoveredPiece == null) {
                              return Border.all(color: Colors.transparent, width: 0);
                            }
                            Color borderColor = hoveredPiece!.getAction(Position(index % 8, index ~/ 8))?.getActionColor() ?? Colors.transparent;
                            PieceAction? validPieceAction;
                            try {
                              validPieceAction = validActions.firstWhere((action) => action.getAbsolutePosition() == Position(index % 8, index ~/ 8));
                            }
                            catch (e) {}
                            PieceAction? invalidPieceAction;
                            try {
                              invalidPieceAction = invalidActions.firstWhere((action) => action.getAbsolutePosition() == Position(index % 8, index ~/ 8));
                            }
                            catch (e) {}

                            double w = 1;
                            if (validPieceAction != null) {
                              if (isDragging) {
                                w = 15;
                              }
                              else {
                                w = 10;
                              }
                            }
                            if (invalidPieceAction != null) {
                              if (isDragging) {
                                w = 2;
                              }
                              else {
                                w = 4;
                              }
                            }
                            return Border.all(color: borderColor, width: w);
                          })(),
                        ),
                        child: (() {
                          Piece? p = widget.gameManager.board.GetPieceAt(Position(index % 8, index ~/ 8));
                          if (p != null) {
                            if (p.color == PieceColor.values[widget.gameManager.currentPlayer]) {
                              return Draggable(
                                feedback: Container(child: Text("${index % 8}, ${index ~/ 8}")),
                                data: p,
                                onDragStarted: () {
                                  setState(() {
                                    isDragging = true;
                                  });
                                },
                                onDragEnd: (details) {
                                  setState(() {
                                    isDragging = false;
                                  });
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (event) {
                                    if(!isDragging) {
                                      setActions(index % 8, index ~/ 8, false);
                                    }
                                  },
                                  onExit: (event) {
                                    setState(() {
                                      if (!isDragging) {
                                        validActions = [];
                                        invalidActions = [];
                                        hoveredPiece = null;
                                      }
                                    });
                                  },
                                  child: widget.gameManager.board.getImageOfPieceAt(index % 8, index ~/ 8),
                                ), 
                              );
                            }
                            else {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (event) {
                                  if(!isDragging) {
                                    setActions(index % 8, index ~/ 8, false);
                                  }
                                },
                                onExit: (event) {
                                  setState(() {
                                    if(!isDragging) {
                                      validActions = [];
                                      invalidActions = [];
                                      hoveredPiece = null;
                                    }
                                  });
                                },
                                child: widget.gameManager.board.getImageOfPieceAt(index % 8, index ~/ 8),
                              );
                            }
                          }
                          return Container();
                        })(),
                      );
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

