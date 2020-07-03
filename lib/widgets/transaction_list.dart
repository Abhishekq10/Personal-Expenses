import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.transactions, this.deleteTx);

  final Function deleteTx;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
      ? LayoutBuilder(builder: (ctx, constraints) {
        return Column(
        children: <Widget>[
          Text('No transactions yet', style: Theme.of(context).textTheme.title,),
          SizedBox(
            height: 15,
            ),
          Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset(
              'assets/images/waiting.png',
              fit: BoxFit.contain,))
        ],
      );
      },) : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30, 
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: FittedBox(
                    child: Text('\$ ${transactions[index].amount}')),
                )
              ),
              title: Text(
                transactions[index].title, 
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
              trailing: MediaQuery.of(context).size.width > 480
              ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => deleteTx(transactions[index].id),
              )
              : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTx(transactions[index].id),
              ),
            ),
          );
          // return Card(
          //   child: Row(
          //     children: <Widget>[
          //       Container(
          //         padding: EdgeInsets.all(10),
          //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //         decoration: BoxDecoration(
          //             border: Border.all(
          //           color: Theme.of(context).primaryColorLight,
          //           width: 2,
          //         ),
          //         ),
          //         child: Text(
          //           "\$ ${transactions[index].amount.toStringAsFixed(2)}",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //               color: Theme.of(context).primaryColorDark),
          //         ),
          //       ),
          //       Column(
          //         children: <Widget>[
          //           Text(
          //             transactions[index].title,
          //             style: Theme.of(context).textTheme.title
          //                 //TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //           ),
          //           Text(
          //             DateFormat('EEE, d/M/y').format(transactions[index].date),
          //             style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          //           )
          //         ],
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //       )
          //     ],
          //   ),
          // );
        },
        itemCount: transactions.length,
      ),
    );
  }
}
