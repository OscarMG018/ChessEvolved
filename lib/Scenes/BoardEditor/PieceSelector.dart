import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Pieces/PieceList.dart';
import '../../Pieces/Piece.dart';
import '../../Models/PieceModel.dart';


class PieceSelector extends StatefulWidget {
  
  List<Piece> pieceTypes = PieceList.getPieces();

  @override
  State<PieceSelector> createState() => _PieceSelectorState();
}

class _PieceSelectorState extends State<PieceSelector> {

  PieceColor color = PieceColor.white;
  final Color blackColor = const Color.fromARGB(255, 43, 43, 43);
  final Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    //TODO: Add a button to change the color of the pieces
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              color = color == PieceColor.white ? PieceColor.black : PieceColor.white;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color == PieceColor.white ? whiteColor : blackColor,
          ),
          child: Text(color == PieceColor.white ? "Black" : "White", style: TextStyle(color: color == PieceColor.white ? blackColor : whiteColor),),
        ),
        SizedBox(height: 10),
        Container(
          height: 450+20,
          width: 500/8*3+20,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: color == PieceColor.white ? whiteColor : blackColor, width:5),
            color: color == PieceColor.white ? blackColor : whiteColor,
          ),
          child: Consumer<PieceModel>(
            builder: (context, pieceModel, child) {
              widget.pieceTypes = pieceModel.getPieceList();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: widget.pieceTypes.length+1,
                itemBuilder: (context, index) {
                  if (index == widget.pieceTypes.length) {
                    return IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/pieceEditor");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color == PieceColor.white ? whiteColor : blackColor,
                      ),
                      icon: Icon(Icons.add, color: color == PieceColor.white ? blackColor : whiteColor),
                    );
                  }
                  return Draggable(
                    data: () => PieceList.getByName(widget.pieceTypes[index].name, color: color, position: Position(0, 0)),
                    feedback: Container(
                      width: 500/8,
                      height: 500/8,
                      child: widget.pieceTypes[index].getImage(color: color),
                    ),
                    child: widget.pieceTypes[index].getImage(color: color),
                    );
                  },
              );
            },
          ),
        ),
      ],
    );
  }
}