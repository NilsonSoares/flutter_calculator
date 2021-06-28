import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final backspace = "\u{21D0}";
  final divider = "\u{00F7}";

  final options = [
    "AC",
    "\u{21D0}",// backspace "<="
    "%",
    "\u{00F7}",// divider "/"
    "7",
    "8",
    "9",
    "x",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "="
  ];

  var inputOperation = "";
  var currentInput = "";
  var value;
  var operationList = [];
  var result = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 24, bottom: 36, left: 24),
                    child: Text(
                      inputOperation,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(16),
                  crossAxisCount: 4,
                  itemCount: 19,
                  itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: () {
                        final value = options[index];
                        inputOperation += value;

                        if(value == "+" || value == "-" || value == "x" || value == divider || value == "%"){
                          operationList.add(currentInput);
                          currentInput = "";
                          operationList.add(value);
                        }
                        else if(value == "="){
                          operationList.add(currentInput);
                          result = double.parse(operationList[0]);

                          for(var i = 1; i < operationList.length; i++){
                            if(operationList[i] == "=") {
                              i = operationList.length;
                            }
                            else if(operationList[i] == "+"){
                              result += double.parse(operationList[i+1]);
                            }
                            else if(operationList[i] == "-"){
                              result -= double.parse(operationList[i+1]);
                            }
                            else if(operationList[i] == "x"){
                              result *= double.parse(operationList[i+1]);
                            }
                            else if(operationList[i] == divider){
                              result /= double.parse(operationList[i+1]);
                            }
                            else if(operationList[i] == "%"){
                              result %= int.parse(operationList[i+1]);
                            }

                          }
                          inputOperation = result.toString();
                          currentInput = result.toString();
                          operationList.clear();
                        }
                        else if(value == "AC"){
                          inputOperation = "";
                          operationList.clear();
                          currentInput = "";
                        }
                        else if(value == backspace){
                          if(inputOperation.length >= 2 && currentInput.length >= 2){
                            inputOperation = inputOperation.substring(0, inputOperation.length-2);
                            currentInput = currentInput.substring(0, currentInput.length-2);                           
                          }
                          else{
                            inputOperation = "";
                            currentInput = "";                         
                          }
                        }
                        else {
                          currentInput += value;
                        }

                      setState(() {

                      });
                    },
                    child: Container(
                        
                        decoration: BoxDecoration(
                          color: index == 18 ? Colors.purple : _backgroundColor(index),
                          shape: index == 18 ? BoxShape.rectangle : BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.elliptical(50, 50))
                        ),
                        child: Center(
                          child: Text(
                            options[index],
                            style: TextStyle(
                                color: _textColor(index),
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        )),
                  ),
                   staggeredTileBuilder: (int index) {
                     if (index == 18) {
                       return StaggeredTile.count(2, 1);
                    }
                   else {
                       return StaggeredTile.count(1, 1);
                     }
                   },
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                )),
          ],
        ),
      ),
    );
  }

  Color _backgroundColor(var index) {

    var colorGray = [3, 7, 11, 15];
    if(colorGray.contains(index) == true){
      return Colors.purple.withAlpha(50);
    }
    else if(index == 19){
      return Colors.purple;
    }
    return Colors.black;
  }

  Color _textColor(var index) {

    var colorAmber = [2, 3, 7, 11, 15];
    if(colorAmber.contains(index) == true){
      return Colors.amber;
    }
    else if(index == 0){
      return Colors.purple;
    }
    else if(index == 1){
      return Colors.red;
    }
    else if(index == 18){
      return Colors.green.shade300;
    }
    return Colors.white;
  }
}
