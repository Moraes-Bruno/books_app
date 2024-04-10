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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    setState(() {
      _futureLivros = _buscarLivrosSalvos();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
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
            ),
            const SizedBox(height: 10,),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Meus Livros", style: TextStyle(fontSize: 25)),
                  Icon(Icons.book, size: 25)
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()));
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
            return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _carregarLivros,
                child: ListView.builder(
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];
                    return Dismissible(
                      key:
                          Key(DateTime.now().microsecondsSinceEpoch.toString()),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          color: Theme.of(context).colorScheme.tertiary,
                          height: 120,
                          width: 400,
                          margin: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            leading: Image.network(
                                    livro.getImagem()!,
                                    height: 100,
                                  ),
                            title:  Text(
                              livro.getTitulo() ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              livro.getDescricao() ?? '',
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                            ),
                            // Aqui você pode adicionar mais widgets para exibir informações adicionais do livro
                          ),
                        ),
                      ),
                    );
                  },
                ));
          }
        },
      ),
    );
  }
}
