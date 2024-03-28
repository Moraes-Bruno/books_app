import 'package:flutter/material.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Pesquisar",style: TextStyle
        (color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
         iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar",
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}