import 'package:flutter/material.dart';
import 'PieceEditor.dart';
import 'PieceActionSelector.dart';
import 'PieceSaveDialog.dart';


class PieceEditorScene extends StatelessWidget {
  final GlobalKey<PieceEditorState> pieceEditorKey = GlobalKey<PieceEditorState>();

  PieceEditorScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Piece Editor"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PieceEditor(key: pieceEditorKey),
          const SizedBox(width: 20),
          Container(
            width: 350,
            height: 750,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PieceActionSelector(),
                ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return PieceSaveDialog(pieceEditorKey: pieceEditorKey);
                    });
                  },
                  child: const Text("Save Piece"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

