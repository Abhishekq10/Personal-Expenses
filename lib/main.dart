import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'package:personal_expenses/widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main(){ 
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, 
  //    DeviceOrientation.portraitDown]);
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            button: TextStyle(
              color: Colors.white70,
            )
        ), // TextTheme
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't2', title: 'Groceries', amount: 16.53, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
          ),
          );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
      );

      setState(() {
       _userTransactions.add(newTx); 
      });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
      return NewTransaction(_addNewTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS 
    ? CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses'
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add_circled),
            onTap: () => _startAddNewTransaction(context)
          )
        ]),
    )
    : AppBar(  
      title: Text('Personal Expenses',),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
      onPressed: () => _startAddNewTransaction(context),
        )
        ],
      );
      final txListWidget = Container(
                height: (
                  mediaQuery.size.height - 
                  appBar.preferredSize.height - 
                  mediaQuery.padding.top) * 0.68,
                child: TransactionList(_userTransactions, _deleteTransaction)
                );

    final pageBody = SafeArea(child:SingleChildScrollView(
              child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("Show Chart", 
                  style: Theme.of(context).textTheme.title,
                ),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, 
                  onChanged: (val){
                    setState(() {
                      _showChart = val;
                    });
                  },
                  )
              ],
              ),
              if (!isLandscape)Container(
                height: (
                  mediaQuery.size.height - 
                  appBar.preferredSize.height - 
                  mediaQuery.padding.top) * 0.32,
                child: Chart(_recentTransactions)),
              if (!isLandscape) txListWidget,
              if (isLandscape) _showChart 
              ?Container(
                height: (
                  mediaQuery.size.height - 
                  appBar.preferredSize.height - 
                  mediaQuery.padding.top) * 0.32,
                child: Chart(_recentTransactions)) 
              
              : txListWidget
            ],
          ),
        ),
      ),
      );
    return Platform.isIOS 
      ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
      ) 
      : Scaffold(
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
      ? Container()
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
      body: pageBody,
    );
  }
}
