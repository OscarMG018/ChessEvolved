class PieceActionType {
  String type;
  Map<String, dynamic> data;

  @override
  String toString() {
    return "PieceActionType(type: $type, data: $data)";
  }

  PieceActionType({required this.type, required this.data});
}
