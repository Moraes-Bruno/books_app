import 'package:books_app/model/livro.dart';
import 'package:books_app/pages/home_page.dart';
import 'package:books_app/repository/livro_repository.dart';
import 'package:books_app/repository/sqlite_crud.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  LivroRepository livroRepository = LivroRepository();
  late Future<Map> listLivro;

  @override
  void initState() {
    super.initState();
    listLivro = Future.value({});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controlerBusca = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Pesquisar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Icon(Icons.book, size: 70)),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pesquisar", style: TextStyle(fontSize: 25)),
                  Icon(Icons.search_rounded, size: 25)
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Pesquisar()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Meus Livros", style: TextStyle(fontSize: 25)),
                  Icon(Icons.book, size: 25)
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Pesquisar",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                setState(() {
                  listLivro = livroRepository.buscarLivros(text);
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: listLivro,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 600,
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 5,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return _criarGridLivros(context, snapshot);
                  }
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _criarGridLivros(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 1,
        mainAxisSpacing: 5,
        childAspectRatio: 2.5,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        if (snapshot.data["items"] == null) {
          return Container();
        }

        return Container(
          color: Theme.of(context).colorScheme.tertiary,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    if (snapshot.data['items'][index]['volumeInfo']
                                ['imageLinks'] !=
                            null &&
                        snapshot.data['items'][index]['volumeInfo']
                                ['imageLinks']['thumbnail'] !=
                            null)
                      Image(
                        image: NetworkImage(snapshot.data['items'][index]
                            ['volumeInfo']['imageLinks']['thumbnail']),
                        width: 100,
                        fit: BoxFit.fitWidth,
                      )
                    else
                      const Image(
                        image:
                            AssetImage("assets/images/placeholder_image.jpg"),
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    FittedBox(
                      child: SizedBox(
                        width: 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data["items"][index]["volumeInfo"]
                                      ["title"] ??
                                  "",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 3,
                            ),
                            Text(
                              snapshot.data["items"][index]["volumeInfo"]
                                      ["description"] ??
                                  "",
                              style: const TextStyle(fontSize: 15),
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    var livro = snapshot.data['items'][index];

                    Livro novoLivro = Livro(
                      null,
                      livro['volumeInfo']['title'] ?? "",
                      livro['volumeInfo']['description'] ?? "",
                      livro['volumeInfo']['imageLinks']['thumbnail'] ?? "",
                    );

                    await sqliteCrud().salvarLista(novoLivro);

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                              "Livro favoritado com sucesso",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(Icons.favorite),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
