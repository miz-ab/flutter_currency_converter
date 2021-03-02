import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/model/Country.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';

class Setting extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting> {
  String title = "Setting";
  final String spcountrycodefrom = 'spcountrycodefrom',
      spcountrycodeto = 'spcountrycodeto';
  //String valFrom = 'USD', valTo = 'ETB';

  //String countryCodeFromspValue = 'USD', countryCodeTospValue = 'ETB';

  int selectedcountryindexfrom;
  int selectedcountryindexto;

  List<Country> _countries = Country.getCountries();

  List<DropdownMenuItem<Country>> _dropdownMenuItemsFrom;
  List<DropdownMenuItem<Country>> _dropdownMenuItemsTo;

  Country _selectedCountryFrom;
  Country _selectedCountryTo;

  List<DropdownMenuItem<Country>> buildDropdownMenuItemsFrom(List countries) {
    List<DropdownMenuItem<Country>> items = List();
    for (Country country in countries) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Country>> buildDropdownMenuItemsTo(List countries) {
    List<DropdownMenuItem<Country>> items = List();
    for (Country country in countries) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItemFrom(Country selectedCountryFrom) {
    setState(() {
      _selectedCountryFrom = selectedCountryFrom;
      print('sp from ${_selectedCountryFrom.countryCode}');
    });

    autosaveFrom();
  }

  autosaveFrom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodefrom)) {
      prefs.setString(spcountrycodefrom, "USD");
    } else {
      prefs.setString(spcountrycodefrom, _selectedCountryFrom.countryCode);
    }
  }

  onChangeDropdownItemTo(Country selectedCountryTo) {
    setState(() {
      _selectedCountryTo = selectedCountryTo;
      print('sp to ${_selectedCountryTo.countryCode}');
    });

    autosaveTo();
  }

  autosaveTo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodeto)) {
      prefs.setString(spcountrycodeto, "ETB");
    } else {
      prefs.setString(spcountrycodeto, _selectedCountryTo.countryCode);
    }
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(spcountrycodefrom)) {
      prefs.setString(spcountrycodefrom, "USD");
    } else {
      prefs.setString(spcountrycodefrom, _selectedCountryFrom.countryCode);
    }

    if (!prefs.containsKey(spcountrycodeto)) {
      prefs.setString(spcountrycodeto, "ETB");
    } else {
      prefs.setString(spcountrycodeto, _selectedCountryTo.countryCode);
    }

    Fluttertoast.showToast(
        msg: "Data Updated !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    print('sp to ${_selectedCountryTo.countryCode}');
    print('sp from ${_selectedCountryFrom.countryCode}');
  }

  @override
  void initState() {
    _dropdownMenuItemsFrom = buildDropdownMenuItemsFrom(_countries);
    _dropdownMenuItemsTo = buildDropdownMenuItemsTo(_countries);
    setTheSPstate().then((_) {
      setState(() {
        _selectedCountryFrom =
            _dropdownMenuItemsFrom[selectedcountryindexfrom].value;
        _selectedCountryTo = _dropdownMenuItemsTo[selectedcountryindexto].value;
      });
    });
    super.initState();
  }

  setTheSPstate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCodeFromspValue = prefs.getString(spcountrycodefrom) ?? "USD";
    String countryCodeTospValue = prefs.getString(spcountrycodeto) ?? "ETB";

    selectedcountryindexfrom =
        _countries.indexWhere((c) => c.countryCode == countryCodeFromspValue);
    selectedcountryindexto =
        _countries.indexWhere((c) => c.countryCode == countryCodeTospValue);

    print(
        'setting from sp $selectedcountryindexfrom and $selectedcountryindexto');
  }

  loadCountries() {
    _dropdownMenuItemsFrom = buildDropdownMenuItemsFrom(_countries);
    _dropdownMenuItemsTo = buildDropdownMenuItemsTo(_countries);

    _selectedCountryFrom =
        _dropdownMenuItemsFrom[selectedcountryindexfrom].value;
    _selectedCountryTo = _dropdownMenuItemsTo[selectedcountryindexto].value;
  }

  Future<bool> _onBackPressed() {
    print('triger on back pressed');
    return Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => MyApp(),
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onBackPressed,
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
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'From',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            DropdownButton(
                              isExpanded: true,
                              value: _selectedCountryFrom,
                              items: _dropdownMenuItemsFrom,
                              onChanged: onChangeDropdownItemFrom,
                            ),
                          ]),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'To',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                backgroundColor: Colors.white54),
                          ),
                          DropdownButton(
                            isExpanded: true,
                            value: _selectedCountryTo,
                            items: _dropdownMenuItemsTo,
                            onChanged: onChangeDropdownItemTo,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: saveData,
                    child: new Text("Save Setting"),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
