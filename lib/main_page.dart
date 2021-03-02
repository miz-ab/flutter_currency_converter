import 'dart:async';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/servies/CheckInternetCon.dart';
import 'package:fluttertest/servies/api_services.dart';
import 'package:fluttertest/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: cancel_subscriptions
  StreamSubscription<DataConnectionStatus> listener;
  String amountVal = '0.0', fromCurrency = '', tocurrency = '';
  double ratio = 0.0;
  String title = 'Currency Converter';
  //String title = 'Currency Converter';
  final String spcountrycodefrom = 'spcountrycodefrom',
      spcountrycodeto = 'spcountrycodeto';

  TextEditingController amountController = TextEditingController();

  //for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _validateInputsStatus = false;
  bool loading = true;

  //get all currencies
  getAllCurrencyList() async {
    await ApiServices().getListofc();
    setState(() {
      loading = false;
    });
  } //getallcurencylist

  Future<double> getCC() async {
    bool connectionResult = await DataConnectionChecker().hasConnection;
    if (connectionResult) {
      ratio = (await ApiServices().convertCC()).toDouble();
    } else {
      title = 'waiting for network..';
    }
    return ratio;
  }

  loadCurrentCurrencyCode() async {
    //get current setting from SP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fromCurrency = prefs.getString(spcountrycodefrom) ?? "USD";
      tocurrency = prefs.getString(spcountrycodeto) ?? "ETB";
    });
  }

  getAmount() {
    getCC().then((_) {
      amountVal = '0.0';
      setState(() {
        //amountVal = amountController.text;
        amountVal = (double.parse(amountController.text) * ratio)
            .toStringAsFixed(3)
            .toString();
      });
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Setting':
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Setting(),
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    CheckInternetCon().listener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //optional way ... to check internet connection
    //CheckInternetCon().checkConnection(context);
    loadCurrentCurrencyCode();
    connectionStatus();
    getCC();
    super.initState();
  }

  connectionStatus() async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          setState(() {
            title = 'Currency Converter';
          });
          break;
        case DataConnectionStatus.disconnected:
          setState(() {
            title = 'waiting for network..';
          });
          break;
      }
    });
  }

  //validate user input
  void validateInputs() {
    print('validate inputs');
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState.save();
      _validateInputsStatus = true;
    } else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
        _validateInputsStatus = false;
      });
    }
  }

  //exit app when on back pressed
  Future<bool> _onBackPressedExitApp() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit the App'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    exit(0);
                    // Navigator.of(context).pop(true); //Will exit the App
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onBackPressedExitApp,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            )),
        home: Scaffold(
          appBar: AppBar(
            title: Text('$title'),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Setting'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: new Form(
                key: _formKey,
                // ignore: deprecated_member_use
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    Card(
                      margin: const EdgeInsets.all(0.1),
                      elevation: 0.0,
                      child: SizedBox(
                        height: 20.0,
                        child: InkWell(
                          splashColor: Colors.lightBlue,
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                'From $fromCurrency',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.black),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the amount ..',
                        labelText: 'Amount',
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      validator: validateNumber,
                      onSaved: (String str) {
                        amountController.text = str;
                        amountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: amountController.text.length));
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Card(
                      margin: const EdgeInsets.all(0.1),
                      color: Colors.white54,
                      elevation: 0.0,
                      child: SizedBox(
                        height: 50.0,
                        child: InkWell(
                          splashColor: Colors.lightBlue,
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                '$amountVal $tocurrency',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            width: double.maxFinite,
                            child: RaisedButton(
                              onPressed: () => {
                                validateInputs(),
                                if (_validateInputsStatus)
                                  {
                                    getAmount(),
                                  },
                              },
                              child: Text(
                                'Convert',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              color: Colors.blue,
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.1),
                              elevation: 5.0,
                            )),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  String validateNumber(String str) {
    if (str == '') {
      return "Enter the amount";
    } else if (!_isNumeric(str)) {
      return "Enter Number only characters";
    } else {
      return null;
    }
  } //validate

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
}
