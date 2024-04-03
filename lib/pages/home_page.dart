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
        backgroundColor: Colors.deepPurple,
        title: const Text("Meus Livros",style: TextStyle
        (color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
         iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer:  Drawer(
        child: ListView(
          children:  [
            const DrawerHeader(child: Icon(Icons.book,size: 60,)),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pesquisar"),
                  Icon(Icons.search_rounded)
                ],
              ),
              onTap: (){
                 Navigator.push(context,MaterialPageRoute(builder: (context) => const Pesquisar()));
              },
            )
          ],
        ),
      ),
      body: const Placeholder(),
    );
  }
}