import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var REQUEST = "https://api.hgbrasil.com/weather?key=9357d670&city_name=Angical";

void main() async{
  print(await pegarDados());
  runApp(MyApp());
}

Future<Map> pegarDados()async{
  http.Response resposta = await http.get(REQUEST);
  return json.decode(resposta.body);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var _temperatura;
    var _cidade;

    return Scaffold(
      appBar: AppBar(
        title: Text("City Clima"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: pegarDados(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados"),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro ao obter dados"),
                );
              }else{
                _temperatura = snapshot.data["results"]["temp"];
                _cidade = snapshot.data["results"]["city_name"];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$_cidade, $_temperatura"),
                      ],
                    ),
                    textFormCity(_cityNameController, "insira uma informação", "nome da cidade")
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget textFormCity (TextEditingController controller, String error, String label){
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }

}