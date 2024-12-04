import 'package:flutter/material.dart';

import '../Pieces/Actions/PieceActionType.dart';

class PieceActionTypeModel extends ChangeNotifier {
  PieceActionType? selectedActionType;

  PieceActionTypeModel() {
    selectedActionType = PieceActionType(type: "", data: {});
  }

  void setSelectedActionType(String? value) {
    selectedActionType?.type = value ?? "";
    notifyListeners();
  }

  void setData(Map<String, dynamic> value) {
    print(value);
    selectedActionType?.data = value;
    notifyListeners();
  }
}
