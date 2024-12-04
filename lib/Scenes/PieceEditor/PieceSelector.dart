import 'package:flutter/material.dart';

import '../../Models/PieceActionTypeModel.dart';
import '../../Pieces/Piece.dart';

class PositionSelector extends StatefulWidget {
  final PieceActionTypeModel model;
  final String dataKey;
  final Map<String, dynamic> data;

  const PositionSelector({super.key, required this.model, required this.dataKey, required this.data});

  @override
  State<PositionSelector> createState() => _PositionSelectorState(model: model, dataKey: dataKey, data: data);
}

class _PositionSelectorState extends State<PositionSelector> {
  Position? selectedPosition;
  final PieceActionTypeModel model;
  final String dataKey;
  final Map<String, dynamic> data;

  _PositionSelectorState({required this.model, required this.dataKey, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      width: 200,
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 8*8,
        itemBuilder: (context, index) {
          final x = index % 8;
          final y = index ~/ 8;
          if (selectedPosition != null && selectedPosition! == Position(x, y)) {
            return Container(
              color: Colors.blue,
            );
          }
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: GestureDetector(
              onTap: () {
                  setState(() {
                  selectedPosition = Position(x, y);
                  data[dataKey] = Position(x, y);
                  model.setData(data);
                });
              },
            )
          );
        },
      ),
    );
  }
}