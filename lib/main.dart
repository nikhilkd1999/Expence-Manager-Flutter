
import 'dart:io';

// import 'package:expence_manager/widgets/new_transaction.dart';
// import 'package:expence_manager/widgets/transaction_list.dart';
import 'package:expence_manager/widgets/chart.dart';
import 'package:expence_manager/widgets/new_transaction.dart';
import 'package:expence_manager/widgets/transaction_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
// import './widgets/user_transactions.dart';



void main() {

//Restrict to vertical mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //       DeviceOrientation.portraitUp,
  //       DeviceOrientation.portraitDown,
  //   ]
  // );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {



    return MaterialApp(title: 'Expence Manager',
    
    theme: ThemeData(
      primarySwatch: Colors.green,

      accentColor: Colors.red,

      errorColor: Colors.red,

      fontFamily: 'Quicksand',
      
      textTheme: ThemeData.light().textTheme.copyWith(
        title: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        button: TextStyle(color: Colors.white),
      ),

      appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
        title: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold
        ),
      ),),


      )
    ,
    
     home: MyHomePage());
  }
}



class MyHomePage extends StatefulWidget {

  
// String titleInput;
// String amountInput;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// final titleController = TextEditingController();

// final amountController = TextEditingController();

final List _userTransactions = <Transaction> [

    // Transaction(id: 't1', title: 'first', amount: 69.99, date: DateTime.now()),
    // Transaction(id: 't2', title: 'second', amount: 4544.99, date: DateTime.now()),
    // Transaction(id: 't3', title: 'third', amount: 989665, date: DateTime.now()),

  ];


  bool _showChart = false;





  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){

    final newTx = Transaction(id: DateTime.now().toString(), title: txTitle, amount: txAmount, date: chosenDate);

    setState(() {
          _userTransactions.add(newTx);
        });
  }


void startAddNewTransaction(BuildContext ctx)
{
  showModalBottomSheet(context: ctx, builder: (_){

    return GestureDetector(
      
      onTap: (){},
      
      child : NewTransaction(_addNewTransaction),
      
      behavior: HitTestBehavior.opaque,
      
      );
  },);
}



  List<Transaction> get _recentTransactions
  {
    return _userTransactions.where((tx) {

      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7),)
      );

    }).toList();
  }

  void _deleteTransaction(String id)
  {
    setState(() {
          
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
        
        });

  }



  @override
  Widget build(BuildContext context) {

  final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
  final appBar = AppBar(
        title: Text('Expence Manager'),
      
      actions: [
        IconButton(icon: Icon(Icons.add), onPressed : () => startAddNewTransaction(context) ),
      ],
      );

      final txListWidget =  Container(
                        
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom) * 0.7,
                        
                        child: TransactionList(_userTransactions,_deleteTransaction));
   
    return Scaffold(
      appBar: appBar,
      
      body: 
      
      
      Container(
        margin: EdgeInsets.all(5),
        child: SingleChildScrollView(

          child: Column(

            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[


              if(isLandScape) Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('Show Chart'),

              Switch(value: _showChart, 
              onChanged: (val)
              {
                setState(() {
                                  _showChart = val;
                                });

              },),
                ],
              ),

              
              if(isLandScape)
              _showChart ?

              Container(
                
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom) * 0.7,
                
                
                
                child: Chart(_recentTransactions),
                
                )
                :  txListWidget ,    // UserTransactions(),


                if(!isLandScape)

                Container(
                
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom) * 0.3,
                
                
                
                child: Chart(_recentTransactions),
                
                ),

                if(!isLandScape)

                txListWidget,


                     


                      
              
            ],
          ),
        ),
      ),
      
                      floatingActionButtonLocation: Platform.isIOS ? Container() : FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () => startAddNewTransaction(context),),
    );
  }
}


