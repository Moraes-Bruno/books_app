import 'package:books_app/pages/pesquisar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Meus Livros",style: TextStyle
        (fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      drawer:  Drawer(
        child: ListView(
          children:  [
            const DrawerHeader(child: Icon(Icons.book,size: 70,)),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pesquisar",style: TextStyle(fontSize: 25),),
                  Icon(Icons.search_rounded,size: 25)
                ],
              ),
              onTap: (){
                 Navigator.push(context,MaterialPageRoute(builder: (context) => const Pesquisar()));
              },
            )
          ],
        ),
      ),
      body: const Column(
        children: [],
      )
    );
  }
}