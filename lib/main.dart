import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/PieceModel.dart';
import 'Models/InitialBoardModel.dart';
import 'Models/PieceActionTypeModel.dart';
import 'Scenes/BoardEditor/BoardEditorScene.dart';
import 'Scenes/Game/GameScene.dart';
import 'Scenes/PieceEditor/PieceEditorScene.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InitialBoardModel()),
        ChangeNotifierProvider(create: (context) => PieceActionTypeModel()),
        ChangeNotifierProvider(create: (context) => PieceModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BoardEditorScene(),
      routes: {
        "/game": (context) => GameScene(),
        "/boardEditor": (context) => BoardEditorScene(),
        "/pieceEditor": (context) => PieceEditorScene(),
      },
    );
  }
}

