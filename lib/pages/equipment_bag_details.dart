import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BagDetails extends StatefulWidget {
  var _dbName;
  String _name;
  BagDetails(String dbName, String name) {
    _dbName = dbName;
    _name = name;
  }
  @override
  _bagDetailsState createState() => _bagDetailsState(_dbName, _name);
}

class _bagDetailsState extends State<BagDetails> {
  var names = [
    'Bp apparatus',
    'Crepe',
    'Deep heat',
    'Depressors',
    'Face masks',
    'Gauze',
    'Gloves',
    'ORS',
    'Open wove',
    'Polyfax',
    'Polyfax plus',
    'Pyodine',
    'Saniplast',
    'Scissors',
    'Stethoscope',
    'Tape',
    'Thermometer',
    'Triangular bandage',
    'Wintogeno',
  ];

  var dbName = [
    'bpApparatus',
    'crepe',
    'deepHeat',
    'depressors',
    'faceMasks',
    'gauze',
    'gloves',
    'openWove',
    'ors',
    'polyfax',
    'polyfaxPlus',
    'pyodine',
    'saniplast',
    'scissors',
    'stethoscope',
    'tape',
    'thermomter',
    'triangularBandage',
    'wintogeno'
  ];
  var data = [];
  var list = new List<int>.generate(19, (i) => i + 1);
  var updatedOrNot = new List<int>.generate(19, (i) => 0);
  var _name;
  var Controller = new List<TextEditingController>.generate(
      19, (i) => new TextEditingController());
  var updatedData = [];
  var _Name;
  _bagDetailsState(String DbName, String Name) {

    var _Data = Firestore.instance
        .collection('EquipmentBags')
        .document(DbName)
        .get()
        .then((doc) {
      setState(() {
        for (var i in names) {
          data.add(doc[i]);
        }
      });
    });
    _name = Name;
    _Name = DbName;
    print(_Name);
    updatedData = data;
    print(data.length);
    print(list.length);
    print(dbName.length);
    print(names.length);
  }

  _updateData(index, value) async {
    try {
      await Firestore.instance
          .collection('EquipmentBags')
          .document(_Name)
          .updateData({dbName[index]: int.parse(value)});
    } catch (e) {
      throw (e);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, ((e) => null)) != null;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff142850),
              title: Text(
                _name,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueLight',
                  letterSpacing: 2.0,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: const Color(0xff27496d),
            body: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    child: FittedBox(
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text(
                                'Items',
                                style: TextStyle(
                                  fontFamily: 'HelveticaNeueBold',
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )),
                          DataColumn(
                              label: SizedBox(
                                width: 7,
                              )),
                          DataColumn(
                              label: Text(
                                ' Quantity',
                                style: TextStyle(
                                  fontFamily: 'HelveticaNeueBold',
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                        rows: list.map((value) {
                          return DataRow(cells: [
                            DataCell(Text(
                              names[value - 1],
                              style: TextStyle(
                                fontFamily: 'HelveticaNeueLight',
                                letterSpacing: 2.0,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            )),
                            DataCell(Text('')),
                            DataCell(
                              SizedBox(
                                  width: 100.0,
                                  height: 45.0,
                                  child: TextFormField(
                                    controller: Controller[value - 1],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      hintText: data[value - 1].toString(),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[700],
                                        fontFamily: 'HelveticaNeueLight',
                                        letterSpacing: 2.0,
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.amber,
                                        letterSpacing: 1.0,
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.20, height * 0.1, width * 0.16, 10.0),
                      child: SizedBox(
                          width: (width + height) * 0.18,
                          height: (width + height) * 0.04,
                          child: RaisedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Are you sure?",
                                          style: TextStyle(
                                            fontFamily: 'HelveticaNeueLight',
                                            letterSpacing: 2.0,
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'YES',
                                              style: TextStyle(
                                                fontFamily: 'HelveticaNeueLight',
                                                letterSpacing: 3.0,
                                                fontSize: 20,
                                                color: const Color(0xff1a832a),
                                              ),
                                            ),
                                            onPressed: () async {
                                              for (var i in list) {
                                                var data = Controller[i - 1].text;

                                                if (data != '') {
                                                  if (!isNumeric(data)) {
                                                    print('NOT A NUMBER');
                                                    return showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Quantity must be a number!",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'HelveticaNeueLight',
                                                                letterSpacing: 2.0,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'HelveticaNeueLight',
                                                                    letterSpacing:
                                                                    2.5,
                                                                    fontSize: 20,
                                                                    color: const Color(
                                                                        0xff1a832a),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else if (double.parse(data) <
                                                      0) {
                                                    return showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Quantity cannot be less than zero!",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'HelveticaNeueLight',
                                                                letterSpacing: 2.0,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'HelveticaNeueLight',
                                                                    letterSpacing:
                                                                    2.5,
                                                                    fontSize: 20,
                                                                    color: const Color(
                                                                        0xff1a832a),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else if (RegExp(r"^(\d*\.)\d+$")
                                                      .hasMatch(data)) {
                                                    return showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Quantity cannot be in decimals!",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'HelveticaNeueLight',
                                                                letterSpacing: 2.0,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'HelveticaNeueLight',
                                                                    letterSpacing:
                                                                    2.5,
                                                                    fontSize: 20,
                                                                    color: const Color(
                                                                        0xff1a832a),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                }
                                              }
                                              for (var i in list) {
                                                var data = Controller[i - 1].text;
                                                if (data != '') {
                                                  _updateData(i - 1, data);
                                                }
                                              }
                                              return showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Inventory has been updated!",
                                                        style: TextStyle(
                                                          fontFamily:
                                                          'HelveticaNeueLight',
                                                          letterSpacing: 2.0,
                                                          fontSize: 20,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text(
                                                            'OK',
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'HelveticaNeueLight',
                                                              letterSpacing: 2.5,
                                                              fontSize: 20,
                                                              color: const Color(
                                                                  0xff1a832a),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                            Navigator.of(context)
                                                                .pop();
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'NO',
                                              style: TextStyle(
                                                fontFamily: 'HelveticaNeueLight',
                                                letterSpacing: 2.5,
                                                fontSize: 20,
                                                color: const Color(0xffee0000),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              textColor: Colors.cyan[500],
                              color: const Color(0xFF73CDE8),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (width + height) * 0.012,
                                  letterSpacing: 3.0,
                                  fontFamily: 'HelveticaNeueBold',
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )))),
                ]))
        ));
  }
}
