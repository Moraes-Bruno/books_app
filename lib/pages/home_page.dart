import 'package:books_app/pages/pesquisar.dart';
import 'package:flutter/material.dart';
import 'package:books_app/model/livro.dart';
import 'package:books_app/repository/sqlite_crud.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Livro>> _futureLivros;

  @override
  void initState() {
    super.initState();
    _futureLivros = _buscarLivrosSalvos();
  }

  Future<List<Livro>> _buscarLivrosSalvos() async {
    return sqliteCrud().recuperarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Meus Livros",
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
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Livro>>(
        future: _futureLivros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os livros: ${snapshot.error}'),
            );
          } else {
            final livros = snapshot.data!;
            return ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];
                return Dismissible(
                  key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment(-0.9, 0.0),
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {

                    sqliteCrud().excluirLivro(livro.getTitulo().toString());

                    setState(() {
                      livros.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 400,
                    margin: const EdgeInsets.only(top: 15),
                    child: ListTile(
                      leading: livro.getImagem() != null
                          ? Image.network(
                              livro.getImagem()!,
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : const Image(
                              image: AssetImage(
                                  "assets/images/placeholder_image.jpg")),
                      title: Text(
                        livro.getTitulo() ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 3,
                      ),
                      subtitle: Text(
                        livro.getDescricao() ?? '',
                        style: const TextStyle(fontSize: 15),
                        maxLines: 3,
                      ),
                      // Aqui você pode adicionar mais widgets para exibir informações adicionais do livro
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
