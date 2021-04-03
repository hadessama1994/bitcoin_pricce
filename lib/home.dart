import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:countup/countup.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double _valor;
  double _variacao;

  final brl = Currency.create('BRL', 2,
      symbol: 'RS');

  Future<Map> _recuperarPreco() async{
    String url = "https://www.mercadobitcoin.net/api/BTC/ticker/";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot){

        String resultado="";
        switch(snapshot.connectionState){
          case ConnectionState.none:
            break;
          case ConnectionState.done:
            if (snapshot.hasError){
              resultado: "Couldn`t get data";
            }
            else {
              _valor = double.parse(snapshot.data["ticker"]["buy"]);
               double open = double.parse(snapshot.data["ticker"]["open"]);
              _variacao = ((_valor-open)/open)*100;

            }
            break;
          case ConnectionState.active:


            break;
          case ConnectionState.waiting:
            resultado = "Loading...";
            break;
        }
        return Scaffold(
          body: Container(
            color: Color(0xfffcbf49),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(

                    onPressed: (){
                      setState(() {
                        _recuperarPreco();
                      });
                    },
                      child: Image.asset("images/coin.png", height: 250)),

                Column(
                  children: [
                    Text(resultado),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(r"R$ ",
                        style: TextStyle(
                          fontSize: 18
                        ),),
                        Countup(
                          begin: _valor.toDouble()-1000,
                          end: _valor.toDouble(),
                          duration: Duration(seconds: 1),
                          style: TextStyle (
                            fontSize: 36,
                            color: Color(0xff023047),
                            fontWeight: FontWeight.w800,
                          ),
                            separator: ',',
                          curve: Curves.fastOutSlowIn,
                          precision: 2,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ((_variacao<0) ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                            size: 40,
                            color: ((_variacao<0) ? Colors.red : Colors.green),
                          ),
                          Countup(
                            begin: 0,
                            end: _variacao.toDouble(),
                            duration: Duration(seconds: 1),
                            style: TextStyle (
                              fontSize: 28,
                              color: Color(0xff023047),
                            ),
                            separator: ',',
                            curve: Curves.fastOutSlowIn,
                            precision: 2,
                          ),
                          Text("%"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );


    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "Future"
    //     ),
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: <Widget>[
    //         Container(
    //           color: Colors.yellow,
    //           child: Padding(
    //             padding: EdgeInsets.all(32),
    //             child: Row(
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text("öi")
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Container(
    //             color: Colors.blue,
    //             child: Padding(
    //               padding: EdgeInsets.all(32),
    //               child: Row(
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text("öi")
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
