import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../Models/PieceModel.dart';
import '../../Pieces/Piece.dart';
import '../../Pieces/PieceList.dart';
import '../../Pieces/Actions/PieceActionType.dart';
import '../../Scenes/PieceEditor/PieceEditor.dart';


class PieceSaveDialog extends StatefulWidget {
  final GlobalKey<PieceEditorState> pieceEditorKey;

  const PieceSaveDialog({super.key, required this.pieceEditorKey});

  @override
  State<PieceSaveDialog> createState() => _PieceSaveDialogState();
}

class _PieceSaveDialogState extends State<PieceSaveDialog> {
  String name = "";
  int pieceValue = 0;
  Map<PieceColor, String> imagePaths = {};

  void NotifyPiece(String name, int pieceValue, Map<PieceColor, String> imagePaths, List<List<PieceActionType>> pieceData, BuildContext context) {
    Piece piece = PieceList.getInstance().getPiece(name, pieceValue, pieceData);
    piece.imagePaths = imagePaths;
    PieceList.getInstance().pieces.add(piece);
    Provider.of<PieceModel>(context, listen: false).reload();
    //TODO: save PieceList to file
  }

  Future<String?> selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Save Piece"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Value",
              ),
              onChanged: (value) {
                pieceValue = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Image: ${imagePaths[PieceColor.black] ?? "None"}"),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    selectImage().then((value) {
                      setState(() {
                        if (value != null) {
                          imagePaths[PieceColor.black] = value;
                        }
                      });
                    });
                  }, 
                  child: const Text("Select image for black")
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Image: ${imagePaths[PieceColor.white] ?? "None"}"),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    selectImage().then((value) {
                      setState(() {
                        if (value != null) {
                          imagePaths[PieceColor.white] = value;
                        }
                      });
                    });
                  }, 
                  child: const Text("Select image for white")
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text("Cancel")
        ),
        TextButton(
          onPressed: () {
            List<List<PieceActionType>> pieceData = widget.pieceEditorKey.currentState!.selectedActionTypes;
            NotifyPiece(name, pieceValue, imagePaths, pieceData, context);
            Navigator.pop(context);
            Navigator.pop(context);
          }, 
          child: const Text("Save")
        ),
      ],
    );
  }
}

