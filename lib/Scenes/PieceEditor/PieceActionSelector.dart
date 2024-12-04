import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/PieceActionTypeModel.dart';
import '../../Pieces/Piece.dart';
import 'PieceSelector.dart';


class PieceActionSelector extends StatefulWidget {
  const PieceActionSelector({super.key});

  final List<String> actionsTypes = const [
    "Move or Attack",
    "Move only",
    "Attack only",
    "Ranged Attack",
    "Move, Attack or Swap places with ally",
    "Push",
    "Castle",
  ];

  @override
  State<PieceActionSelector> createState() => _PieceActionSelectorState();
}

class _PieceActionSelectorState extends State<PieceActionSelector> {
  String? selectedActionType;
  Map<String, dynamic> data = {};

  List<Widget> getDataWidgets(PieceActionTypeModel model) {
    switch (selectedActionType) {
      case "Move or Attack":
      case "Move only":
      case "Attack only":
        return [
          CheckboxListTile(
            title: const Text('Unblockable'),
            value: data["isUnblockable"] ?? false,
            onChanged: (bool? value) {
              setState(() {
                data["isUnblockable"] = value ?? false;
                model.setData(data);
              });
            },
          ),
          CheckboxListTile(
            title: const Text('only from starting position'),
            value: data["fromStartingPosition"] ?? false,
            onChanged: (bool? value) {
              setState(() {
                data["fromStartingPosition"] = value ?? false;
                model.setData(data);
              });
            },
          ),
        ];
      case "Ranged Attack":
        return [
          CheckboxListTile(
            title: const Text('Unblockable'),
            value: data["isUnblockable"] ?? false,
            onChanged: (bool? value) {
              setState(() {
                data["isUnblockable"] = value ?? false;
                model.setData(data);
              });
            },
          ),
        ];
      case "Move, Attack or Swap places with ally":
        return [];
      case "Push":
        String direction = "";
        switch (data["direction"]) {
          case [0, -1]:
            direction = "Down";
          case [0, 1]:
            direction = "Up";
          case [-1, 0]:
            direction = "Left";
          case [1, 0]:
            direction = "Right";
          case [-1, -1]:
            direction = "Down-Left";
          case [1, -1]:
            direction = "Down-Right";
          case [-1, 1]:
            direction = "Up-Left";
          case [1, 1]:
            direction = "Up-Right";
          default:
            direction = "Up";
        }
        return [
          Text("Direction"),
          DropdownButton<String>(
            value: direction,
            items: [
              "Up",
              "Down",
              "Left",
              "Right",
              "Up-Left",
              "Up-Right",
              "Down-Left",
              "Down-Right",
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                switch (value) {
                  case "Up":
                    data["direction"] = [0, 1];
                  case "Down":
                    data["direction"] = [0, -1];
                  case "Left":
                    data["direction"] = [-1, 0];
                  case "Right":
                    data["direction"] = [1, 0];
                  case "Up-Left":
                    data["direction"] = [-1, 1];
                  case "Up-Right":
                    data["direction"] = [1, 1];
                  case "Down-Left":
                    data["direction"] = [-1, -1];
                  case "Down-Right":
                    data["direction"] = [1, -1];
                  default:
                    data["direction"] = [0, 1];
                }
                model.setData(data);
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Distance",
            ),
            onChanged: (value) {
              setState(() {
                data["distance"] = int.tryParse(value) ?? 0;
                model.setData(data);
              });
            },
          ),
        ];
      case "Castle":
        return [
          Text("Castled Piece Starting Position"),
          PositionSelector(model: model, dataKey: "castledPieceStartingPosition", data: data),
          Text("Castled Position"),
          PositionSelector(model: model, dataKey: "castledPosition", data: data),
        ];
      default:
        return [];
    }
  }

  Map<String, dynamic> GetDefaultData(String actionType) {
    switch (actionType) {
      case "Move or Attack":
      case "Move only":
      case "Attack only":
        return {"isUnblockable": false, "fromStartingPosition": false};
      case "Ranged Attack":
        return {"isUnblockable": false};
      case "Move, Attack or Swap places with ally":
        return {};
      case "Push":
        return {"direction": [0, 1], "distance": 1};
      case "Castle":
        return {"castledPieceStartingPosition": Position(0, 0), "castledPosition": Position(0, 0)};
      default:
        return {};
    }
  }

  Widget build(BuildContext context) {
    final model = Provider.of<PieceActionTypeModel>(context);
    return Column(
      children: [
        DropdownButton<String>(
          items: widget.actionsTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              print(value);
              selectedActionType = value;
              data = GetDefaultData(selectedActionType ?? "");
              model.setSelectedActionType(selectedActionType);
              model.setData(data);
            });
          },
          value: selectedActionType,
          hint: const Text('Select an action type'),
        ),
        Container(
          width: 300,
          height: 500,
          child: Column(
            children: getDataWidgets(model),
          ),
        ),
      ],
    );
  }
}

