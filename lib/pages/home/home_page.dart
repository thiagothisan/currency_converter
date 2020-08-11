import 'package:currency_converter/pages/home/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

const request = 'https://api.hgbrasil.com/finance';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();
  double dollar = 0.0;
  double euro = 0.0;

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
    realController.text = (euro * this.euro).toStringAsFixed(2);
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }

  Future<Map> _getData() async {
    http.Response response = await http.get(request);
    print(json.decode(response.body));

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Converter \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: _getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                if (snapshot.data.containsKey("error")) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "${snapshot.data["message"]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ));
                } else {
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo.png',
                            height: 140,
                            color: Colors.amber,
                          ),
                          Divider(),
                          TextFieldWidget(
                            label: "R\$ Reais",
                            prefix: "R\$",
                            controller: realController,
                            function: _realChanged,
                          ),
                          Divider(),
                          TextFieldWidget(
                              label: "US\$ Dollars",
                              prefix: "US\$",
                              controller: dollarController,
                              function: _dollarChanged),
                          Divider(),
                          TextFieldWidget(
                            label: "€ Euros",
                            prefix: "€",
                            controller: euroController,
                            function: _euroChanged,
                          ),
                          Divider(),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.7,
                                color: Colors.amber,
                              ),
                            ),
                            child: RaisedButton(
                              color: Colors.amber,
                              highlightColor: Colors.transparent,
                              elevation: 0,
                              disabledElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              hoverElevation: 0,
                              splashColor: Colors.black,
                              onPressed: () {
                                _clearAll();
                              },
                              child: Text(
                                "Clear",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }
}
