// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PieceSelector.dart';
import 'StartingBoard.dart';
import '../../Models/InitialBoardModel.dart';
import '../../Pieces/Board.dart';
import '../../Pieces/Piece.dart';
import '../../Pieces/Player.dart';

class BoardEditorScene extends StatelessWidget {

  BoardEditorScene({super.key});
  Board initialBoard = Board([Player(PieceColor.white), Player(PieceColor.black)]);

  @override
  Widget build(BuildContext context) {
    final initialBoardModel = Provider.of<InitialBoardModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Board Editor"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StartingBoard(initialBoard: initialBoard),
          SizedBox(width: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PieceSelector(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  //TODO: Go to GameScene
                  initialBoardModel.SetBoard(initialBoard);
                  Navigator.pushNamed(context, "/game");
                },
                child: Text("Play"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
