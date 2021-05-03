import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Currency Converter",
      home: AnimatedSplashScreen(
        splashIconSize: 100000,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.black,
        splash: 


             ClipRRect(
                child: Image.asset(
                  'assets/CurrencyConverter.jpg',
                ),
              ),

        
        nextScreen: CurrencyConverter(),
      ),

      debugShowCheckedModeBanner: false,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  List<String> currencies;
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String result = "";

  final fromTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://api.openrates.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map currencyMap = responseBody['rates'];
    currencies = currencyMap.keys.toList(); //get key of the map to list
    setState(() {}); //application know currencies loaded
//    print(currencies);
    return "Success";
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      iconSize: 34,
      elevation: 0,
      dropdownColor: Colors.black,
      style: TextStyle(color: Colors.white),
      /*underline: Container(
        height: 2,
        color: Colors.black,
      ),*/
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
              value: value,
              child: Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                ],
              )))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }

  Future<String> _doConversion() async {
    String uri =
        "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromDisplayController.text) *
              responseBody["rates"][toCurrency])
          .toStringAsFixed(3);
    });
    print(result);

    return "Sucess";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  var isDouble = false;
  double minimumPadding = 5.0;

  Widget buildButton(String text, Function handler) {
    return Expanded(
      child: FlatButton(
        color: Colors.transparent,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
            )),
        onPressed: handler,
      ),
    );
  }

  TextEditingController fromDisplayController = TextEditingController();
  int i = 1;
  void digitHandler(String char) {
    if (this.i <= 8) {
      fromDisplayController.text = fromDisplayController.text + char;
      i++;
    } else {
      fromDisplayController.text = fromDisplayController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final toTextController = TextEditingController(
      text: result != null ? result : "",
    );

    void pointHandler() {
      if (isDouble == false) {
        fromDisplayController.text = fromDisplayController.text + '.';
        isDouble = true;
        this.i++;
      }
    }

    void delHandler() {
      String result = fromDisplayController.text;
      if (result.length > 0) {
        toTextController.clear();
        if (result.endsWith('.')) {
          isDouble = false;
        }
        fromDisplayController.text = result.substring(0, result.length - 1);
        this.i--;
      } else if (result.length == 0) {
        fromDisplayController.clear();
      }
    }

    return Scaffold(
      /*appBar: AppBar(
        title: Text("Currency Converter"),
      ), */
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              //  height: MediaQuery.of(context).size.width ,
              //   width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.6),
                    tileMode: TileMode.clamp,
                    colors: [
                      Colors.blueGrey[900],
                      Colors.purple[800],
                      Colors.red[900]
                    ]),
              ),

              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Center(
                      child: Text(
                    "Currency Converter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: ListTile(
                        title: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          textDirection: TextDirection.ltr,
                          controller: fromDisplayController,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold),
                          keyboardAppearance: Brightness.dark,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 130.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.white,
                            ),
                            iconSize: 60.0,
                            onPressed: _doConversion),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: ListTile(
                        title: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          textDirection: TextDirection.ltr,
                          controller: toTextController,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold),
                          keyboardAppearance: Brightness.dark,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*  label: result != null
                              ? Text(
                                  result,
                                  style: Theme.of(context).textTheme.display1,
                                )
                              : Text(""), */
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: Row(
                            children: <Widget>[
                              buildButton('7', () {
                                digitHandler('7');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('8', () {
                                digitHandler('8');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('9', () {
                                digitHandler('9');
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: Row(
                            children: <Widget>[
                              buildButton('4', () {
                                digitHandler('4');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('5', () {
                                digitHandler('5');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('6', () {
                                digitHandler('6');
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: Row(
                            children: <Widget>[
                              buildButton('1', () {
                                digitHandler('1');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('2', () {
                                digitHandler('2');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('3', () {
                                digitHandler('3');
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: Row(
                            children: <Widget>[
                              buildButton('C', () {
                                delHandler();
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('0', () {
                                digitHandler('0');
                              }),
                              SizedBox(
                                width: minimumPadding,
                              ),
                              buildButton('.', () {
                                pointHandler();
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
