import 'package:flutter/material.dart';
import 'package:chess_evolved/Pieces/Piece.dart';

class PieceActionsViewer extends StatelessWidget {
  const PieceActionsViewer({super.key, required this.piece});
  final Piece? piece;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 500,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          piece?.getImage() ?? Container(),
          Text(
            piece?.name ?? "",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (piece != null)
            Container(
              width: 150,
              height: 150,
              child: GridView.builder(
                itemCount: 15*15,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15),
                itemBuilder: (context, index) {
                  final int y = index ~/ 15;
                  final int x = index % 15;
                  Position piecePosition = piece!.position;
                  if (y == 7 && x == 7) {
                    return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[800]!, width: 0),
                    ),
                    width: 50,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: ((){
                        if (piece!.color == PieceColor.white) {
                          return piece!.getAction(piecePosition + Position(x-7, y-7))?.getActionColor() ?? Colors.transparent;
                        } else {
                          return piece!.getAction(piecePosition + Position(x-7, 7-y))?.getActionColor() ?? Colors.transparent;
                        }
                      })(),
                      border: Border.all(color: Colors.grey[800]!, width: 0),
                    ),
                    width: 50,
                    height: 50,
                  );
                } 
              ),
            ),
            const SizedBox(height: 10),
            Text(
              piece?.value != null ? "Value: ${piece?.value.toString() ?? ""}" : "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}