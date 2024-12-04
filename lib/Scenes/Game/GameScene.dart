import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Pieces/GameManager.dart';
import 'ChessBoardUI.dart';
import '../../Models/InitialBoardModel.dart';

class GameScene extends StatelessWidget {
  late GameManager gameManager;
  
  GameScene({super.key}) {
    gameManager = GameManager.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
      ),
      body: Center(child: Consumer<InitialBoardModel>(builder: (context, initialBoardModel, child) {
        GameManager.SetUpGame(initialBoardModel.board);
        return ChessBoardUI();
      }),),
    );
  }
}

