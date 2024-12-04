import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/PieceActionTypeModel.dart';
import '../../Pieces/Actions/PieceActionType.dart';
import '../../Pieces/PieceList.dart';
import '../../Pieces/Piece.dart';

class PieceEditor extends StatefulWidget {
  const PieceEditor({super.key});

  @override
  State<PieceEditor> createState() => PieceEditorState();
}

class PieceEditorState extends State<PieceEditor> {

  List<List<PieceActionType>> selectedActionTypes = List.generate(15, (_) => List.generate(15, (_) => PieceActionType(type: "", data: {})));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50*15,
      height: 50*15,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 15,
        ),
        itemCount: 15 * 15,
        itemBuilder: (context, index) {
          if (index == 15*7+7) {
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
          final x = index % 15;
          final y = index ~/ 15;
          return Container(
            decoration: BoxDecoration(
              color: (() {
                return PieceList.getInstance().getPieceAction(selectedActionTypes[x][y], Position(0, 0), Piece(name: "", value: 0))?.getActionColor() ?? Colors.white;
              })(),
              border: Border.all(color: Colors.grey[800]!, width: 0),
            ),
            width: 50,
            height: 50,
            child: Consumer<PieceActionTypeModel>(
              builder: (context, model, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      print(model.selectedActionType?.data);
                      Map<String, dynamic> data = Map.from(model.selectedActionType?.data ?? {});
                      selectedActionTypes[x][y] = PieceActionType(
                        type: model.selectedActionType?.type ?? "", 
                        data: data
                        );
                    });
                  },
                  onSecondaryTap: () {
                    setState(() {
                      selectedActionTypes[x][y] = PieceActionType(type: "", data: {});
                    });
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

