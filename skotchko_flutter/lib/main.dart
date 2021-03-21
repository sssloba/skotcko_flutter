import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skotchko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonColor: Colors.blue[100],
        dividerColor: Colors.blue[100],
        canvasColor: Colors.blue[900],
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Skotchko'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _animationValue = 15.0;
  List<int> _randomCombinationSymbolIndexes = List<int>();
  //Color _animationColor = Colors.red;

  List<List<int>> chosenSymbols = List<List<int>>();

  int chosenSymbolIndex;
  int rowIndex;

  bool isCheckPressed;

  @override
  void initState() {
    super.initState();
    _getRandomCombinationSymbolIndexes();
    isCheckPressed = false;
    // for (int i = 0; i < 6; i++) {
    //   chosenSymbols.add(List<int>(4));
    //   //chosenSymbols[i].addAll(null);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TweenAnimationBuilder(
          duration: Duration(milliseconds: 15000),
          tween: Tween<double>(begin: 5.0, end: _animationValue),
          builder: (BuildContext context, double value, Widget child) {
            return Container(
              margin: EdgeInsets.all(value),
              //color: _animationColor,
              child: Image.asset(
                'assets/images/6.png',
              ),
            );
          },
          // onEnd: () {
          //   setState(() {
          //     _animationValue = _animationValue == 15.0 ? 5.0 : 15.0;
          //     // _animationColor =
          //     //     _animationColor == Colors.red ? Colors.orange : Colors.red;
          //   });
          // },
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 150.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                _getRandomCombinationSymbolIndexes();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'New Combination',
                                style: TextStyle(fontSize: 28.0),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _enterCombination(index),
                            VerticalDivider(),
                            _buildCheckFields(),
                          ],
                        ),
                      );
                    }),
                _divider(),
                _buildRandomCombination(),
                _divider(),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                      flex: 4,
                      child: RaisedButton(
                          onPressed: onCheck,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'CHECK',
                              style: TextStyle(fontSize: 28.0),
                            ),
                          )),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: RaisedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'UNDO',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          )),
                    ),
                  ]),
                ),
                Expanded(child: SizedBox()),
              ]),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [..._getSymbols()],
        ),
      ),
    );
  }

  List<Widget> _getSymbols() {
    List<Widget> symbols = List<Widget>();

    for (int i = 1; i < 7; i++) {
      symbols.add(GestureDetector(
        onTap: () => chooseSymbol(i),
        child: Container(
          height: MediaQuery.of(context).size.width / 8,
          width: MediaQuery.of(context).size.width / 8,
          color: Colors.blue,
          child: _getSymbolString(i.toString()),
        ),
      ));
    }
    return symbols;
  }

  Widget _field([int symbolIndex]) {
    return Container(
        height: MediaQuery.of(context).size.width / 10,
        width: MediaQuery.of(context).size.width / 10,
        color: Colors.blue,
        child: symbolIndex == null || symbolIndex < 1 || symbolIndex > 6
            ? null
            : _getSymbolString(symbolIndex.toString()));
  }

  Widget _checkField() {
    return Container(
      height: MediaQuery.of(context).size.width / 10,
      width: MediaQuery.of(context).size.width / 10,
      color: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.black,
        ),
        margin: EdgeInsets.all(1.0),
      ),
    );
  }

  Widget _buildRandomCombination() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _field(_randomCombinationSymbolIndexes[0]),
          _field(_randomCombinationSymbolIndexes[1]),
          _field(_randomCombinationSymbolIndexes[2]),
          _field(_randomCombinationSymbolIndexes[3]),
        ],
      ),
    );
  }

  Widget _enterCombination(int index) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < 4; i++) _field(chosenSymbols[index][i] ?? null)
        ],
      ),
    );
  }

  Widget _buildCheckFields() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _checkField(),
          _checkField(),
          _checkField(),
          _checkField(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Divider(
        height: 0,
        thickness: 2.0,
      ),
    );
  }

  Image _getSymbolString(String image) {
    return Image.asset(
      'assets/images/$image.png',
      fit: BoxFit.contain,
    );
  }

  void _getRandomCombinationSymbolIndexes() {
    chosenSymbolIndex = 0;
    rowIndex = 0;

    _randomCombinationSymbolIndexes.clear();
    for (int i = 0; i < 4; i++) {
      _randomCombinationSymbolIndexes.add(Random().nextInt(6) + 1);
    }

    chosenSymbols.clear();
    for (int i = 0; i < 6; i++) {
      chosenSymbols.add(List<int>(4));
    }
  }

  void chooseSymbol(int i) {
    //chosenSymbols.add(List<int>());

    if ((chosenSymbolIndex + 1) % 5 == 0 && isCheckPressed) {
      rowIndex++;
      chosenSymbolIndex = 0;

      isCheckPressed = false;
    }
    if (rowIndex < 6) {
      if ((chosenSymbolIndex + 1) % 5 != 0) {
        chosenSymbols[rowIndex][chosenSymbolIndex] = i;

        print(chosenSymbols);
        chosenSymbolIndex++;
        setState(() {});
      }
    }
  }

  void onCheck() {
    isCheckPressed = true;
    print("check pressed");
  }
}
