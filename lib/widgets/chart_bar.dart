import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

final String label;
final double spendingAmount;
final double spendingPctOfTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints){
      return Column(
      children: <Widget>[
      Container(
        height: constraints.maxHeight * 0.15,
        child: FittedBox(
          child: Text('\$ ${spendingAmount.toStringAsFixed(0)}'),
          ),
      ),
      SizedBox(height: constraints.maxHeight * 0.05,),
      Container(
        height: constraints.maxHeight * 0.6 ,
        width: 25,
        child: Stack(children: <Widget>[
          Container(decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 1.0),
          color: Color.fromRGBO(220, 220, 220, 1),
          borderRadius: BorderRadius.circular(4),
          ),
          ),
          FractionallySizedBox(heightFactor: spendingPctOfTotal, 
          child: Container(decoration: BoxDecoration(color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.circular(4),),
          ),
          ),
        ],
        ),
      ),
      SizedBox(
        height : constraints.maxHeight * 0.05,
      ),
      Container(height: constraints.maxHeight * 0.15,
        child: FittedBox(child: Text(label)))
      ]
      );
    },); 
  }
}