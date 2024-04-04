import 'package:books_app/model/livro.dart';
import 'package:books_app/repository/livro_repository.dart';
import 'package:flutter/material.dart';

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
                      )
                    else
                      const Image(
                          image: AssetImage(
                              "assets/images/placeholder_image.jpg")),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data["items"][index]["volumeInfo"]
                                ["title"],
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            snapshot.data["items"][index]["volumeInfo"]
                                ["description"] + "...",
                            style: const TextStyle(fontSize: 15),
                            maxLines: 3,
                          )
                        ],
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
                  onTap: () {},
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
